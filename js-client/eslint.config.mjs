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
    // This block is what makes `@nx/dependency-checks` run on package.json (it is
    // listed in pipe's lintFilePatterns). Without a `**/*.json` block, ESLint flat
    // config matches no configuration for package.json and silently skips it
    // ("File ignored because no matching configuration was supplied"), so
    // dependency-checks would stop enforcing declared vs. used deps.
    files: ["**/*.json"],
    languageOptions: {
      parser: jsoncParser,
    },
    rules: {
      // The shared @leancodepl base config enables type-aware TS rules globally
      // (no `files` scope), so they also try to run on JSON files under the JSON
      // parser and crash. Turn the offending one off here; dependency-checks is
      // the only rule we actually want to lint JSON with.
      "@typescript-eslint/naming-convention": "off",
      "@nx/dependency-checks": "error",
    },
  },
]

export default config
