module.exports = {
  preset: "ts-jest",
  testEnvironment: "node",
  moduleNameMapper: {
    "@exmpl/(.*)": "<rootDir>/test/$1",
  },
};
