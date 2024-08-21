module.exports = {
  testEnvironment: "jest-environment-jsdom",
  transform: {
    "^.+\\.(ts|tsx)$": "babel-jest", // TypeScriptファイルをトランスパイル
    "^.+\\.(js|jsx)$": "babel-jest", // JavaScriptファイルもトランスパイル
  },
  moduleFileExtensions: ["ts", "tsx", "js", "jsx"], // 拡張子を追加
  setupFilesAfterEnv: ["<rootDir>/setupTests.ts"],
  moduleNameMapper: {
    "\\.(css|less|scss|sass)$": "identity-obj-proxy",
  },
};
