# Output Contract

Create or refresh this file under the target repository's `doc/` directory:

1. `doc/software-architecture-recommendations.md`

## Global rules

- Write in Chinese by default.
- Base conclusions on repository evidence first and inference second.
- Keep the analysis at architecture, framework, module, boundary, and evolution level.
- Do not expand into detailed feature implementation review unless it proves a structural problem.
- Refresh the existing file when it already exists; do not create alternate filenames.

## Minimum repository reading set

- `README*`
- `docs/` or `doc/`
- package and build manifests
- framework configuration files
- deployment or runtime configuration
- top-level source directories
- entrypoint files
- representative tests or examples only when they clarify architectural intent

## Expected quality bar

- The document should help a technical lead decide what to change next.
- Every recommendation should be actionable within the current repository shape.
- Recommendations should include migration direction, not only end-state ideals.
- The wording should stay concrete and avoid filler like "optimize architecture" or "improve decoupling" without saying how.
