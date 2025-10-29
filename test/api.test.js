const request = require('supertest');
const app = require('../src/index');

describe('API basic tests', () => {
  test('GET /api/health returns status ok', async () => {
    const res = await request(app).get('/api/health');
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('status', 'ok');
  });

  test('GET / returns Hello message', async () => {
    const res = await request(app).get('/');
    expect(res.statusCode).toBe(200);
    expect(res.text).toMatch(/MERN backend CI demo running/);
  });
});
