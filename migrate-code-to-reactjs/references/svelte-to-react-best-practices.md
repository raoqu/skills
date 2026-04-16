# Svelte to React Best Practices

当当前迁移节点来自 Svelte 或 SvelteKit 项目时读取本文件。

## 迁移前先确认

- 当前项目是纯 Svelte 还是 SvelteKit。
- 是否依赖 stores、actions、transitions、animations、context、slot、load/actions、表单增强或服务端能力。
- 是否存在大量 `$:` 反应式语句、双向绑定或编译期语法糖。
- 是否依赖文件路由、服务端数据预取或 SvelteKit 专属运行时。

## 结构映射

- 优先保留原项目的页面、布局、数据边界和业务模块，不要因为迁移而把文件路由语义打散。
- 将 `.svelte` 组件拆成 React `tsx` 组件与样式文件，并显式化原来由编译器承担的响应式行为。
- 将 SvelteKit 的页面、布局、数据加载规则拆成 React 路由、页面加载逻辑和 service 层。

## 常见语义映射

- `$:` 反应式语句：先判断是纯派生值还是副作用，再分别改成普通表达式、state 更新或 `useEffect`。
- `bind:`：改成受控 props 或 refs，不要保留隐式双向绑定思路。
- `slot`：改成 `children` 或 render props。
- `context`：改成 React Context。
- `actions`：改成 refs + effects 或自定义 hooks。
- `stores`：根据范围改成组件状态、context、外部 store 或服务层缓存。

## SvelteKit 特有注意点

- `load`、`actions`、表单增强和服务端能力不能直接等价到纯 Vite + React SPA；先记录是保留、下沉到后端、还是改造成客户端流程。
- 若原项目依赖 SSR、SEO、服务端鉴权或 edge runtime，先在分析文档中写清决策，避免默认假设“纯 SPA 足够”。
- 对文件系统路由、布局嵌套和错误边界，逐个映射，不要只迁页面组件。

## 动画与渲染

- Transitions、motion、动画编排通常不能直接照搬，需要单独评估 React 侧方案。
- 若动画只是装饰层，可先迁业务交互，再处理视觉细节；若动画影响信息表达或操作时序，必须纳入当前节点范围。

## 验证重点

- 编译期响应式改写后是否保持状态更新顺序
- 数据加载、路由切换和错误边界是否一致
- 双向绑定改写后是否引入受控 / 非受控错误
- 动画或 transition 改写后是否影响交互可用性
