---
description: 两层结构，只分析功能结构，不分析代码入口
scene: 适用于面向产品经理、项目管理者或希望快速理解项目功能的人。
---

请使用 doc-for-project Skill 分析项目：

项目路径：.

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

对应参数：

```yaml
project_source: ./my-project
output_directory: ./docs/functional-analysis
hierarchy_depth: 2
include_code_entrypoints: false
analysis_scope: functional
```