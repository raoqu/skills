# Validation Checklist

当需要为迁移节点设计或补充验证时读取本文件。

## 通用检查

- 编译是否通过
- `go_migration/` 是否保持为独立、可理解的 Go 项目结构
- `go_migration/` 内的目录组织是否仍能追溯回原项目的逻辑分层和模块边界
- 关键入口是否可运行
- 配置加载是否与原实现一致
- 错误码、错误消息、异常分支是否兼容
- JSON / YAML / protobuf / SQL 等序列化结果是否兼容
- 时间、时区、精度、空值语义是否一致

## 结构与依赖策略

- 复杂模块若引入第三方 Go 库，是否验证了行为契约、许可证、维护度和关键边界
- 简单功能是否避免了不必要的新依赖
- 如果目录结构有意偏离原项目，是否在计划或步骤记录中说明原因
- `docs/analysis/` 中的关键信息是否已经落实到实现或验证中

## HTTP / API

- 路由、方法、状态码一致
- 请求参数校验一致
- 响应结构、字段命名、默认值一致
- 中间件行为一致：认证、日志、追踪、限流、超时
- headers、cookies、redirect、cache-control、streaming、multipart 行为一致

## Node / SSR / 混合框架

- 是否先区分了 `server-only`、`shared`、`browser-only`、`build-time`，避免把浏览器代码误算作 Go 迁移完成
- 对 Next.js 或类似框架，`app/api/`、`pages/api/`、server actions、middleware、SSR 数据获取、client components 的边界是否已在计划中写清
- 若本轮替换的是 SSR 或 BFF，HTML/JSON、鉴权、cookie、重定向、缓存失效和中间件顺序是否对齐
- 若保留原前端，前后端拆分后的接口、静态资源、部署路径和环境变量注入是否已验证
- 若涉及 ISR、SSG 或增量缓存，是否验证了缓存刷新、预热和静态资源落地路径

## CLI / 批处理

- 参数解析一致
- 输出格式一致
- exit code 一致
- 文件读写副作用一致

## 数据层

- 查询结果和排序一致
- 事务边界一致
- schema 迁移路径明确
- 幂等性和重试策略明确

## 并发 / 性能

- goroutine 生命周期可控
- context cancel 可传播
- 无明显数据竞争
- 热路径性能不低于可接受基线

## 最低验证策略

若原项目测试薄弱，至少补下面之一：

- 1 个核心 golden case
- 1 组最小 API 对比
- 1 个关键 service 的单测
- 1 条端到端冒烟验证路径
