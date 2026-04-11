---
name: analyze-open-source-project
description: Analyze an open source repository and produce structured project analysis documents and an architecture block diagram. Use when Codex needs to inspect source code, README files, docs directories, architecture notes, configuration files, or build scripts in order to explain the project's intent and business logic, technical architecture, source tree organization, and system component relationships, and then create or refresh `doc/project-intent-and-business.md`, `doc/technical-architecture.md`, `doc/source-code-structure.md`, and `doc/architecture-diagram.md`.
---

# Analyze Open Source Project

## Overview

Analyze a repository from the outside in, then write stable analysis documents and an architecture block diagram under `doc/`.
Prefer evidence from the repository itself over guesses, and mark inferred conclusions explicitly.

## Workflow

1. Read high-signal context first: `README*`, `docs/`, `doc/`, package/build files, top-level configs, entrypoints, and deployment files.
2. Map the execution surface: app entrypoints, packages/modules, services, data layer, external dependencies, and runtime boundaries.
3. Confirm the repository layout with filesystem inspection before describing it.
4. Create `doc/` if it does not exist.
5. Write or refresh these files:
   - `doc/project-intent-and-business.md`
   - `doc/technical-architecture.md`
   - `doc/source-code-structure.md`
   - `doc/architecture-diagram.md`
6. Generate a Mermaid architecture block diagram that matches the written architecture analysis.
7. Keep the outputs consistent with each other. If something is uncertain, say so instead of inventing details.

## Analysis Priorities

- Prefer repository artifacts over narrative claims.
- Use README, examples, tests, API specs, migration files, CI config, and deployment config as supporting evidence.
- Derive "business intent" from problem statements, user workflows, core entities, and success paths.
- Derive "architecture" from actual runtime structure: processes, layers, communication paths, state management, storage, and integration points.
- Derive "source structure" from real directories and ownership boundaries, not from naming alone.

## Output Rules

- Write in concise Chinese unless the user asks for another language.
- Use clear headings and short paragraphs.
- Use Mermaid in `doc/architecture-diagram.md` unless the user explicitly asks for another diagram format.
- Avoid repeating the same repository facts across all outputs. Reuse a fact only when it is necessary for that file.
- Distinguish facts from inference with labels such as `事实`, `推断`, and `待确认` when ambiguity matters.
- Include concrete paths like `src/server`, `packages/core`, or `cmd/api` when discussing structure.
- Do not claim architecture patterns, business goals, or module responsibilities unless the repo supports the claim.
- Keep diagram node names short and repository-specific.
- Keep edges meaningful: startup path, request path, async flow, persistence path, or integration path.

## Required Documents

Read the matching templates in `references/` before drafting:

- [references/project-intent-and-business.md](references/project-intent-and-business.md)
- [references/technical-architecture.md](references/technical-architecture.md)
- [references/source-code-structure.md](references/source-code-structure.md)
- [references/architecture-diagram.md](references/architecture-diagram.md)
- [references/output-contract.md](references/output-contract.md)

## Heuristics

- If the repository is a library, explain consumers, extension points, and packaging strategy instead of forcing a SaaS narrative.
- If the repository is a framework or tooling project, describe the developer workflow and integration model as the "business intent".
- If the repository is monorepo-shaped, explain package boundaries, shared infrastructure, and cross-package dependencies.
- If tests are strong, use them to validate intended behavior and edge cases.
- If documentation is weak, lean more on entrypoints, dependency graphs, configuration, and examples.

## Deliverable Checklist

- Ensure all four files exist under `doc/`.
- Ensure filenames match the contract exactly unless the user asks otherwise.
- Ensure each file contains repository-specific content rather than generic analysis language.
- Ensure uncertain points are explicitly marked.
- Ensure the written documents and diagram can be read independently and do not conflict.

## Resources

Use `references/output-contract.md` for the overall writing contract and file list.
Use the four per-document reference files as content templates and coverage checklists.
