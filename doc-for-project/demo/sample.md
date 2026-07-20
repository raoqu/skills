# AI Agent 调用示例

## 示例一：默认两层结构，并分析代码入口

```text
请使用 project-architecture-documenter Skill 分析当前工作区中的项目代码。

项目路径：./my-project
输出目录：./docs/project-analysis

使用默认的两层文档结构，分析项目的功能结构、应用架构、主要模块、模块依赖、数据流以及代码入口。

要求：
1. hierarchy_depth 设置为 2；
2. include_code_entrypoints 设置为 true；
3. analysis_scope 设置为 full；
4. 生成 TOC.md；
5. TOC.md 必须链接到所有生成的 Markdown 文档；
6. 所有正文文档必须完整生成，不能只输出目录或分析计划；
7. 每篇文档列出对应的关键源代码路径。
```

对应参数：

```yaml
project_source: ./my-project
output_directory: ./docs/project-analysis
hierarchy_depth: 2
include_code_entrypoints: true
analysis_scope: full
```

---

## 示例二：三层结构，并详细分析代码入口

适用于希望深入到“模块—子模块—组件”的项目分析。

```text
请使用 project-architecture-documenter Skill 深入分析当前项目。

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
```

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

---

## 示例三：两层结构，只分析功能结构，不分析代码入口

适用于面向产品经理、项目管理者或希望快速理解项目功能的人。

```text
请使用 project-architecture-documenter Skill 分析项目：

./my-project

请生成两层结构的项目说明文档，重点说明：

- 项目提供了哪些主要功能；
- 各功能模块分别解决什么问题；
- 一级模块和二级子模块如何划分；
- 各功能模块之间如何协作；
- 项目的主要输入、处理过程和输出；
- 用户或调用方如何使用这些功能。

本次不需要分析 main 函数、启动流程、路由注册和具体代码调用链。

参数设置：

- hierarchy_depth: 2
- include_code_entrypoints: false
- analysis_scope: functional

输出目录：

./docs/functional-analysis

请生成完整的 TOC.md，并确保其中的每一个链接都对应实际生成且内容完整的 Markdown 文件。
```

对应参数：

```yaml
project_source: ./my-project
output_directory: ./docs/functional-analysis
hierarchy_depth: 2
include_code_entrypoints: false
analysis_scope: functional
```

---

## 示例四：三层结构，只分析应用架构，不追踪代码入口

适合重点研究项目分层、模块依赖和架构设计，而不关心具体启动代码。

```text
请使用 project-architecture-documenter Skill 对当前代码库进行应用架构分析。

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
```

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

---

## 示例五：一层结构，快速生成项目总览

适用于快速了解一个陌生开源项目，不希望生成太多文档。

```text
请使用 project-architecture-documenter Skill 快速分析以下开源项目：

https://github.com/example/example-project.git

只生成一层结构的项目文档，重点识别：

- 项目定位；
- 主要功能；
- 核心模块；
- 关键技术栈；
- 整体应用架构；
- 主要代码入口；
- 核心运行流程。

参数设置：

- hierarchy_depth: 1
- include_code_entrypoints: true
- analysis_scope: full

输出到：

./docs/project-overview

即使只生成一层，也需要创建 TOC.md，并链接到所有生成的项目级和一级模块文档。
```

对应参数：

```yaml
project_source: https://github.com/example/example-project.git
output_directory: ./docs/project-overview
hierarchy_depth: 1
include_code_entrypoints: true
analysis_scope: full
```

---

## 示例六：四层结构，进行深度代码架构分析

适用于大型框架、编译器、AI 推理系统或复杂 Monorepo。

```text
请使用 project-architecture-documenter Skill 对当前项目执行深度代码架构分析。

项目路径：./large-project
输出目录：./docs/deep-analysis

文档最大层级设置为四层：

- 项目；
- 一级子系统；
- 二级模块；
- 三级子模块；
- 四级核心组件。

请注意，四层是最大层级，不要求所有模块强制展开到四层。只有具备独立职责、公共接口或重要架构意义的组件才单独生成文档。

需要分析代码入口，包括：

- 所有生产环境程序入口；
- 多服务入口；
- CLI 子命令；
- Worker；
- 插件加载入口；
- 配置初始化；
- 依赖注入；
- 服务生命周期；
- 关键调用链。

同时分析：

- Monorepo 或多包结构；
- 核心运行时；
- 数据流；
- 控制流；
- 外部依赖；
- 构建与部署；
- 扩展机制；
- 模块边界和循环依赖风险。

参数设置：

- hierarchy_depth: 4
- include_code_entrypoints: true
- analysis_scope: full
- include_external_dependencies: true
- include_data_flow: true
- include_deployment_architecture: true
- include_source_references: true

忽略以下内容：

- node_modules；
- vendor；
- 构建产物；
- 缓存文件；
- 自动生成代码；
- 与核心架构无关的测试数据和静态资源。

必须生成全部文档，并在完成后检查 TOC 链接、文件编号、父子层级和源代码引用是否正确。
```

对应参数：

```yaml
project_source: ./large-project
output_directory: ./docs/deep-analysis
hierarchy_depth: 4
include_code_entrypoints: true
analysis_scope: full
include_external_dependencies: true
include_data_flow: true
include_deployment_architecture: true
include_source_references: true
```

---

# 简短调用示例

当 Agent 能正确识别 Skill 参数时，可以使用更简短的指令。

## 两层，包含代码入口

```text
使用 project-architecture-documenter 分析当前项目，生成两层结构的完整 Markdown 文档，包含代码入口、启动流程和核心调用链，输出到 ./docs/project-analysis。
```

## 两层，不包含代码入口

```text
使用 project-architecture-documenter 分析当前项目，生成两层功能结构和应用架构文档，不分析代码入口，输出到 ./docs/project-analysis。
```

## 三层，包含代码入口

```text
使用 project-architecture-documenter 对 ./my-project 进行三层架构分析，包含所有主要程序入口、初始化流程和调用链，生成完整 TOC.md 和全部正文文件。
```

## 三层，不包含代码入口

```text
使用 project-architecture-documenter 对 ./my-project 进行三层应用架构分析，只关注功能模块、架构分层、依赖关系和数据流，不追踪 main 函数和启动调用链。
```

---

# 推荐的通用提示词模板

```text
请使用 project-architecture-documenter Skill 分析以下项目。

项目来源：{{项目路径或 Git 仓库地址}}
输出目录：{{输出目录}}

分析参数：

- 文档结构层级：{{1、2、3 或 4}}
- 是否分析代码入口：{{是或否}}
- 分析范围：{{full、architecture 或 functional}}
- 是否分析外部依赖：{{是或否}}
- 是否分析数据流：{{是或否}}
- 是否分析部署架构：{{是或否}}
- 是否列出源代码依据：{{是或否}}

请先读取实际项目代码，再按照逻辑职责划分项目层级，不要机械地照搬物理目录。

最终要求：

1. 生成 TOC.md；
2. TOC.md 链接到所有生成的 Markdown 文档；
3. 文件名必须包含层级编号；
4. 完成目录中列出的每一篇文档；
5. 不允许出现空文档、TODO 或待补充内容；
6. 检查所有链接、编号和代码路径；
7. 最后报告生成的文档数量和输出位置。
```
