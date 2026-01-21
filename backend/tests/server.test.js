const request = require('supertest');
const app = require('../src/server');

describe('Server Health Checks', () => {
  test('GET /health should return 200', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('healthy');
    expect(response.body).toHaveProperty('timestamp');
    expect(response.body).toHaveProperty('uptime');
  });

  test('GET /health/ready should return 200', async () => {
    const response = await request(app).get('/health/ready');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('ready');
  });

  test('GET /health/live should return 200', async () => {
    const response = await request(app).get('/health/live');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('alive');
  });
});

describe('Portfolio API', () => {
  test('GET / should return API info', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('message');
    expect(response.body).toHaveProperty('version');
  });

  test('GET /api/portfolio should return portfolio data', async () => {
    const response = await request(app).get('/api/portfolio');
    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
    expect(response.body.data).toHaveProperty('name');
    expect(response.body.data).toHaveProperty('skills');
  });

  test('GET /api/portfolio/projects should return projects', async () => {
    const response = await request(app).get('/api/portfolio/projects');
    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
    expect(Array.isArray(response.body.data)).toBe(true);
  });

  test('GET /api/portfolio/projects/:id should return specific project', async () => {
    const response = await request(app).get('/api/portfolio/projects/1');
    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
    expect(response.body.data).toHaveProperty('id');
    expect(response.body.data).toHaveProperty('title');
  });

  test('GET /api/portfolio/projects/:id with invalid id should return 404', async () => {
    const response = await request(app).get('/api/portfolio/projects/999');
    expect(response.status).toBe(404);
    expect(response.body.success).toBe(false);
  });
});

describe('Error Handling', () => {
  test('GET /nonexistent should return 404', async () => {
    const response = await request(app).get('/nonexistent');
    expect(response.status).toBe(404);
    expect(response.body).toHaveProperty('error');
  });
});
