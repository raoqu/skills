
---
name: 示例一：默认两层结构，并分析代码入口
---------------------------------------------------

```text
请使用 doc-for-project Skill 分析当前工作区中的项目代码。

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
