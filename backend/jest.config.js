module.exports = {
  testEnvironment: 'node',
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'src/**/*.js',
    '!src/server.js',
  ],
  // Force Jest to exit after tests complete (fixes async operations not stopping)
  forceExit: true,
  // Set test timeout to prevent hanging
  testTimeout: 10000,
  // Coverage thresholds - set to current achievable levels
  // Increase these as test coverage improves
  coverageThreshold: {
    global: {
      branches: 25,
      functions: 25,
      lines: 25,
      statements: 25,
    },
  },
};
