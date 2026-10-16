# Blueprints

The index of my GitHub templates and example projects. I start new work from one of these blueprints, not from zero. This repo tracks each one as a git submodule, so I can browse, update, and keep them in step from one place.

## Layout

| Path | Holds |
| --- | --- |
| `templates/` | Bases to start a new project from |
| `examples/` | Projects that each teach one stack or integration |
| `scripts/` | Scripts that act on every submodule at once |

## Conventions

Every blueprint follows one documentation convention and one tooling baseline. This repo exists to keep them the same in every repo.

- **Simple English, no emoji.** This applies to every README, doc, comment, and `AGENTS.md`.
- **Each kind of doc has one place.** The README helps a reader choose the repo and start. `docs/` holds procedures and lookups. An ADR holds a decision.
- **One toolchain shape.** `mise` pins every tool and runs every task. Every template and example has the tasks `setup`, `format`, `lint`, `test`, `check`, and `ci`, and its git hooks and CI workflow both run `mise run ci`. A platform has its own, larger task set on the same `mise` base.
- **The size depends on the kind of repo.** A rule that is right for a platform is too heavy for a small example.

| Size | Repos | README skeleton | ADRs |
| --- | --- | --- | --- |
| Platform | `sovereign-platform-template`, `nextjs-mvp-template` | Platform: selection guidance and getting started | A full set |
| Template | The other templates | Template | 0000 foundations, 0001 doc rules, 0100 toolchain |
| Example | Everything in `examples/` | Example: what it shows, run it, how it works, what is missing | None |

### Where the convention lives

| Source | Holds |
| --- | --- |
| [github-project-template](https://github.com/tabmadi/github-project-template) | The tooling baseline and ADR-0001, the doc rules. Every new repo inherits both |
| [readme-template](https://github.com/tabmadi/readme-template) | The README and `AGENTS.md` skeleton for each size, and the instructions to fill them |
| ADR-0001 in `sovereign-platform-template` | The long form of the doc rules, for a platform |

### Keeping the copies in sync

A repo made from a template copies files. It does not link to them. So every rule exists in many copies, and the copies drift. To control this:

1. Change a rule in its source repo first.
2. In the same pass, apply the change to every repo of that size.
3. Keep each copy small. This is why templates have three ADRs and examples have none.

Renovate keeps the tool pins of each repo current, so the versions do not drift by hand.

## Templates

| Template | Size | Description |
| --- | --- | --- |
| [github-project-template](https://github.com/tabmadi/github-project-template) | Template | The language-agnostic base: community files, issue and PR forms, the pinned toolchain, git hooks, the CI gate, and the doc rules |
| [readme-template](https://github.com/tabmadi/readme-template) | Template | The README and `AGENTS.md` skeletons for each repo size, with instructions for a coding agent or a chat assistant |
| [go-template](https://github.com/tabmadi/go-template) | Template | Go with the Standard Go Project Layout, every `golangci-lint` linter, and a static binary |
| [python-template](https://github.com/tabmadi/python-template) | Template | Python with the `src` layout, `uv`, `ruff` with every rule, `pyrefly`, and `pytest` |
| [ts-template](https://github.com/tabmadi/ts-template) | Template | TypeScript on Bun with Biome and a strict `tsconfig`, and no build step |
| [java-template](https://github.com/tabmadi/java-template) | Template | Java 25 LTS on Gradle with Spotless, Error Prone, NullAway, JUnit, and a JaCoCo floor |
| [nextjs-mvp-template](https://github.com/tabmadi/nextjs-mvp-template) | Platform | A Next.js modular monolith for one product, one deployable, and one team, with ADR-driven docs |
| [sovereign-platform-template](https://github.com/tabmadi/sovereign-platform-template) | Platform | A self-hosted platform monorepo, with every reusable decision recorded as an ADR and enforced in CI |

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

## Scripts

| Script | Does |
| --- | --- |
| `scripts/commit-all.sh "message"` | Commits all changes, staged, unstaged, and untracked, in every submodule and then in this repo, with one message |
| `scripts/push-all.sh` | Pushes the current branch of every submodule and then of this repo |

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
```

Then choose its size from [Conventions](#conventions), and follow the skeleton for that size. Add a row to the matching table, and commit both `.gitmodules` and the new submodule pointer.

## License

See [LICENSE](LICENSE).
