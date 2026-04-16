# Migration Plan Template

仅在首次建立迁移计划，或现有计划不足以支撑后续迭代时读取本文件。

## 目标

- 原项目：
- 源框架 / 语言：
- 迁移输出目录：`react_migration/`
- 目标技术栈：Node.js 22 / pnpm 10.20 / TypeScript / Vite 6.3.5 / React 19.1.0
- 迁移方式：全量替换 / 并存迁移 / 绞杀迁移 / 其他
- 成功标准：

## 系统概览

- 入口点：
- 核心路由 / 页面：
- 关键业务模块：
- 构建与运行方式：
- 外部系统：
- 高风险区域：
- 需要沉淀分析文档的模块：

## 结构映射

- 原项目核心目录 / 路由 / 模块：
- `react_migration/src/` 映射：
- 明确保留的原始信息架构：
- 允许偏离原结构的地方及原因：

## 目标工具链

- `packageManager`：
- `engines.node`：
- `vite`：
- `react` / `react-dom`：
- `typescript`：
- 需要保留的跨框架依赖：
- 必须删除或替换的旧框架依赖：

## 节点列表

使用稳定编号，按执行顺序排列。

| ID | 节点 | 范围 | 前置条件 | 验证方式 | 状态 |
| --- | --- | --- | --- | --- | --- |
| P1 | 建立 React/Vite 工程骨架 | `package.json`、`vite.config.ts`、`tsconfig*`、`src/` | 无 | `pnpm build` | todo |
| P2 | 建立共享模型与 service 层 | API client、types、基础 hooks | P1 | 类型检查 + 样例对比 | todo |
| P3 | 迁移布局与路由壳层 | layout、导航、路由入口 | P2 | 路由冒烟 | todo |
| P4 | 迁移核心页面簇 | 页面、组件、样式、交互 | P3 | 页面回归 + 构建 | todo |
| P5 | 清理旧框架依赖与切换入口 | 旧依赖、旧脚本、交付方式 | P4 | 依赖检查 + 交付验证 | todo |

状态建议：`todo`、`in-progress`、`blocked`、`done`。

## 节点拆分原则

- 一个节点应能在单轮上下文内完成并验证。
- 高风险节点拆成“契约、骨架、交互、验证、切换”几个子节点。
- 先迁移公共底座，再迁移页面和业务功能。
- 若需要三方库替换，计划中标明依赖映射条目编号。
- 若某节点依赖高成本分析，计划中标明对应的 `docs/analysis/` 文档。

## 当前执行指针

- 历史摘要：
- 当前节点：
- 下一节点：
- 当前阻塞：

## 目录边界说明

- 原项目实际迁移源目录：
- 本轮明确忽略的目录：
- React 实现统一写入：`react_migration/`
- 分析文档目录：`react_migration/docs/analysis/`
- 历史归档目录：`react_migration/docs/history/`
