# Vue to React Best Practices

当当前迁移节点来自 Vue 项目时读取本文件。

## 迁移前先确认

- 当前项目是 Vue 2 还是 Vue 3。
- 主要使用 Options API、Composition API，还是二者混用。
- 是否依赖 `vue-router`、`pinia`、`vuex`、`provide/inject`、全局 mixin、指令或插件机制。
- 是否大量使用单文件组件、插槽、Teleport、Transition、KeepAlive。
- 样式是 scoped CSS、CSS Modules、Tailwind、Less/Sass，还是全局样式拼接。

## 结构映射

- 优先保留原项目的页面分组、布局层级和业务目录，不要因为迁到 React 就把边界打散。
- 将 Vue 单文件组件拆成 React `tsx` 组件和对应样式文件。
- 将 `views/`、`pages/`、`modules/`、`composables/`、`api/` 等目录映射到 `react_migration/src/` 下的对应语义目录。

## 常见语义映射

- `v-if` / `v-else` / `v-show`：改成 JSX 条件渲染；注意 `v-show` 是保留 DOM，不能机械替换成卸载。
- `v-for`：改成数组 `map`；补稳定 `key`。
- `computed`：优先改成普通派生表达式；只有代价高时才用额外 memo 化。
- `watch` / `watchEffect`：先识别真实副作用，再决定使用 `useEffect`、事件处理或服务层抽离；不要逐条照抄 watcher。
- `ref` / `reactive`：根据语义改成 `useState`、`useRef`、`useReducer` 或外部 store。
- `emit`：改成 props 回调或事件适配层。
- `slots` / `named slots`：改成 `children`、显式 props 或 render props。
- `provide/inject`：改成 React Context 或模块级依赖。
- `directives`：改成 refs、hooks、受控组件或专用包装组件。

## 路由与生命周期

- 将 `vue-router` 路由树映射成 React 路由配置，保持动态参数、嵌套路由和默认落点一致。
- 将导航守卫拆成更显式的权限判断、路由包装层或加载流程，不要把隐式守卫逻辑散落到多个组件。
- 将 `onMounted`、`onBeforeUnmount`、`activated`、`deactivated` 的差异记录清楚，避免在 React 中错误复用缓存或副作用时机。

## 状态与依赖策略

- 对 `pinia` / `vuex`，先判断是否需要保留集中式状态；若只影响局部页面，优先收敛成组件状态或领域 hooks。
- 对复杂表单、图表、虚拟列表或编辑器，优先评估成熟 React 生态库；不要假设 Vue 生态库能直接复用。
- 对样式作用域和类名策略，优先保持原有可理解边界，不要一轮内同时重写整个样式系统。

## 验证重点

- 条件渲染和列表渲染是否保持行为一致
- 插槽替换后的组合能力是否仍满足页面需求
- 守卫、重定向、权限和异步加载顺序是否一致
- `watch` 迁移后是否引入重复请求、状态回环或副作用时序错误
