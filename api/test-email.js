const nodemailer = require('nodemailer');

module.exports = async (req, res) => {
  const { to } = req.query;
  if (!to) {
    return res.status(400).json({ error: 'Provide a "to" email address. Example: /api/test-email?to=test@example.com' });
  }

  const smtpUser = process.env.EMAIL_SMTP_USER;
  const smtpPass = process.env.EMAIL_SMTP_PASS;

  if (!smtpUser || !smtpPass) {
    return res.status(500).json({ error: 'SMTP credentials missing from environment' });
  }

  const transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    secure: true,
    auth: {
      user: smtpUser,
      pass: smtpPass,
    },
    debug: true, // Enable debug logs in nodemailer
    logger: true // Enable SMTP traffic logger
  });

  const mailOptions = {
    from: `"Agarwal Knowledge Hub" <${smtpUser}>`,
    to: to,
    subject: `Test Verification OTP`,
    text: `Your test verification code is 999999.`,
  };

  const logs = [];
  const logStream = {
    write: (msg) => logs.push(msg.trim())
  };

  // Temporarily hijack console.log/console.error inside nodemailer logger
  transporter.on('log', (entry) => {
    logs.push(`[Nodemailer]: ${entry.message}`);
  });

  try {
    const info = await transporter.sendMail(mailOptions);
    return res.status(200).json({
      success: true,
      info: info,
      logs: logs
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      error: error.message,
      stack: error.stack,
      logs: logs
    });
  }
};
