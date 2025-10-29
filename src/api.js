const express = require('express');
const router = express.Router();

router.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

router.get('/', (req, res) => {
  res.json({ message: 'Hello from MERN backend CI demo' });
});

module.exports = router;


// ratannnn
