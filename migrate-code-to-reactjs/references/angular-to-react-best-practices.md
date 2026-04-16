# Angular to React Best Practices

当当前迁移节点来自 Angular 项目时读取本文件。

## 迁移前先确认

- 当前项目使用的是 NgModule 体系还是 standalone components。
- 是否依赖 Angular Router、Guards、Resolvers、Interceptors、Reactive Forms、Signals、RxJS、依赖注入容器。
- 是否存在大量模板语法、结构型指令、自定义指令、管道或装饰器元数据。
- 是否有 SSR、国际化、权限体系或企业级设计系统绑定。

## 结构映射

- 优先保留原项目的 feature module、页面组和领域边界，但不要在 React 中机械重建 NgModule。
- 将 Angular 组件、模板、样式拆到 `react_migration/src/` 下的功能目录中，并明确区分页面容器、展示组件和 service 层。
- 将 Angular service 迁成显式的 API 模块、领域服务、hooks 或 context 适配层。

## 常见语义映射

- 模板条件、循环和绑定：改成 JSX 条件表达式、数组 `map` 和受控 props。
- `@Input` / `@Output`：改成 props 和回调。
- DI：改成模块导入、context 或轻量封装，不要在 React 中重建重量级注入容器，除非项目明确需要。
- 管道：优先收敛成普通函数或格式化工具模块。
- 指令：按职责改成 hooks、包装组件或 refs 逻辑。
- Guards / Resolvers：改成路由包装层、页面加载逻辑或 service 预取流程。

## RxJS 与状态

- 先判断 RxJS 是“必要的异步编排能力”还是“Angular 惯性写法”。
- 对简单页面状态或请求流，不要为了保持形式一致而继续引入重度 observable 架构。
- 对复杂实时流、取消、多播或组合流，再评估是否保留 RxJS，或转换成更轻的 React 侧实现。

## 表单与生命周期

- Reactive Forms 先拆清表单模型、校验规则和提交流程，再决定使用局部 state、领域 hooks 或 React 表单库。
- 注意 Angular 生命周期与 React 渲染模型不同，不要把初始化、副作用和清理逻辑逐个生命周期对位翻译。
- 对 Zone.js、变更检测、模板驱动刷新等 Angular 运行时行为，必须先写进分析文档，再决定 React 落地。

## 验证重点

- 路由守卫、权限控制和数据预取顺序是否一致
- 表单校验、脏值检测、错误提示和提交副作用是否一致
- RxJS 或异步流改写后是否出现取消失效、重复订阅或内存泄漏
- 指令和管道改写后是否保持渲染和交互契约
