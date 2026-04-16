# Migration Plan Template

仅在首次建立迁移计划，或现有计划不足以支撑后续迭代时读取本文件。

## 目标

- 原项目：
- 源语言：
- 迁移输出目录：`go_migration/`
- 目标 Go 版本：
- 迁移方式：全量替换 / 并存迁移 / 绞杀迁移 / 其他
- 成功标准：

## 系统概览

- 入口点：
- 关键模块：
- 运行环境：
- 运行时角色边界：`server-only` / `shared` / `browser-only` / `build-time`
- 混合框架边界：API / SSR / UI / middleware / worker / build
- 外部系统：
- 高风险区域：
- 需要沉淀分析文档的模块：

## 结构映射

- 原项目核心目录 / 模块：
- Go 目录 / package 映射：
- 明确保留的原始结构语义：
- 明确保留或延后的浏览器端 / 构建期目录：
- 允许偏离原结构的地方及原因：

## 节点列表

使用稳定编号，按执行顺序排列。

| ID | 节点 | 范围 | 前置条件 | 验证方式 | 状态 |
| --- | --- | --- | --- | --- | --- |
| P1 | 例：建立 Go 工程骨架 | module, build, config | 无 | 能编译 | todo |
| P2 | 例：迁移共享模型 | DTO, schema, serialization | P1 | 单测 + 样例对比 | todo |
| P3 | 例：迁移核心 service | service layer | P2 | 单测 + 集成测试 | todo |

状态建议：`todo`、`in-progress`、`blocked`、`done`。

## 节点拆分原则

- 一个节点应能在单轮上下文内完成并验证。
- 高风险节点拆成“契约、实现、验证、切换”几个子节点。
- 先迁移公共底座，再迁移上层业务。
- 若需要三方库替换，计划中标明依赖映射条目编号。
- 若某节点依赖高成本分析，计划中标明对应的 `docs/analysis/` 文档。

## 当前执行指针

- 历史摘要：
- 当前节点：
- 下一节点：
- 当前阻塞：

## 目录边界说明

- 原项目实际迁移源目录：
- 当前纳入 Go 迁移的 Node/SSR 服务端目录：
- 本轮明确忽略的目录：
- Go 实现统一写入：`go_migration/`
- 分析文档目录：`go_migration/docs/analysis/`
- 历史归档目录：`go_migration/docs/history/`
