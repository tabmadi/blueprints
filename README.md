# 🗂️ Blueprints

A central index of my personal GitHub templates and example projects. Instead of starting from zero, I bootstrap new
work from one of these blueprints. This repository tracks them all as git submodules so they can be browsed, updated,
and managed from one place.

## 📦 Layout

- `templates/` — reusable starter templates (language- or platform-specific scaffolding)
- `examples/` — complete example projects demonstrating a specific stack or integration

## 🧰 Templates

Base scaffolding for new projects. Each one ships with modern tooling (mise, lefthook, CI, etc.) and a consistent
project layout.

| Template                                                                                      | Description                                                                                                                                  |
|-----------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| [readme-template](https://github.com/tabmadi/readme-template)                                 | Standardized README template with AI-ready instructions for generating high-quality project READMEs.                                         |
| [github-project-template](https://github.com/tabmadi/github-project-template)                 | Language-agnostic GitHub repo template with community health files, issue/PR templates, and shared tooling (Lefthook, Mise, Cocogitto, Act). |
| [monolith-monorepo-template](https://github.com/tabmadi/monolith-monorepo-template)           | Monorepo template for small monolith projects (Node.js backend + React frontend).                                                            |
| [microservices-monorepo-template](https://github.com/tabmadi/microservices-monorepo-template) | Monorepo template for larger microservices projects (Go backend + Next.js frontend).                                                         |
| [go-template](https://github.com/tabmadi/go-template)                                         | Modern Go template following the Standard Go Project Layout, with golangci-lint, mise, lefthook, and act.                                    |
| [python-template](https://github.com/tabmadi/python-template)                                 | Python 3.12+ template using the `src` layout, `uv` for dependency management, and `ruff` for linting/formatting.                             |
| [ts-template](https://github.com/tabmadi/ts-template)                                         | TypeScript template using the Bun runtime, Biome for lint/format, and strict ESNext config.                                                  |

## 🧪 Examples

End-to-end example projects that show how to wire a real stack together.

| Example                                                                                                   | Description                                                                                                   |
|-----------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| [go-oapi-sqlc-example](https://github.com/tabmadi/go-oapi-sqlc-example)                                   | Production-ready Go REST API using an OpenAPI-first workflow with `oapi-codegen`, `sqlc`, and golang-migrate. |
| [oapi-codegen-custom-generator-example](https://github.com/tabmadi/oapi-codegen-custom-generator-example) | How to build custom code generators on top of `oapi-codegen` using Go `text/template`.                        |
| [go-tyk-example](https://github.com/tabmadi/go-tyk-example)                                               | Go service example integrating with the Tyk API gateway.                                                      |
| [temporal-example](https://github.com/tabmadi/temporal-example)                                           | Example project demonstrating Temporal workflows.                                                             |
| [python-stripe-example](https://github.com/tabmadi/python-stripe-example)                                 | Python Stripe payments integration using the `stripe` SDK and `pydantic-settings` for config.                 |
| [zendriver-example](https://github.com/tabmadi/zendriver-example)                                         | Passive web scraping example using Zendriver and the Chrome DevTools Protocol to intercept network traffic.   |
| [react-auth0-example](https://github.com/tabmadi/react-auth0-example)                                     | React application demonstrating Auth0 authentication with pnpm and moonrepo proto.                            |
| [react-powersync-example](https://github.com/tabmadi/react-powersync-example)                             | Minimal React + PowerSync integration showing local-first DB setup, a table, and basic queries.               |
| [hardhat-example](https://github.com/tabmadi/hardhat-example)                                             | Hardhat project example for Ethereum smart contract development.                                              |
| [moon-example](https://github.com/tabmadi/moon-example)                                                   | Example monorepo managed with Moon.                                                                           |
| [pants-example](https://github.com/tabmadi/pants-example)                                                 | Example monorepo managed with Pants build system.                                                             |

## 🚀 Getting Started

Clone with submodules:

```bash
git clone --recurse-submodules git@github.com:tabmadi/blueprints.git
```

Or, if you've already cloned the repo:

```bash
git submodule update --init --recursive
```

## 🔄 Updating Submodules

Pull the latest commits for every blueprint:

```bash
git submodule update --remote --merge
```

Update a single blueprint:

```bash
git submodule update --remote templates/go-template
```

## ➕ Adding a New Blueprint

```bash
# A template
git submodule add git@github.com:tabmadi/<name>.git templates/<name>

# An example
git submodule add git@github.com:tabmadi/<name>.git examples/<name>
```

Then add a row to the table above and commit both `.gitmodules` and the new submodule pointer.

## 📜 License

See [LICENSE](LICENSE).
