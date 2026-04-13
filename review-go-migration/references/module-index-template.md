# Module Index Template

在 `go_migration/docs/migration-review/module-index.md` 中优先维护一张总表，作为后续所有 review 的入口。

## 推荐结构

```md
# Migration Review Module Index

## Review Scope

- Source project root:
- Review date:
- Related go_migration docs:
- Current review objective:

## Top-Level Modules

| ID | Module | Source Scope | Primary Entry Points | Go Mapping | Coverage | Deep Dive Next | Doc |
| --- | --- | --- | --- | --- | --- | --- | --- |
| M1 |  |  |  |  | covered/partial/missing/incorrect |  | [M1.md](M1.md) |

## Cross-Module Findings

- 

## Recommended Next Reviews

1. 
2. 
3. 
```

## 填写要求

- `Source Scope` 写目录、关键文件、运行边界，不只写抽象名称。
- `Primary Entry Points` 写路径加符号名，例如 `src/cli.py:main`, `server/routes.ts:registerUserRoutes`。
- `Go Mapping` 写 `go_migration/` 中已经对应的目录、包、计划节点，若没有则写 `missing`。
- `Coverage` 只能使用 `covered`、`partial`、`missing`、`incorrect` 四种之一。
- `Deep Dive Next` 写下一层最值得拆分的模块编号或建议方向。
- `Doc` 永远指向对应模块 markdown 文件。

## 使用时机

- 首次建立模块树时创建或重写总表。
- 深入某个模块后，回写对应行的 `Coverage`、`Deep Dive Next` 和 `Doc`。
- 发现跨模块遗漏时，统一记录在 `Cross-Module Findings`，不要只散落在单个模块文档中。
