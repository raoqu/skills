---
name: 示例二：三层结构，并详细分析代码入口
description: 适用于希望深入到“模块—子模块—组件”的项目分析。
---------------------------------------------------

请使用 doc-for-project Skill 深入分析当前项目。

项目路径：./audio-translate
输出目录：./docs/architecture

请生成三层逻辑结构的项目文档，层级按照“一级核心模块—二级子模块—三级组件”组织，不要机械照搬物理目录。

同时详细分析代码入口，包括：

- 主程序入口；
- CLI 入口；
- Web 服务入口；
- Worker 或后台任务入口；
- 配置加载过程；
- 依赖初始化过程；
- 路由注册过程；
- 从入口进入核心业务模块的主要调用链。

参数要求：

- hierarchy_depth: 3
- include_code_entrypoints: true
- analysis_scope: full
- include_data_flow: true
- include_external_dependencies: true
- include_deployment_architecture: true

最终必须生成完整的 TOC.md，并完成 TOC 中列出的每一篇 Markdown 文档。

对应参数：

```yaml
project_source: ./audio-translate
output_directory: ./docs/architecture
hierarchy_depth: 3
include_code_entrypoints: true
analysis_scope: full
include_data_flow: true
include_external_dependencies: true
include_deployment_architecture: true
```