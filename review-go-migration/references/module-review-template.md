# Module Review Template

为每个模块或子模块创建一个独立 markdown 文件，例如 `M2.md`、`M2-1.md`、`M2-1-2.md`。

## 推荐结构

```md
# M2 Payments Service

## Position

- ID: M2
- Parent: top-level
- Children: M2-1, M2-2
- Review status: partial

## Responsibility

- 

## Source Scope

- Directories:
- Key files:
- Key types/functions:

## Primary Entry Points In Source Project

- `path/to/file.ext:SymbolName` - why this is an entry point
- 

## Dependency Edges

- Upstream callers:
- Downstream dependencies:
- External systems:

## Current Go Migration Mapping

- Planned node(s):
- Implemented package(s):
- Validation evidence:
- Missing or mismatched areas:

## Coverage Assessment

- Covered:
- Partially covered:
- Missing:
- Incorrect or risky:

## Suggested Deep Dive

- Next child modules to create:
- Questions that still require source reading:

## Notes

- 
```

## 填写要求

- `Position` 中的 `Children` 没有时写 `none`。
- `Primary Entry Points In Source Project` 只保留真正能帮助后续快速回到代码上下文的入口，不要堆砌普通工具函数。
- `Current Go Migration Mapping` 同时写计划、代码、验证三部分；没有证据时明确写 `unknown` 或 `missing`。
- `Coverage Assessment` 要面向迁移审查，不是纯架构说明。
- `Suggested Deep Dive` 只在还需要继续拆分时填写具体子模块编号建议。

## 入口点示例

- `cmd/app.py:main` - CLI 入口，负责参数解析并调用任务执行器
- `src/http/routes.ts:registerBillingRoutes` - 把 billing handler 接到主 router
- `worker/consumer.js:startConsumer` - 后台消息消费启动点
- `pkg/service/order_service.py:OrderService.create_order` - 业务入口，多个 handler 都通过这里进入
