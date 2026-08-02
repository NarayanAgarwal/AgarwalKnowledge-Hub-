const nodemailer = require('nodemailer');

module.exports = async (req, res) => {
  // CORS Headers
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );

  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({ error: 'Missing email or otp in request body' });
  }

  const smtpUser = process.env.EMAIL_SMTP_USER;
  const smtpPass = process.env.EMAIL_SMTP_PASS;

  if (!smtpUser || !smtpPass) {
    return res.status(500).json({
      error: 'SMTP credentials not configured. Please set EMAIL_SMTP_USER and EMAIL_SMTP_PASS environment variables.'
    });
  }

  // Create transporter
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: smtpUser,
      pass: smtpPass,
    },
  });

  const mailOptions = {
    from: `"Agarwal Knowledge Hub" <${smtpUser}>`,
    to: email,
    subject: `Email Verification OTP: ${otp}`,
    html: `
      <div style="font-family: Arial, sans-serif; padding: 20px; background-color: #f4f6f9; border-radius: 12px; max-width: 600px; margin: 0 auto; border: 1px solid #e1e8ed;">
        <h2 style="color: #1E3C72; margin-bottom: 10px; text-align: center;">Agarwal Knowledge Hub 🎒</h2>
        <hr style="border: 0; border-top: 1px solid #e1e8ed; margin-bottom: 20px;" />
        <p style="font-size: 16px; color: #2c3e50;">Hello Student,</p>
        <p style="font-size: 16px; color: #2c3e50; line-height: 1.5;">To verify your email address and securely log in or register, please use the following 6-digit verification code (OTP):</p>
        <div style="text-align: center; margin: 30px 0;">
          <span style="font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #1E3C72; background-color: #ffffff; padding: 12px 24px; border-radius: 8px; border: 1px dashed #1E3C72;">${otp}</span>
        </div>
        <p style="font-size: 14px; color: #7f8c8d; line-height: 1.5;">This OTP is valid for 10 minutes. If you did not request this code, please ignore this email or contact support.</p>
        <hr style="border: 0; border-top: 1px solid #e1e8ed; margin: 20px 0;" />
        <p style="font-size: 12px; color: #95a5a6; text-align: center;">&copy; 2026 Agarwal Knowledge Hub. All rights reserved.</p>
      </div>
    `,
  };

  try {
    await transporter.sendMail(mailOptions);
    return res.status(200).json({ success: true, message: 'Verification email sent successfully!' });
  } catch (error) {
    console.error('Error sending email: ', error);
    return res.status(500).json({ error: 'Failed to send email: ' + error.message });
  }
};
