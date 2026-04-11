# Output Contract

Create these files under the target repository's `doc/` directory:

1. `doc/project-intent-and-business.md`
2. `doc/technical-architecture.md`
3. `doc/source-code-structure.md`
4. `doc/architecture-diagram.md`

## Global rules

- Write in Chinese by default.
- Base statements on repository evidence.
- Mark unsupported conclusions as `推断` or `待确认`.
- Prefer concrete paths, components, and files over abstract labels.
- Use Mermaid for architecture diagrams by default.
- Refresh existing files when they already exist; do not duplicate with alternate filenames.

## Minimum repository reading set

- `README*`
- `docs/` or `doc/`
- package/build manifests
- entrypoint files
- main configuration and deployment files
- top-level source directories
- representative tests or examples

## Expected quality bar

- Each document answers a different question.
- The diagram should summarize the runtime structure and major dependencies rather than duplicate every directory.
- Each document is specific to the current repository.
- The wording stays compact and avoids filler.
- The four outputs do not contradict each other.
