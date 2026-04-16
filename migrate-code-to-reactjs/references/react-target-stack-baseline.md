# React Target Stack Baseline

当需要建立或校准目标 `package.json`、锁文件、脚手架配置和依赖清单时读取本文件。

本基线保留“迁移到 React/Vite/TypeScript/pnpm 所必需的部分”，不复制参考项目中的业务私有包、组件库、图表库或其他与当前节点无关的依赖。

## 固定目标栈

- Node.js：22
- 包管理器：pnpm 10.20 系列
- 语言：TypeScript
- 构建工具：Vite `^6.3.5`
- 前端框架：React `^19.1.0`
- 渲染入口：React DOM `^19.1.0`

## `package.json` 最小基线

```json
{
  "name": "react-migration-app",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "packageManager": "pnpm@10.20.0",
  "engines": {
    "node": "22.x"
  },
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^19.1.0",
    "react-dom": "^19.1.0"
  },
  "devDependencies": {
    "@types/node": "^22.15.17",
    "@types/react": "^19.1.2",
    "@types/react-dom": "^19.1.2",
    "@vitejs/plugin-react": "^4.4.1",
    "typescript": "~5.8.3",
    "vite": "^6.3.5"
  }
}
```

若项目需要 ESLint，可追加下面这组与参考项目一致且仍然相关的开发依赖：

```json
{
  "devDependencies": {
    "@eslint/js": "^9.25.0",
    "eslint": "^9.25.0",
    "eslint-plugin-react-hooks": "^5.2.0",
    "eslint-plugin-react-refresh": "^0.4.19",
    "globals": "^16.0.0",
    "typescript-eslint": "^8.30.1"
  }
}
```

## 允许保留或迁移的依赖

- 与框架无关、且当前业务确实依赖的 HTTP、日期、数据处理类库
- 已确认支持 React 的 UI、表格、图表或编辑器库
- 与业务强绑定的私有包，但前提是它们已经支持 React 或可被隔离封装
- 路由、状态管理、表单、测试库，但只在当前节点真的需要时再引入

## 默认不要直接复制的参考依赖

下列类别不要因为参考 `package.json` 里存在就默认带入目标项目：

- 组织私有包
- 仅特定业务页面需要的图表或表格库
- 尚未验证 React 兼容性的 UI 套件
- 与当前迁移节点无关的埋点、可视化、实验或辅助工具

## 必须删除或替换的旧栈残留

迁移到目标项目时，默认移除或替换下列内容：

- Vue 生态：`vue`、`vue-router`、`pinia`、`vuex`、`@vitejs/plugin-vue`、`nuxt`
- Angular 生态：`@angular/*`、Angular CLI 配置、模板编译相关产物
- Svelte 生态：`svelte`、`@sveltejs/*`、SvelteKit 配置
- 旧构建链：`webpack*`、`react-scripts`、`@vue/cli-*`、旧 Babel 打包桥接配置
- 旧包管理器：`package-lock.json`、`npm-shrinkwrap.json`、`yarn.lock`、`.yarn/`

若因并存迁移必须暂时保留旧栈，只允许保留在“源项目区域”；不要把这些残留复制进 `react_migration/` 的目标项目。

## 决策规则

- 先建立最小 React/Vite/TypeScript 骨架，再按节点补业务依赖。
- 先迁移框架无关依赖，再处理框架强绑定依赖。
- 对每个旧栈依赖写清楚“保留、替换、封装还是删除”。
- 不要把“参考项目里的版本”误当成“所有业务都必须携带的依赖清单”。
