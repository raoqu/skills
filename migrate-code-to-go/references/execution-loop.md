# Execution Loop

当需要继续上一次迁移、决定本轮做什么、或控制上下文读取范围时读取本文件。

## 单轮循环

1. 如果用户明确要求重置当前迁移进度，先执行“重置进度流程”，再继续后续步骤。
2. 查看 `go_migration/progress.md`，确认上轮停在哪个节点。
3. 查看 `go_migration/plan.md`，把当前节点标记为 `in-progress`。
4. 如果节点依赖第三方库决策，查看 `go_migration/dependency-mapping.md` 对应条目。
5. 如果当前节点已有高价值分析文档，先查看 `go_migration/docs/analysis/` 下对应文件；如果没有且原模块分析成本高，先补一份最小分析文档。
6. 只读取当前节点需要的源码、测试、配置、接口定义，以及 `go_migration/` 下对应的已有 Go 代码。
7. 明确本轮迁移目标对应的原始目录；忽略仓库中与当前节点无关的其他源码或文件目录。
8. 在 `go_migration/` 下实现最小可验证增量，并尽可能保持与原项目相近的逻辑分层和文件组织。
9. 对复杂模块评估成熟 Go 库是否值得引入；对简单功能优先避免新增依赖，并把取舍写入 `dependency-mapping.md`。
10. 运行当前节点规定的验证。
11. 如果本轮明确完成了计划节点或子节点，在 `go_migration/steps/` 新建一份步骤记录，文件名使用可排序时间戳，推荐 `YYYYMMDD-HHMMSS-<node-id>.md`。
12. 在该步骤记录中至少写清：
   - 对应计划节点
   - 分析过程和变更范围
   - 相对原项目差异较大的变更
   - 遗留问题和风险
13. 更新 `go_migration/progress.md`：
   - 本轮完成内容
   - 验证结果
   - 剩余问题
   - 下轮节点
   - 最新步骤记录文件
   - 最新分析文档
14. 若决策变化，回写 `go_migration/plan.md` 或 `go_migration/dependency-mapping.md`。

## `go_migration/progress.md` 建议结构

- 历史摘要：
- 当前阶段：
- 当前节点：
- 已完成节点：
- 本轮改动摘要：
- 本轮验证：
- 最新步骤记录：
- 最新分析文档：
- 当前阻塞：
- 下一节点：

## `go_migration/steps/` 记录建议结构

- 记录时间：
- 节点编号：
- 节点标题：
- 本轮目标：
- 分析过程：
- 变更范围：
- 关键差异：
- 验证结果：
- 遗留问题：
- 风险：
- 下一步建议：

## 重置进度流程

只在用户明确表达“重置进度”“重新开始计划”“归档当前计划后重开”等语义时触发。

1. 确保 `go_migration/docs/history/` 存在。
2. 将当前 `go_migration/plan.md`、`go_migration/progress.md` 归档到 `go_migration/docs/history/`，文件名前缀使用日期或日期时间。
3. 新建新的 `go_migration/plan.md` 和 `go_migration/progress.md`。
4. 新文件只保留非常简要的历史信息：
   - 重置时间
   - 归档文件路径
   - 重置原因
   - 仍然有效的关键结论或待复核事项
5. 默认不要删除 `dependency-mapping.md`、`validation.md`、`steps/`、`docs/analysis/`。

## 上下文控制规则

- 不重新加载整个代码库，只读取当前节点相邻上下文。
- 如果一个文件超过当前节点所需范围，只读相关片段。
- 如果仓库存在多个源码根目录，只读取当前计划节点明确涉及的目录。
- 如果某模块会在后续多轮持续引用，优先将分析沉淀到 `go_migration/docs/analysis/`，不要反复读原实现。
- 如果发现新的架构事实会影响多个后续节点，先回写计划文档，再继续代码实现。
- 如果当前节点超出单轮能力，优先拆分计划，而不是硬做到底。
- 如果当前节点尚未完成，只更新 `progress.md`，不要提前写完成记录。
