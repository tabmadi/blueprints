# Blueprints

The index of my GitHub templates and example projects. I start new work from one of these blueprints, not from zero. This repo tracks each one as a git submodule, so I can browse, update, and keep them in step from one place.

## Layout

| Path | Holds |
| --- | --- |
| `templates/` | Bases to start a new project from |
| `examples/` | Projects that each teach one stack or integration |
| `tools/` | The shared code that every template runs: tabkit |
| `scripts/` | Scripts that act on every submodule at once |

## Conventions

Every template follows one documentation convention and one toolchain. This repo exists to keep them the same in every template. The examples keep their own toolchain and docs, and these conventions do not apply to them.

- **Simple English, no emoji.** This applies to every README, doc, comment, and `AGENTS.md`. tabkit checks it.
- **Each kind of doc has one place.** The README helps a reader choose the repo and start. `docs/` holds procedures and lookups. An ADR holds a decision.
- **One toolchain shape.** Nix pins every tool, and `just` runs every task. Every repo has the recipes `setup`, `format`, `lint`, `test`, `check`, and `ci`, and its git hooks and CI workflow both run `just ci`.
- **The size depends on the kind of repo.** A rule that is right for a platform is too heavy for a small template.

| Size | Repos | README sections | ADRs | Requirements |
| --- | --- | --- | --- | --- |
| Platform | `sovereign-platform-template`, `nextjs-mvp-template` | Platform, per ADR-0001 | A full set, with the shared toolchain ADRs 0100 to 0105 | ADR-0602 and requirements files with IDs that tests cite |
| Template | The other templates | Template, per ADR-0001 | 0000 foundations, 0001 doc rules, the shared toolchain ADRs 0100 to 0105, and 0110 for the language | The rule in ADR-0001 only. The sample has no requirements file |

### Where the convention lives

| Source | Holds |
| --- | --- |
| [github-project-template](https://github.com/tabmadi/github-project-template) | The files that every repo copies: ADR-0001, the configs in `.config/`, and the GitHub forms |
| [tabkit](https://github.com/tabmadi/tabkit), in `tools/` | The shared code: the rules and generators, the dev shell, the git hooks, the checks, the opt-in modules for templates, Bun, Go, and shell, and the NixOS modules |
| ADR-0001 in `sovereign-platform-template` | The long form of the doc rules, for a platform |

### Keeping the copies in sync

Text that a person reads is copied into each repo, so the repo stands on its own. Code that runs is shared: tabkit ships it, each repo pins a tag, and its gate decides when to move. Renovate keeps the pins current.

To change a copied rule:

1. Change it in its source repo first.
2. In the same pass, apply the change to every repo of that size.
3. Run `scripts/check-drift.sh`. It fails when a shared file of a template on the Nix baseline differs from github-project-template. A platform keeps its long form of ADR-0001, and only its section of shared terms must match. A platform can also add its own package rules and custom managers to `.github/renovate.json`, and the rest must match. Any template can add its own lines after the shared lines of `.gitattributes`.

## Templates

| Template | Size | Description |
| --- | --- | --- |
| [github-project-template](https://github.com/tabmadi/github-project-template) | Template | The language-agnostic base: community files, issue and PR forms, the pinned toolchain, git hooks, the CI gate, and the doc rules |
| [go-template](https://github.com/tabmadi/go-template) | Template | Go with the Standard Go Project Layout, every `golangci-lint` linter, and a static binary |
| [python-template](https://github.com/tabmadi/python-template) | Template | Python with the `src` layout, `uv`, `ruff` with every rule, `pyrefly`, and `pytest` |
| [php-template](https://github.com/tabmadi/php-template) | Template | PHP command-line projects and packages with Composer, Mago, and PHPUnit |
| [ts-template](https://github.com/tabmadi/ts-template) | Template | TypeScript on Bun with Biome and a strict `tsconfig`, and no build step |
| [nextjs-mvp-template](https://github.com/tabmadi/nextjs-mvp-template) | Platform | A Next.js modular monolith for one product, one deployable, and one team, with ADR-driven docs. It runs at a provider, or on one NixOS machine of your own |
| [sovereign-platform-template](https://github.com/tabmadi/sovereign-platform-template) | Platform | A self-hosted platform monorepo, with every reusable decision recorded as an ADR and enforced in CI |

### Self-hosted: which template

One rule draws the line. One machine without an orchestrator is the `self-hosted` mode of `nextjs-mvp-template`. More than one machine, or Kubernetes, is `sovereign-platform-template`.

## Examples

| Example | Status | Description |
| --- | --- | --- |
| [central-limit-order-book-example](https://github.com/tabmadi/central-limit-order-book-example) | Complete | An order book and matching engine in TypeScript on Bun, small enough to read in one sitting |
| [go-oapi-sqlc-example](https://github.com/tabmadi/go-oapi-sqlc-example) | Complete | A Go REST API built contract first, with `oapi-codegen` for the server and `sqlc` for the queries |
| [oapi-codegen-custom-generator-example](https://github.com/tabmadi/oapi-codegen-custom-generator-example) | Complete | A custom Go code generator on the `oapi-codegen` loader and `text/template` |
| [go-tyk-example](https://github.com/tabmadi/go-tyk-example) | Complete | A Go service behind the Tyk gateway, which validates requests against the OpenAPI spec |
| [python-stripe-example](https://github.com/tabmadi/python-stripe-example) | Complete | A Stripe Checkout Session from Python, with typed settings from `pydantic-settings` |
| [zendriver-example](https://github.com/tabmadi/zendriver-example) | Complete | Passive scraping with Zendriver, which reads network traffic through the Chrome DevTools Protocol |
| [react-auth0-example](https://github.com/tabmadi/react-auth0-example) | Complete | Auth0 sign-in and an API access token in a React app |
| [react-powersync-example](https://github.com/tabmadi/react-powersync-example) | Complete | A local-first SQLite database in the browser with PowerSync and React |
| [pants-example](https://github.com/tabmadi/pants-example) | Complete | A Python monorepo built with Pants, with one PEX for each service |
| [hardhat-example](https://github.com/tabmadi/hardhat-example) | Incomplete | A Hardhat project with the toolchain set up, and no contract yet |
| [moon-example](https://github.com/tabmadi/moon-example) | Incomplete | A monorepo managed with moon. The repo has no code yet |
| [temporal-example](https://github.com/tabmadi/temporal-example) | Incomplete | A Temporal workflow. The repo has no code yet |

## Tools

A template runs this code through a pinned tag, never through these checkouts. A change here reaches a template only when the template moves its pin.

| Tool | Description |
| --- | --- |
| [tabkit](https://github.com/tabmadi/tabkit) | One versioned repository for the custom rules and generators, the shared Nix toolchain, opt-in flake modules, and opt-in NixOS modules |

## Scripts

| Script | Does |
| --- | --- |
| `scripts/commit-all.sh "message"` | Commits all changes, staged, unstaged, and untracked, in every submodule and then in this repo, with one message |
| `scripts/push-all.sh` | Pushes the current branch of every submodule and then of this repo |
| `scripts/check-drift.sh` | Compares the shared files of every template on the Nix baseline with github-project-template |

## Getting started

Clone with the submodules:

```bash
git clone --recurse-submodules git@github.com:tabmadi/blueprints.git
```

In a clone without them, fetch them:

```bash
git submodule update --init --recursive
```

## Updating submodules

Pull the latest commits of every blueprint:

```bash
git submodule update --remote --merge
```

Pull the latest commits of one blueprint:

```bash
git submodule update --remote templates/go-template
```

## Adding a blueprint

```bash
# A template
git submodule add git@github.com:tabmadi/<name>.git templates/<name>

# An example
git submodule add git@github.com:tabmadi/<name>.git examples/<name>

# A tool
git submodule add git@github.com:tabmadi/<name>.git tools/<name>
```

For a template, choose its size from [Conventions](#conventions), and give its README the sections that ADR-0001 sets for that size. Add a row to the matching table, and commit both `.gitmodules` and the new submodule pointer.

## License

See [LICENSE](LICENSE).
