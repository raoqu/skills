# Legacy Frontend to React Best Practices

当当前迁移节点来自旧 JavaScript、jQuery、多脚本页面、webpack 老项目或缺少明确框架归属的前端时读取本文件。

## 迁移前先确认

- 入口是单页应用、多页面应用，还是服务端模板 + 前端增强。
- 是否依赖全局变量、script 加载顺序、DOM 直改、事件总线、jQuery 插件或 UMD/CommonJS 包。
- 是否存在多个独立页面入口、多个 webpack bundle、Gulp/Grunt/Babel 老构建链。
- 模板、样式、接口层和业务状态是否已经分层，还是全部耦合在页面脚本里。

## 结构映射

- 先把页面入口、共享服务、公共组件和工具函数拆清，再映射到 `react_migration/src/`。
- 将“页面脚本 + DOM 操作 + Ajax”拆成“页面组件 + hooks / state + service 模块”。
- 将全局脚本顺序依赖改成显式 ESM imports；不要把旧的 script 顺序问题带进 Vite 项目。

## 常见迁移策略

- 先建立最小 React 壳层，再按页面或 DOM 区块绞杀式替换旧脚本。
- 对模板字符串或字符串拼 HTML 的代码，先还原为组件边界，再写 JSX。
- 对 jQuery 插件，先判断是否必须保留；如果只是简单 UI 功能，优先替换成 React 组件或轻量实现。
- 对大量隐式共享状态，先写分析文档，明确谁读取、谁写入、谁驱动刷新。

## TypeScript 策略

- 即使源项目是纯 JavaScript，也将目标项目保持为 TypeScript。
- 对暂时无法精确建模的外部数据，先使用窄范围 `unknown` 或显式接口草稿，不要因为赶进度把整个项目退回到 JavaScript。
- 对老式全局对象或第三方插件，优先写局部声明或适配层，不要把 `any` 扩散到全局。

## 构建与依赖清理

- 将 webpack、Gulp、Grunt、老 Babel 配置视为“待替换对象”，不要默认继续沿用。
- 将 npm 或 Yarn 的锁文件和脚本习惯迁到 pnpm；如需并存，只允许在源项目区域保留。
- 将浏览器 polyfill、全局 shim 和别名配置逐条复核；Vite 默认行为与旧构建链不同。

## 验证重点

- 全局状态改写后是否仍能驱动页面刷新
- DOM 直改替换后是否仍保留关键交互和边界条件
- 构建入口、环境变量和静态资源路径是否与原交付方式兼容
- 多页面或混合模板场景下，React 挂载点和原页面生命周期是否衔接正确
