# JavaScript and TypeScript to Go Best Practices

当当前迁移节点来自 JavaScript 或 TypeScript 项目时读取本文件。

## 迁移前先确认

- 当前节点是 Node.js 后端、CLI、worker、脚本工具，还是浏览器前端代码。
- 若仓库同时包含前后端，只迁移当前计划节点对应的后端或可迁移逻辑，不要把浏览器 UI 强行迁到 Go。
- 是否依赖事件驱动、流式处理、消息总线、定时任务、插件注册或动态模块加载。
- TypeScript 类型是否真实反映运行时行为，还是只在编译期存在。

## 结构映射

- 优先保留原项目的模块分层与文件组织，例如 `routes/`、`controllers/`、`services/`、`repositories/`、`jobs/`。
- 不要因为 Go 可以合并文件，就把原本边界清晰的目录拍平。
- 若原项目按 npm package、workspace 或子应用拆分，先在计划中写出这些边界如何映射到 Go module 或 package。

## 语言语义迁移

- 将对象字面量和动态属性访问收敛为显式 `struct`，明确 `null`、`undefined`、缺字段三者差异。
- 将 Promise 链、`async/await`、事件回调先还原成明确的执行顺序，再决定 goroutine、channel、worker pool 的落地方式。
- 将运行时 schema 校验库的行为保留到 Go 中，不要只迁移 TypeScript 静态类型。
- 对错误对象、HTTP 错误响应、日志字段，保持外部契约稳定。

## 依赖策略

- 对复杂协议客户端、Kafka/NATS、云服务 SDK、Excel/PDF/认证中间件等复杂模块，优先评估成熟 Go 库。
- 对简单的集合转换、lodash 风格小工具、日期格式化薄封装，不要为减少几行代码引入额外依赖。
- 若原项目使用框架提供的大量中间件魔法，先在 `docs/analysis/` 写清默认行为，再迁移。

## Node 运行时差异

- 明确处理进程信号、优雅退出、定时器生命周期、流式 backpressure。
- 对文件路径、环境变量、时区、编码、缓冲区边界做行为对齐。
- 若原实现依赖单线程事件循环顺序，迁移后要显式控制共享状态和并发访问。

## 验证重点

- 对 HTTP/API 比较请求校验、响应 JSON、默认值和中间件顺序。
- 对 CLI 比较参数解析、输出格式、退出码和文件副作用。
- 对 worker 或事件处理链，比较消息确认、重试、死信、顺序与幂等性。
- 对 TypeScript 项目，补运行时验证，不要把“类型通过”误当成“行为等价”。
