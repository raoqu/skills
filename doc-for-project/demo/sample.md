

---

## 示例六：四层结构，进行深度代码架构分析

适用于大型框架、编译器、AI 推理系统或复杂 Monorepo。

```text
请使用 doc-for-project Skill 对当前项目执行深度代码架构分析。

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
使用 doc-for-project 分析当前项目，生成两层结构的完整 Markdown 文档，包含代码入口、启动流程和核心调用链，输出到 ./docs/project-analysis。
```

## 两层，不包含代码入口

```text
使用 doc-for-project 分析当前项目，生成两层功能结构和应用架构文档，不分析代码入口，输出到 ./docs/project-analysis。
```

## 三层，包含代码入口

```text
使用 doc-for-project 对 ./my-project 进行三层架构分析，包含所有主要程序入口、初始化流程和调用链，生成完整 TOC.md 和全部正文文件。
```

## 三层，不包含代码入口

```text
使用 doc-for-project 对 ./my-project 进行三层应用架构分析，只关注功能模块、架构分层、依赖关系和数据流，不追踪 main 函数和启动调用链。
```

---

# 推荐的通用提示词模板

```text
请使用 doc-for-project Skill 分析以下项目。

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
