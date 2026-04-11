---
name: migrate-code-to-go
description: Use this skill to iteratively migrate non-Go codebases, especially Python or TypeScript projects, into Go with a reusable plan, dependency migration notes, validation steps, repeatable checkpoint-based execution across multiple turns, and per-step migration records under go_migration/steps.
---

# Migrate Code to Go

将任意非 Go 代码逐步迁移为 Go 实现，重点支持 Python、TypeScript 或混合项目。这个 skill 不是一次性重写指南，而是一个可重复执行的迁移循环：先建立迁移计划和依赖记忆，再按节点顺序迁移、验证、记录结果，直到项目稳定完成。

## 何时使用

在这些场景触发：

- 用户要求把现有 Python、TypeScript、JavaScript、Ruby、Java、Rust、C# 等项目改写或迁移到 Go
- 项目太大，单次上下文无法完成，需要分阶段推进
- 原始项目架构复杂，需要先梳理模块边界、运行时行为、外部依赖和验证策略
- 迁移中涉及第三方库替换，需要长期保存“某依赖在 Go 中如何落地”的决策记录
- 用户要求“继续上次迁移”“完成下一个节点”“更新迁移计划”“补齐验证”

如果只是新写一个小型 Go 脚本、没有现有代码基线，也没有分阶段迁移需求，不要使用这个 skill。

## 执行原则

1. 先理解原项目，再决定迁移顺序，不要直接大面积改写。
2. 永远保持“可继续执行”的状态：本轮结束前更新计划、依赖记录、验证记录，以及必要的步骤记录。
3. 优先迁移边界清晰、验证容易的节点，避免同时改动太多模块。
4. 对外部行为保持兼容优先：
   - 输入输出契约
   - 错误语义
   - 配置项
   - API/CLI/消息格式
   - 数据库 schema 与迁移路径
5. 当上下文不足时，只做当前计划节点所需的最小读取，不重新分析全仓。
6. 若发现之前计划错误，先更新计划文档和节点状态，再执行代码修改。
7. 每当某个计划节点或子节点在本轮被明确完成，立即在 `go_migration/steps/` 写一份独立迁移记录；未完成节点只更新 `progress.md`，不要伪造完成记录。

## 首次执行

第一次在某个仓库使用该 skill 时，先在原项目根目录下建立固定迁移工作区 `go_migration/`。不要把新的 Go 代码散落到原仓库其他目录，也不要沿用仓库里现有的 docs 或 misc 目录作为迁移落点。`go_migration/` 至少包含：

- Go 项目源码与模块文件，例如 `go.mod`、`cmd/`、`internal/`、`pkg/`
- `plan.md`
- `dependency-mapping.md`
- `validation.md`
- `progress.md`
- `steps/`

如果原项目目录下已经存在 `go_migration/`，先复用并检查里面的计划、进度和 Go 工程状态，而不是重新选一个目录。

模板与写法见：

- [references/migration-plan-template.md](references/migration-plan-template.md)
- [references/dependency-migration-log-template.md](references/dependency-migration-log-template.md)
- [references/validation-checklist.md](references/validation-checklist.md)
- [references/execution-loop.md](references/execution-loop.md)
- [references/step-record-template.md](references/step-record-template.md)

首次执行的最小流程：

1. 识别源码语言、入口点、运行方式、测试方式、关键模块、外部依赖。
2. 明确迁移输出边界：新的 Go 代码统一写入原项目根目录下的 `go_migration/`，不要混写到原项目其他源码目录。
3. 判断迁移策略：
   - 全量替换
   - 并存迁移
   - 按模块绞杀迁移
   - 先适配接口，再替换实现
4. 在 `go_migration/plan.md` 建立迁移计划，拆成有序节点，节点编号必须稳定，例如 `P1`、`P2.3`。
5. 在 `go_migration/dependency-mapping.md` 建立依赖映射，先记录高风险三方库。
6. 在 `go_migration/validation.md` 定义每类节点的验证方式。
7. 在 `go_migration/progress.md` 记录当前阶段、已完成节点、阻塞点和下一步。
8. 建立 `go_migration/steps/`，后续每轮节点完成后都在这里追加带时间戳的迁移记录。

## 重复执行循环

每次重复使用本 skill 时，遵循下面顺序：

1. 读取 `go_migration/progress.md` 和 `go_migration/plan.md`，确认下一个未完成节点。
2. 如当前节点涉及三方库或框架替换，读取 `go_migration/dependency-mapping.md` 的相关条目。
3. 只收集当前节点所需的最小上下文：
   - 原语言实现
   - 相关测试
   - 配置/接口定义
   - `go_migration/` 中已存在的 Go 代码
4. 只迁移与当前节点相关的原始目录。原项目下可能有很多其他源码目录、资源目录或历史产物目录；除非计划节点明确要求，不要把它们纳入当前迁移范围。
5. 实施当前节点迁移，新写或改动的 Go 代码统一放在 `go_migration/` 下，不顺手扩散到其他未计划节点。
6. 执行对应验证。
7. 若本轮完成了计划节点或子节点，在 `go_migration/steps/` 新增一份以日期和时间标识的迁移记录；记录中必须包含：
   - 本次迁移对应计划中的哪一部分
   - 分析过程和变更范围
   - 相对于原项目差异性较大的变更
   - 遗留问题和风险
8. 更新 `go_migration/progress.md`、`go_migration/plan.md` 节点状态，以及必要的依赖映射记录。
9. 明确写出下一次调用本 skill 应该继续的节点编号。

详细循环约束见 [references/execution-loop.md](references/execution-loop.md)。步骤记录模板见 [references/step-record-template.md](references/step-record-template.md)。

## 步骤记录要求

每一份 `go_migration/steps/` 记录都使用稳定、可排序的文件名，推荐格式：`YYYYMMDD-HHMMSS-<node-id>.md`，例如 `20260411-153045-P2.1.md`。

记录至少包含：

- 记录时间
- 对应计划节点编号与标题
- 本轮迁移目标
- 分析过程
- 变更范围
- 与原项目相比差异较大的设计或行为变化
- 验证结果
- 遗留问题
- 风险判断
- 下一步建议

如果一次完成多个紧密相关的子节点，可以写一份合并记录，但必须在标题和正文中明确覆盖的节点编号。

## 节点设计规则

计划节点要足够小，能在一次上下文内完成并验证。优先使用这些粒度：

- 一个独立 CLI 命令
- 一个 HTTP handler 或 service
- 一个数据访问模块
- 一个后台任务/worker
- 一组共享模型与序列化逻辑
- 一个第三方集成适配层

避免把整个系统写成一个节点。若某节点无法在一轮内完成，拆成：

- 契约梳理
- Go 骨架
- 核心实现
- 测试补齐
- 切换与清理

## 依赖迁移记忆

第三方依赖不能只在当轮临时判断。凡是出现下面任一情况，都要在 `go_migration/dependency-mapping.md` 增加或更新条目：

- 原项目强依赖某 Python/TypeScript 库
- Go 中没有完全等价库
- 需要“自己封装一层”而不是直接替换
- 存在行为差异、性能差异、协议差异、许可证风险
- 未来多个节点都会复用该映射

每条记录至少写清楚：

- 原依赖名与用途
- Go 替代方案
- 不兼容点
- 当前决定
- 示例代码或落地文件位置
- 后续待验证事项

模板见 [references/dependency-migration-log-template.md](references/dependency-migration-log-template.md)。

## 验证要求

迁移必须伴随验证，不允许只完成“代码翻译”。根据项目类型，从 `go_migration/validation.md` 中至少选择一层：

- 单元测试
- 集成测试
- golden file / snapshot 对比
- API 响应对比
- CLI 输出对比
- 数据读写回归验证
- 性能或并发基线检查
- 手工验收脚本

如果原项目没有测试，先补最小回归护栏，再迁移高风险节点。详细检查项见 [references/validation-checklist.md](references/validation-checklist.md)。

## Go 目录约束

- 新的 Go 项目目录名固定为原项目根目录下的 `go_migration/`
- 所有新增 Go 代码、Go 模块文件、迁移中间产物文档都放在 `go_migration/` 下
- `go_migration/steps/` 专门保存单轮迁移完成记录，不要把这类记录混进 `progress.md`
- 不要假设原项目只有一套源码目录；先识别本轮节点实际对应的源目录，再做映射
- 如果原项目存在多个候选子系统，先在 `go_migration/plan.md` 明确当前迁移目标，再动代码
- 除非用户明确要求原地替换，否则不要直接覆盖原语言实现；优先保持原实现与 `go_migration/` 并存

## Go 实现约束

迁移到 Go 时默认遵守：

- 优先标准库，避免无必要引入重量级框架
- 明确 package 边界，避免把所有逻辑塞进 `main`
- 错误处理显式化，不复制原语言中过度动态的写法
- 上下文、超时、取消语义要明确
- 配置、日志、序列化、并发模型要与原行为对齐或明确记录差异
- 对自动生成代码、schema、OpenAPI、proto 等产物区分“源文件”和“生成文件”

## 交付格式

每轮结束时至少输出：

- 本轮完成的计划节点编号
- 做了哪些代码或文档修改
- 执行了哪些验证，结果如何
- 更新了哪些依赖映射
- 若生成了步骤记录，记录文件路径
- 下轮应继续的节点编号

如果未完成当前节点，也要明确：

- 已完成到哪一步
- 剩余阻塞
- 为何需要下一轮继续
