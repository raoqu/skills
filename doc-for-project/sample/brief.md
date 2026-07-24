---
description: 一层结构，快速生成项目总览
scene: 适用于快速了解一个陌生开源项目，不希望生成太多文档。
---

请使用 doc-for-project Skill 快速分析以下开源项目：

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

对应参数：

```yaml
project_source: https://github.com/example/example-project.git
output_directory: ./docs/project-overview
hierarchy_depth: 1
include_code_entrypoints: true
analysis_scope: full
```