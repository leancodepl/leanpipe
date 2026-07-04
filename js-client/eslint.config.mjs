import nx from "@nx/eslint-plugin"
import { base, imports } from "@leancodepl/eslint-config"
import jsoncParser from "jsonc-eslint-parser"

const config = [
  ...nx.configs["flat/base"],
  ...nx.configs["flat/typescript"],
  ...nx.configs["flat/javascript"],
  ...base,
  ...imports,
  {
    ignores: ["**/dist", "**/*.timestamp*"],
  },
  {
    files: ["*.ts", "*.tsx", "*.js", "*.jsx", "*.mjs", "*.cjs", "*.mts", "*.cts"],
    rules: {
      "@nx/enforce-module-boundaries": [
        "error",
        {
          enforceBuildableLibDependency: true,
          allow: ["./eslint.config.mjs"],
          depConstraints: [
            {
              sourceTag: "*",
              onlyDependOnLibsWithTags: ["*"],
            },
          ],
        },
      ],
    },
  },
  {
    files: ["**/*.json"],
    languageOptions: {
      parser: jsoncParser,
    },
    rules: {
      // The shared @leancodepl base config enables type-aware TS rules globally
      // (no `files` scope); they cannot run under the JSON parser, so turn them
      // off for JSON files. dependency-checks is the only rule we lint JSON with.
      "@typescript-eslint/naming-convention": "off",
      "@nx/dependency-checks": "error",
    },
  },
]

export default config
