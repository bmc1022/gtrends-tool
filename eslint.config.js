const prettier = require("eslint-config-prettier");

module.exports = [
  prettier,
  {
    ignores: ["**/reports/**", "**/assets/builds/**"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module"
    },
    rules: {
      quotes: ["error", "double"],
      "max-len": ["error", 100],
      "spaced-comment": ["error", "always", { markers: ["="] }]
    }
  }
];
