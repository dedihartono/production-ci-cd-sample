const express = require('express');
const router = express.Router();
const portfolioController = require('../controllers/portfolioController');

router.get('/', portfolioController.getPortfolio);
router.get('/projects', portfolioController.getProjects);
router.get('/projects/:id', portfolioController.getProjectById);

module.exports = router;
