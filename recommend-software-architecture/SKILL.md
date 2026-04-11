---
name: recommend-software-architecture
description: Analyze a software repository at the system and framework level, then write actionable architecture recommendations under `doc/software-architecture-recommendations.md`. Use when Codex needs to assess the project's main architecture, layering, module boundaries, framework choices, runtime topology, dependency direction, integration style, or evolution path without focusing on feature-level implementation details.
---

# Recommend Software Architecture

## Overview

Inspect a repository from the architecture boundary inward, then produce a practical recommendation document under `doc/`.
Focus on structural design, framework fit, module relationships, and evolution strategy rather than business feature details.

## Workflow

1. Read high-signal artifacts first: `README*`, `docs/`, `doc/`, package manifests, build files, entrypoints, framework config, deployment config, and top-level source directories.
2. Identify the architecture shape before reading many implementation files: monolith, modular monolith, layered app, plugin system, library, monorepo, service-oriented system, CLI plus shared core, or hybrid.
3. Map the major design axes:
   - runtime boundary
   - module and package boundary
   - request or task flow
   - data ownership and persistence boundary
   - framework and infrastructure coupling
   - external integration boundary
4. Sample representative code only to confirm structural assumptions. Do not drift into feature walkthroughs unless a feature exposes an architectural constraint.
5. Create `doc/` if it does not exist.
6. Write or refresh `doc/software-architecture-recommendations.md`.

## Scope Control

- Stay at the system, subsystem, module, and framework level.
- Discuss feature code only when it proves a broader architectural issue.
- Prefer naming real directories, packages, and entrypoints such as `src/app`, `server/`, `packages/core`, or `cmd/api`.
- Avoid restating business logic unless it affects architecture boundaries.

## Recommendation Rules

- Tie every recommendation to repository evidence.
- Prefer incremental improvements over fashionable rewrites.
- Recommend a larger restructuring only when the current shape clearly blocks maintainability, delivery speed, reliability, or extensibility.
- Do not recommend patterns like DDD, hexagonal architecture, CQRS, event sourcing, or microservices unless the repository context makes the benefit concrete.
- Every recommendation must answer five questions:
  - what is the current structural issue
  - why it matters in this repository
  - what change is recommended
  - how to implement it incrementally
  - what tradeoff or cost comes with it

## Required Output

Read these references before drafting:

- [references/software-architecture-recommendations.md](references/software-architecture-recommendations.md)
- [references/output-contract.md](references/output-contract.md)

## Writing Rules

- Write in concise Chinese unless the user asks for another language.
- Distinguish `事实`, `判断`, and `建议` when ambiguity matters.
- Keep recommendations specific enough that an engineering lead could turn them into backlog items.
- Use priority labels such as `P0`, `P1`, `P2` only when they are justified by repository impact.
- Prefer "change X in module Y because Z" over abstract advice.
- If evidence is weak, explicitly say `待确认` instead of filling gaps with generic architecture language.

## Heuristics

- If the project is a library or SDK, emphasize API surface, extension points, packaging, compatibility boundaries, and test seams.
- If the project is a frontend app, emphasize state boundaries, routing composition, rendering strategy, data fetching boundary, and UI framework coupling.
- If the project is a backend app, emphasize service boundaries, I/O direction, transaction boundary, configuration strategy, and persistence coupling.
- If the project is a monorepo, emphasize package ownership, shared kernel risk, dependency direction, and release coupling.
- If the project is early-stage and small, prefer modularization and boundary cleanup over heavy platformization.
- If the project is large and already layered, focus on dependency inversion, boundary enforcement, observability seams, and migration sequencing.

## Deliverable Checklist

- Ensure `doc/software-architecture-recommendations.md` exists.
- Ensure the document describes the current architecture shape before proposing changes.
- Ensure each recommendation includes rationale, implementation path, and tradeoffs.
- Ensure the advice is repository-specific and not a generic best-practices essay.
- Ensure feature-level details are excluded unless they justify an architecture conclusion.
