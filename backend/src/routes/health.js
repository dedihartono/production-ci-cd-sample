const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
    version: '1.0.0',
  });
});

router.get('/ready', (req, res) => {
  // Add readiness checks here (database, external services, etc.)
  res.status(200).json({
    status: 'ready',
    timestamp: new Date().toISOString(),
  });
});

router.get('/live', (req, res) => {
  // Liveness check
  res.status(200).json({
    status: 'alive',
    timestamp: new Date().toISOString(),
  });
});

module.exports = router;
