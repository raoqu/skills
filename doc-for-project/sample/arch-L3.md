---
description: 三层结构，只分析应用架构，不追踪代码入口
scene: 适合重点研究项目分层、模块依赖和架构设计，而不关心具体启动代码。
---

请使用 doc-for-project Skill 对当前代码库进行应用架构分析。

项目路径：.
输出目录：./docs/application-architecture

请按照三层逻辑结构生成文档：

1. 一级：核心子系统或架构层；
2. 二级：子模块；
3. 三级：具有独立职责的组件。

本次重点分析：

- 系统边界；
- 应用分层；
- 模块职责；
- 依赖方向；
- 模块之间的接口；
- 数据流和控制流；
- 外部系统集成；
- 插件和扩展机制；
- 部署与运行形态；
- 潜在架构风险。

不要展开 main 函数、启动脚本、初始化调用链或逐函数调用关系。

参数设置：

- hierarchy_depth: 3
- include_code_entrypoints: false
- analysis_scope: architecture
- include_data_flow: true
- include_deployment_architecture: true
- include_source_references: true

所有规划出的文档必须实际写入，不能使用 TODO 或空文档占位。

对应参数：

```yaml
project_source: .
output_directory: ./docs/application-architecture
hierarchy_depth: 3
include_code_entrypoints: false
analysis_scope: architecture
include_data_flow: true
include_deployment_architecture: true
include_source_references: true
```