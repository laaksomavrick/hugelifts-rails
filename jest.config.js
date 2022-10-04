const config = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/setupTests.js'],
  testMatch: ["**/app/javascript/*.spec.js"]
};

module.exports = config;
