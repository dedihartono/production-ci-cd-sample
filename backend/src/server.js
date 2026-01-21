require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const portfolioRoutes = require('./routes/portfolio');
const healthRoutes = require('./routes/health');
const errorHandler = require('./middleware/errorHandler');

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_URL || '*',
  credentials: true,
}));

// Body parsing middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging middleware
app.use((req, res, next) => {
  if (NODE_ENV === 'development') {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  }
  next();
});

// Routes
app.use('/health', healthRoutes);
app.use('/api/portfolio', portfolioRoutes);

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Portfolio API',
    version: '1.0.0',
    environment: NODE_ENV,
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not Found' });
});

// Error handler
app.use(errorHandler);

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT} in ${NODE_ENV} mode`);
});

module.exports = app;
