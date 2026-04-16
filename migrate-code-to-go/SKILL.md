---
name: migrate-code-to-go
description: Use this skill to iteratively migrate non-Go codebases, especially Python, JavaScript/TypeScript, or Java projects, into Go. It supports staged multi-turn migrations with reusable plan/progress checkpoints, source-language best practices, dependency mapping, optional module analysis docs under go_migration/docs/analysis, and reset-progress archiving under go_migration/docs/history.
---

# Migrate Code to Go

将现有非 Go 项目逐步迁移为 Go，重点支持 Python、JavaScript/TypeScript、Java 或混合仓库。这个 skill 面向多轮迁移：先沉淀计划、分析和依赖决策，再按稳定节点实现、验证、记录，避免每一轮都重新理解整个原项目。

## 执行原则

1. 先固定迁移边界、模块映射和验证方式，再写 Go 代码。
2. 让迁移后的 Go 目录尽可能贴近原项目的逻辑分层与文件组织；只在 Go 生态约定明显更合适时才偏离，并记录原因。
3. 永远保持“可继续执行”的状态：本轮结束前更新计划、进度、依赖记录，以及必要的分析文档和步骤记录。
4. 优先迁移边界清晰、验证容易的节点，避免同时改动太多模块。
5. 对外部行为保持兼容优先：
   - 输入输出契约
   - 错误语义
   - 配置项
   - API/CLI/消息格式
   - 数据库 schema 与迁移路径
6. 对单独复杂模块或功能，优先评估成熟的第三方 Go 库是否能显著降低目标项目复杂度；对简单功能迁移，避免为了“生态对齐”引入额外依赖。
7. 当上下文不足时，只做当前计划节点所需的最小读取，不重新分析全仓。
8. 若发现之前计划错误，先更新计划文档和节点状态，再执行代码修改。
9. 每当某个计划节点或子节点在本轮被明确完成，立即在 `go_migration/steps/` 写一份独立迁移记录；未完成节点只更新 `progress.md`，不要伪造完成记录。

## 首次执行

第一次在某个仓库使用该 skill 时，先在原项目根目录下建立固定迁移工作区 `go_migration/`。不要把新的 Go 代码散落到原仓库其他目录。`go_migration/` 至少包含：

- `plan.md`
- `dependency-mapping.md`
- `validation.md`
- `progress.md`
- `steps/`
- Go 项目源码与模块文件；目录组织优先映射原项目的逻辑边界，例如保留 `api/`、`service/`、`repository/`、`worker/` 等语义，而不是默认套用统一模板
- 在分析成本高、会跨多轮复用时增加 `docs/analysis/`
- 在需要归档旧计划和旧进度时使用 `docs/history/`

如果原项目目录下已经存在 `go_migration/`，先复用并检查里面的计划、进度和 Go 工程状态，而不是重新选一个目录。

模板与写法见：

- [references/migration-plan-template.md](references/migration-plan-template.md)
- [references/dependency-migration-log-template.md](references/dependency-migration-log-template.md)
- [references/validation-checklist.md](references/validation-checklist.md)
- [references/execution-loop.md](references/execution-loop.md)
- [references/step-record-template.md](references/step-record-template.md)
- [references/module-analysis-template.md](references/module-analysis-template.md)

首次执行的最小流程：

1. 识别源码语言、入口点、运行方式、测试方式、关键模块、外部依赖；如果是 Python、JavaScript/TypeScript、Java 或混合仓库，读取对应专项参考。
2. 明确迁移输出边界：新的 Go 代码统一写入原项目根目录下的 `go_migration/`，不要混写到原项目其他源码目录。
3. 先写出“原目录 / 模块 -> Go 目录 / package”的结构映射，尽可能保留原项目的逻辑与文件组织。
4. 判断迁移策略：
   - 全量替换
   - 并存迁移
   - 按模块绞杀迁移
   - 先适配接口，再替换实现
5. 在 `go_migration/plan.md` 建立迁移计划，拆成有序节点，节点编号必须稳定，例如 `P1`、`P2.3`。
6. 如果项目较大、分析成本高或预计会多次回看原模块，在 `go_migration/docs/analysis/` 为关键模块建立分析文档。
7. 在 `go_migration/dependency-mapping.md` 建立依赖映射，先记录高风险三方库和复杂模块的 Go 落地策略。
8. 在 `go_migration/validation.md` 定义每类节点的验证方式。
9. 在 `go_migration/progress.md` 记录当前阶段、已完成节点、阻塞点和下一步。
10. 建立 `go_migration/steps/`，后续每轮节点完成后都在这里追加带时间戳的迁移记录。

## 源码语言专项参考

只读取与本轮节点相关的参考文件，避免无关上下文进入窗口：

- Python 项目：读取 [references/python-to-go-best-practices.md](references/python-to-go-best-practices.md)
- JavaScript/TypeScript 项目：读取 [references/javascript-typescript-to-go-best-practices.md](references/javascript-typescript-to-go-best-practices.md)
- Java 项目：读取 [references/java-to-go-best-practices.md](references/java-to-go-best-practices.md)
- 混合仓库：只加载当前节点实际涉及语言的参考，不要整仓同时加载全部语言说明

## 分析文档要求

当出现下列任一情况时，在 `go_migration/docs/analysis/` 为模块或主题建立分析文档：

- 原模块行为复杂，单轮内难以完整迁移
- 同一模块预计会跨多轮反复读取
- 涉及协议适配、状态机、复杂 SQL、缓存一致性、并发模型、错误语义等高成本理解区域
- 需要为依赖替换、自实现或结构映射保留长期理由

分析文档规则：

- 使用 Markdown，按模块或主题拆分，不要把大段分析堆进 `plan.md` 或 `progress.md`
- 文件名保持稳定、可搜索，例如 `user-service.md`、`P2-auth-flow.md`、`billing-edge-cases.md`
- 如现有分析文档不够完整，新增补充文档而不是把不相关主题继续塞进同一份文件
- 在 `plan.md`、`progress.md`、步骤记录中引用相关分析文档路径，避免重复分析原代码
- 结构模板见 [references/module-analysis-template.md](references/module-analysis-template.md)

## 重复执行循环

每次重复使用本 skill 时，遵循下面顺序：

1. 如果用户明确要求“重置进度”“重新开始计划”“归档当前计划后重开”等，先执行“重置进度规则”，再继续后续步骤。
2. 读取 `go_migration/progress.md` 和 `go_migration/plan.md`，确认下一个未完成节点。
3. 如当前节点涉及三方库或框架替换，读取 `go_migration/dependency-mapping.md` 的相关条目。
4. 如当前节点涉及高成本历史分析，先读取 `go_migration/docs/analysis/` 的相关文档；如果没有合适文档，先补一份最小分析文档。
5. 只收集当前节点所需的最小上下文：
   - 原语言实现
   - 相关测试
   - 配置/接口定义
   - `go_migration/` 中已存在的 Go 代码
6. 只迁移与当前节点相关的原始目录。原项目下可能有很多其他源码目录、资源目录或历史产物目录；除非计划节点明确要求，不要把它们纳入当前迁移范围。
7. 实施当前节点迁移，新写或改动的 Go 代码统一放在 `go_migration/` 下，并尽可能保持与原项目相近的逻辑分层和文件组织。
8. 对复杂模块评估成熟第三方 Go 库是否值得引入；对简单功能优先保持轻依赖实现，并把取舍写入依赖映射。
9. 执行对应验证。
10. 若本轮完成了计划节点或子节点，在 `go_migration/steps/` 新增一份以日期和时间标识的迁移记录；记录中必须包含：
   - 本次迁移对应计划中的哪一部分
   - 分析过程和变更范围
   - 相对于原项目差异性较大的变更
   - 遗留问题和风险
11. 更新 `go_migration/progress.md`、`go_migration/plan.md` 节点状态，以及必要的依赖映射记录和分析文档索引。
12. 明确写出下一次调用本 skill 应该继续的节点编号。

详细循环约束见 [references/execution-loop.md](references/execution-loop.md)。步骤记录模板见 [references/step-record-template.md](references/step-record-template.md)。

## 重置进度规则

仅在用户指令中明确包含“重置进度”语义时触发，不要自行推断。

执行方式：

1. 确保 `go_migration/docs/history/` 存在。
2. 将当前 `go_migration/plan.md` 和 `go_migration/progress.md` 归档到 `go_migration/docs/history/`，文件名前缀使用日期或日期时间，例如 `20260416-plan.md`、`20260416-153045-progress.md`。
3. 新建新的 `go_migration/plan.md` 和 `go_migration/progress.md`。
4. 新文件只保留非常简要的历史信息，例如：
   - 本次重置时间
   - 归档文件路径
   - 重置原因
   - 仍然有效的关键结论或待复核事项
5. 默认不要删除 `dependency-mapping.md`、`validation.md`、`steps/`、`docs/analysis/`；只有用户明确要求时才清理这些内容。

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

- 原项目强依赖某 Python/JavaScript/TypeScript/Java 库
- Go 中没有完全等价库
- 需要“自己封装一层”而不是直接替换
- 复杂模块可以显著受益于成熟第三方 Go 库
- 简单功能明确决定不引入额外依赖
- 存在行为差异、性能差异、协议差异、许可证风险
- 未来多个节点都会复用该映射

每条记录至少写清楚：

- 原依赖名与用途
- Go 替代方案
- 为什么选择第三方库、自实现或维持外部依赖
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
- 在 `go_migration/` 内尽可能保留原项目的逻辑层次和目录组织，不要为了“标准模板”无理由打散原有模块关系
- `go_migration/docs/analysis/` 用于按模块保存高复用分析文档；分析不充分时可追加新的补充文档
- `go_migration/docs/history/` 用于按日期归档旧 `plan.md` 和 `progress.md`
- `go_migration/steps/` 专门保存单轮迁移完成记录，不要把这类记录混进 `progress.md`
- 不要假设原项目只有一套源码目录；先识别本轮节点实际对应的源目录，再做映射
- 如果原项目存在多个候选子系统，先在 `go_migration/plan.md` 明确当前迁移目标，再动代码
- 除非用户明确要求原地替换，否则不要直接覆盖原语言实现；优先保持原实现与 `go_migration/` 并存

## Go 实现约束

迁移到 Go 时默认遵守：

- 优先标准库，避免无必要引入重量级框架
- 明确 package 边界，避免把所有逻辑塞进 `main`
- 先保持与原项目可追溯的模块划分，再做 Go 风格优化
- 对复杂、独立、风险高的能力模块，优先考虑成熟 Go 库以降低目标项目复杂度
- 对简单工具函数、薄逻辑适配层、容易直接翻译的功能，避免增加额外三方依赖
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
- 新增或更新了哪些分析文档
- 若触发重置进度，归档了哪些历史文件
- 若生成了步骤记录，记录文件路径
- 下轮应继续的节点编号

如果未完成当前节点，也要明确：

- 已完成到哪一步
- 剩余阻塞
- 为何需要下一轮继续
