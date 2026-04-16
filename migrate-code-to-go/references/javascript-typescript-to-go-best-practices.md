# JavaScript and TypeScript to Go Best Practices

当当前迁移节点来自 JavaScript、TypeScript 或 Node.js 项目时读取本文件，包括 Express/NestJS/Fastify/Koa 服务、CLI、worker，以及 Next.js 等混合 SSR/BFF 框架中的服务端模块。

## 迁移前先确认

- 当前节点来自纯 Node.js 后端、Express/NestJS/Fastify/Koa/Hono 服务、CLI、worker、脚本工具，还是 Next.js/Remix/Nuxt 之类混合框架。
- 若仓库同时包含前后端，只迁移当前计划节点对应的后端或可迁移逻辑，不要把浏览器 UI 强行迁到 Go。
- 先标出当前节点属于 `server-only`、`shared`、`browser-only`、`build-time` 的哪一类；对混合框架，额外写清是 API route、route handler、server action、SSR 数据加载、中间件，还是 client component。
- 如果项目使用 Next.js，先区分 `app/`、`pages/`、`app/api/`、`pages/api/`、`middleware.ts`、`next.config.*`、edge runtime 代码、server actions、client components。
- 是否依赖 SSR、SSG、ISR、BFF、RSC、文件上传、WebSocket/SSE、队列任务、认证回调或 webhook。
- 是否依赖事件驱动、流式处理、消息总线、定时任务、插件注册或动态模块加载。
- 是否依赖 ESM/CJS 边界、动态 `import()`、monorepo workspace、本地 package 或生成时代码。
- TypeScript 类型是否真实反映运行时行为，还是只在编译期存在。

## Node / 混合运行时边界

- 默认纳入 Go 迁移范围：Node.js API、BFF、SSR 数据获取、鉴权/session、后台任务、消息处理、文件处理、纯共享业务逻辑。
- 默认不纳入 Go 迁移范围：浏览器组件、DOM 逻辑、样式系统、前端状态管理、构建工具链配置；除非计划明确要求以 Go 的 HTML/template 或静态资源流程替换。
- 对共享代码先确认它是否偷偷依赖浏览器 API、Next.js 专用 helper、Node 全局对象、构建期常量或 bundler 注入变量，再决定是否迁入 Go。
- 不要自动把 `next.config.js`、Webpack/Vite/Turbopack 配置、前端打包脚本视为 Go 迁移对象；这些内容通常属于保留、解耦或单独清理范围。

## 结构映射

- 优先保留原项目的模块分层与文件组织，例如 `routes/`、`controllers/`、`services/`、`repositories/`、`jobs/`。
- 不要因为 Go 可以合并文件，就把原本边界清晰的目录拍平。
- 若原项目按 npm package、workspace 或子应用拆分，先在计划中写出这些边界如何映射到 Go module 或 package。
- 对 Next.js 或其他混合框架，先把服务端目录、共享目录、浏览器目录拆开映射；不要把 `app/` 或 `pages/` 整体机械搬进同一个 Go package。

## 服务框架与路由映射

- Express/Koa/Hono/Fastify 的路由和中间件链，迁移时先还原成明确的 handler 顺序、参数绑定、错误处理和中间件顺序，再映射到 `net/http` 或轻量路由库。
- NestJS 的 module、controller、decorator、pipe、guard、interceptor、DI 容器，不要一比一复刻；先还原成显式构造函数、接口边界、验证层和中间件职责。
- 若原项目使用 tRPC、GraphQL BFF 或 RPC 风格 handler，先固定对外契约，再决定 Go 侧保留 GraphQL/RPC，还是收敛为 REST/gRPC。
- 对 WebSocket、SSE、队列消费者、cron worker 这类长期连接或后台执行链，优先单独成节点，不要和普通 HTTP handler 混做一个迁移点。

## Next.js 等混合框架迁移

- 先把 Next.js 代码按运行时职责拆开：`app/api/` 或 `pages/api/`、`middleware.ts`、server actions、SSR 数据加载、client components、构建配置、静态资源处理。
- 先在计划里决定目标形态：只替换 Go API/BFF、替换 Go SSR/模板输出、保留 React 前端仅替换服务端模块，还是分阶段绞杀。
- `app/**/*.tsx` 或 `pages/**/*.tsx` 只有在用户明确要求以 Go 服务端渲染、模板输出或静态生成替代页面层时才纳入 Go 迁移；否则把它们视为前端表面，保留原状或延后处理。
- Next.js 的 edge runtime、Web APIs、`fetch` 缓存语义、cookie/redirect helper、revalidate 机制不能默认等价到 Go；先在 `docs/analysis/` 记录语义，再选 Go 实现方案。
- ISR、SSG、`revalidatePath`、`revalidateTag`、增量缓存等机制，迁移时要明确落到哪一层：静态生成流程、HTTP 缓存/CDN、后台预热任务，还是显式缓存失效逻辑。

## 语言语义迁移

- 将对象字面量和动态属性访问收敛为显式 `struct`，明确 `null`、`undefined`、缺字段三者差异。
- 将 Promise 链、`async/await`、事件回调先还原成明确的执行顺序，再决定 goroutine、channel、worker pool 的落地方式。
- 将运行时 schema 校验库的行为保留到 Go 中，不要只迁移 TypeScript 静态类型。
- 对错误对象、HTTP 错误响应、日志字段，保持外部契约稳定。

## 依赖策略

- 对复杂协议客户端、Kafka/NATS、云服务 SDK、Excel/PDF/认证中间件等复杂模块，优先评估成熟 Go 库。
- 对简单的集合转换、lodash 风格小工具、日期格式化薄封装，不要为减少几行代码引入额外依赖。
- 若原项目使用框架提供的大量中间件魔法，先在 `docs/analysis/` 写清默认行为，再迁移。
- 对 `next-auth`、`passport`、`prisma`、`drizzle`、`bullmq`、`socket.io`、`trpc`、`zod` 等 Node/Next.js 生态依赖，不要假设存在一比一替代；先记录 Go 方案、自实现边界和不兼容点。

## Node 运行时差异

- 明确处理进程信号、优雅退出、定时器生命周期、流式 backpressure。
- 对文件路径、环境变量、时区、编码、缓冲区边界做行为对齐。
- 若原实现依赖单线程事件循环顺序，迁移后要显式控制共享状态和并发访问。
- 区分 Node `stream` / Web Streams / HTTP body streaming / multipart 上传的语义差异，不要把流式接口机械翻译成一次性读写。
- 区分 ESM、CJS、动态加载、monorepo 包解析与 Go module/package 的差异，避免把运行时装配逻辑误判成静态依赖。
- 对 `process.env`、`fetch`、`URL`、cookie helper、AbortController、`AsyncLocalStorage` 等 Node 或框架运行时能力，确认 Go 中的等价实现或明确行为差异。

## 验证重点

- 对 HTTP/API 比较请求校验、响应 JSON、默认值和中间件顺序。
- 对 Node/Next.js 服务端，比较 headers、cookies、redirect、cache-control、streaming、multipart 行为。
- 对 CLI 比较参数解析、输出格式、退出码和文件副作用。
- 对 worker 或事件处理链，比较消息确认、重试、死信、顺序与幂等性。
- 对 Next.js 或混合 SSR 框架，额外比较 middleware 链路、鉴权流程、SSR 数据获取、重定向、缓存失效和静态/动态路由行为。
- 对 TypeScript 项目，补运行时验证，不要把“类型通过”误当成“行为等价”。
