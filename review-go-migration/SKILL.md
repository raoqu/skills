---
name: review-go-migration
description: Use this skill to review an ongoing or planned Go migration by reconstructing a stable module tree from the source project, mapping original code entry points, checking migration coverage against real source scope, and drilling recursively into a chosen module. Use when Codex needs to find omitted migration scope, verify whether go_migration plans/steps cover the real system, create M1/M2 and M1-1/M1-2 style module inventories, or record migration review findings under go_migration/docs/migration-review.
---

# Review Go Migration

为已有或进行中的 Go 迁移补上一层“迁移覆盖 review”。目标不是直接继续写 Go 代码，而是从原项目重新梳理稳定的模块树、原始代码入口、迁移覆盖边界和遗漏风险，并把结论沉淀到 `go_migration/docs/migration-review/`，方便后续检查和修正不完整或错误的迁移方案。

该 skill 通常与 `migrate-code-to-go` 配合使用：

- `migrate-code-to-go` 负责计划、执行、验证、记录迁移步骤
- `review-go-migration` 负责回看原项目真实结构，发现计划遗漏、模块拆分错误、入口遗漏、覆盖不足或错误映射

## 执行原则

1. 先从原项目梳理真实模块边界，再评估 `go_migration/` 当前迁移覆盖，不要只根据已有计划文档做 review。
2. 保持编号稳定，优先复用既有模块编号，不因为排序优化而重编号。
3. 每个模块都记录“原项目中的主要代码入口”，让后续分析尽量基于已有 review 文档，而不是反复回到全仓重读。
4. 顶层只拆到能支撑迁移审查的粒度；只有在用户点名某个模块编号时，才继续向下递归拆子模块。
5. 深入分析时只读取父模块文档里指向的最小必要源码、测试、配置和 `go_migration/` 对应实现，不重新全仓扫描。
6. review 默认独立记录在 `go_migration/docs/migration-review/`；除非用户明确要求，不直接改写 `go_migration/plan.md` 或 `progress.md`。
7. 每次 review 都要明确指出覆盖状态：
   - 已覆盖
   - 部分覆盖
   - 未覆盖
   - 覆盖错误/存在偏差

## 初始化与目录约束

第一次在某个仓库使用该 skill 时，先确认原项目根目录下存在 `go_migration/`。若不存在，说明迁移工作区尚未建立，应先使用 `migrate-code-to-go` 初始化迁移目录，再进行 review。

在已有 `go_migration/` 的前提下，创建或复用：

- `go_migration/docs/migration-review/module-index.md`
- `go_migration/docs/migration-review/M1.md`
- `go_migration/docs/migration-review/M2.md`
- `go_migration/docs/migration-review/M2-1.md`

命名规则固定为扁平 markdown 文件，不额外嵌套目录：

- 顶层模块：`M1.md`、`M2.md`、`M3.md`
- 子模块：`M2-1.md`、`M2-2.md`
- 更深层：`M2-1-1.md`

这样可以稳定排序，也方便用户直接按编号点名继续分析。

模板见：

- [references/module-index-template.md](references/module-index-template.md)
- [references/module-review-template.md](references/module-review-template.md)
- [references/review-loop.md](references/review-loop.md)
- [references/gap-checklist.md](references/gap-checklist.md)

## 模块编号规则

编号必须稳定、可追加、可递归：

- 顶层模块按首次建立模块树时的顺序编号：`M1`、`M2`、`M3`
- `M2` 的子模块编号为：`M2-1`、`M2-2`
- `M2-1` 的子模块编号为：`M2-1-1`、`M2-1-2`

保持这些约束：

- 发现新模块时追加新编号，不重排旧编号
- 调整模块标题、范围、描述可以更新，但尽量不改编号
- 如发现原先一个模块过大，需要拆分，则在该模块下追加子模块，而不是推翻整棵树
- 如发现两个模块实际高度耦合，可以在文档中记录“建议合并审查”，但保留原编号并说明原因

模块树的目标是服务迁移审查，不必追求理论上最完美的架构分层；只要能稳定定位迁移范围和入口点即可。

## 首次构建顶层模块树

当 `go_migration/docs/migration-review/` 不存在或 `module-index.md` 尚未建立时，按以下顺序执行：

1. 读取原项目的运行入口、源码目录、测试目录、配置、路由注册、CLI 命令、worker/scheduler、数据访问层定义。
2. 读取 `go_migration/plan.md`、`progress.md`、`steps/` 中与当前迁移范围最相关的内容，理解已有迁移计划如何划分范围。
3. 从“运行时职责 + 源码边界 + 外部接口边界”三个角度提炼顶层模块，不要只按目录机械拆分。
4. 为每个顶层模块分配稳定编号 `M1`、`M2`、`M3`。
5. 在 `module-index.md` 记录：
   - 模块编号与名称
   - 原项目范围
   - 主要代码入口
   - 当前迁移覆盖状态
   - 对应的 Go 落点或缺失情况
   - 是否建议继续深挖
6. 为每个顶层模块创建对应的 `M<n>.md` 文档。

顶层模块的常见粒度：

- 一个 CLI/命令执行链
- 一个 HTTP/API 服务面
- 一个后台任务系统
- 一个数据/存储访问层
- 一个集成适配层
- 一组共享领域模型与转换逻辑

不要把整个系统只写成一个模块；也不要一开始就把每个小文件都拆成模块。

## 模块文档必须记录的内容

每个模块或子模块文档都要至少写清楚：

- 模块编号与标题
- 父模块编号与子模块列表
- 该模块在原项目中的职责
- 该模块覆盖的源目录、关键文件、关键类型或函数
- 该模块在原项目中的主要代码入口
- 该模块依赖哪些上游调用者、会调用哪些下游能力
- 当前 `go_migration/` 中的对应实现、计划节点或缺失状态
- 怀疑遗漏的行为、接口、配置、测试、错误语义或边界情况
- 建议后续继续深入的子模块方向

“主要代码入口”不是只写一个 `main`。要记录真正能帮助后续快速重建上下文的入口，例如：

- CLI command 注册函数
- HTTP router/handler 绑定点
- 消息消费者/worker 启动点
- 定时任务调度注册点
- service/facade 的公开方法
- repository/store 的主读写入口
- model/serializer/schema 的核心转换入口

入口记录要尽量带上源码文件路径和符号名。

## 指定模块继续深入分析

当用户指定某个模块编号，例如 `M2`、`M2-1` 或 `M3-2-1`，执行递归深入分析：

1. 先读取该模块现有 markdown 文档。
2. 只读取该模块文档中提到的原项目源码、相关测试、相关配置和 `go_migration/` 对应实现。
3. 判断该模块是否还需要继续拆成子模块：
   - 如果当前模块仍包含多个明显不同的职责或入口簇，则拆分
   - 如果当前模块已经是可直接审查迁移覆盖的粒度，则不要继续细分
4. 为新识别出的子模块分配稳定编号，例如 `M2-1`、`M2-2`
5. 为每个子模块生成独立 markdown 文档
6. 回写父模块文档中的子模块列表、边界说明和继续分析建议
7. 更新 `module-index.md` 中对应模块的 review 深度、覆盖状态和下一步建议

如果用户点名的是已有子模块，如 `M2-1`，则继续向下生成 `M2-1-1`、`M2-1-2`。递归规则无限制，但只有在当前粒度仍不足以判断迁移覆盖时才继续下钻。

## 迁移覆盖审查方法

review 的核心不是“描述架构”，而是找出迁移方案与原系统真实范围之间的差异。对每个模块都要检查至少这些问题：

- 原项目中这个模块是否已有稳定的 Go 映射位置
- `go_migration/plan.md` 是否包含该模块或其关键职责
- `go_migration/steps/` 是否真的迁移过，而不是只在计划中提到
- 原模块的主要入口是否全部被 Go 方案覆盖
- 原模块的配置、错误语义、数据模型、后台任务、接口契约是否被遗漏
- 相关测试或验证手段是否覆盖了该模块的主要行为

详细检查项见 [references/gap-checklist.md](references/gap-checklist.md)。

若发现问题，优先把结论写进对应模块文档，并在 `module-index.md` 的状态栏中标记：

- `covered`
- `partial`
- `missing`
- `incorrect`

必要时补充“建议修正计划节点”或“建议补做验证”的说明，但默认不直接重写迁移计划文档。

## 与原项目代码分析的协同方式

为了减少重复读代码，始终遵守这条顺序：

1. 先读 `module-index.md`
2. 再读目标模块的 markdown 文档
3. 只在文档证据不够时回到原项目源码
4. 新读到的重要入口、边界、依赖和遗漏，立刻写回模块文档

这样后续再次分析时，可以优先消费 review 文档，而不是每次重新跑一遍全局代码理解。

如果原项目结构和运行结构不一致：

- 优先按运行时职责建模
- 在文档中保留源码目录映射
- 明确写出“逻辑模块”和“物理目录”之间的差异

## 输出要求

每次使用该 skill 结束时，至少交付：

- 本次新建或更新了哪些 review 文档
- 本次分析的是哪些模块编号
- 为每个模块确认了哪些原项目主要代码入口
- 识别出哪些迁移覆盖缺口、错误映射或待验证风险
- 若需要继续下钻，下一次应该继续分析哪个模块编号

如果这次只是建立顶层模块树，也要明确说明：

- 当前有哪些顶层模块
- 哪些模块最值得优先继续深挖
- 哪些模块已经显示出迁移遗漏风险
