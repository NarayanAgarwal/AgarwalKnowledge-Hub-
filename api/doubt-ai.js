const https = require('https');

module.exports = async (req, res) => {
  // Enable CORS
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

  const { query } = req.body || {};
  if (!query) {
    res.status(400).json({ error: 'Query parameter is required' });
    return;
  }

  // Read the Gemini API Key from Vercel Environment Variables
  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    res.status(500).json({ error: 'GEMINI_API_KEY environment variable is not configured on Vercel dashboard.' });
    return;
  }

  const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`;

  const postData = JSON.stringify({
    contents: [
      {
        parts: [
          {
            text: `System Instruction: You are the AI Doubt Assistant at Agarwal Knowledge Hub for school children. Explain academic doubts in extremely simple language with concrete everyday examples. Do not use double asterisks (**) or backticks (\`) in your response. Keep headings simple. If the query is in Hindi or roman Hindi (Hinglish), reply in simple Hindi. Make sure to cover the user's specific query fully. Here is the question: ${query}`
          }
        ]
      }
    ]
  });

  const options = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': Buffer.byteLength(postData)
    }
  };

  const geminiReq = https.request(url, options, (geminiRes) => {
    let data = '';
    geminiRes.on('data', (chunk) => {
      data += chunk;
    });
    geminiRes.on('end', () => {
      try {
        const parsed = JSON.parse(data);
        if (parsed.candidates && parsed.candidates[0] && parsed.candidates[0].content && parsed.candidates[0].content.parts[0]) {
          const reply = parsed.candidates[0].content.parts[0].text;
          res.status(200).json({ reply });
        } else {
          res.status(500).json({ error: 'Invalid response from Gemini API', details: parsed });
        }
      } catch (err) {
        res.status(500).json({ error: 'Failed to parse Gemini response', raw: data });
      }
    });
  });

  geminiReq.on('error', (err) => {
    res.status(500).json({ error: 'Gemini request failed', details: err.message });
  });

  geminiReq.write(postData);
  geminiReq.end();
};
