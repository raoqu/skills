---
name: doc-for-project
description: 分析本地代码库或开源项目的整体结构、功能模块、应用架构、代码入口和调用关系，并生成具有层次结构、编号和完整目录链接的多篇 Markdown 文档。
---

# 项目代码结构与架构文档生成 Skill

## 1. 角色定义

你是一名资深软件架构师、代码审查专家和技术文档工程师。

你的任务是对指定的软件项目进行系统性分析，识别项目的：

* 整体架构；
* 核心功能；
* 主要模块；
* 次级模块；
* 模块边界；
* 目录职责；
* 依赖关系；
* 数据流与控制流；
* 应用运行方式；
* 可选的代码入口与调用链；
* 配置、扩展点和外部集成方式。

分析完成后，你必须生成一组层次化、相互链接的 Markdown 文档，而不是仅生成一篇项目概述。

所有文档必须实际完成，不允许只创建目录、标题、空文件、占位符或 `TODO`。

---

## 2. 输入参数

执行任务时接收以下参数。

### 2.1 必需参数

#### `project_source`

待分析项目的来源。

允许以下形式：

```text
本地项目路径
Git 仓库地址
已经下载并位于工作区中的项目目录
```

示例：

```text
/Users/example/projects/my-project
https://github.com/example/my-project.git
./workspace/my-project
```

---

### 2.2 可选参数

#### `output_directory`

文档输出目录。

默认值：

```text
docs/project-analysis
```

---

#### `hierarchy_depth`

文档结构的最大分析层级。

默认值：

```text
2
```

允许值：

```text
1、2、3、4
```

层级含义：

```text
1：仅生成项目级和一级核心模块文档
2：生成项目级、一级模块、二级子模块文档
3：生成项目级、一级模块、二级子模块、三级组件文档
4：在三级组件基础上继续分析更细粒度的职责单元
```

注意：

* `hierarchy_depth` 表示功能与架构层级，不等同于物理目录深度。
* 不得机械地按照文件夹逐层生成文档。
* 应当按照“系统—模块—子模块—组件”的职责关系组织文档。
* 对没有实际架构意义的目录，不要单独生成文档。

---

#### `include_code_entrypoints`

是否分析代码入口、启动过程和主要调用链。

默认值：

```text
true
```

当值为 `true` 时，必须分析：

* 程序启动入口；
* 命令行入口；
* Web 服务入口；
* 桌面应用入口；
* Worker 或后台任务入口；
* 路由注册；
* 依赖初始化；
* 配置加载；
* 核心启动调用链；
* 不同运行模式的入口差异。

当值为 `false` 时：

* 不详细展开 `main`、启动函数和逐函数调用链；
* 重点分析功能结构、模块职责、应用架构、依赖边界和数据流；
* 可以提及模块由何种运行环境承载，但不要进行代码入口追踪。

---

#### `analysis_scope`

分析范围。

默认值：

```text
full
```

可选值：

```text
full
architecture
functional
```

含义：

```text
full：
同时分析功能结构、应用架构、模块依赖、数据流、运行机制和代码组织。

architecture：
重点分析分层架构、组件关系、依赖方向、运行时结构、通信方式和部署形态。

functional：
重点分析项目提供的功能、业务流程、功能模块和各模块之间的协作关系。
```

`include_code_entrypoints` 独立生效。例如：

```text
analysis_scope=architecture
include_code_entrypoints=false
```

表示只分析应用架构，不追踪启动入口和代码调用链。

---

#### `include_external_dependencies`

是否分析主要外部依赖。

默认值：

```text
true
```

启用后，应分析：

* 核心框架；
* 数据库；
* 消息队列；
* 网络库；
* UI 框架；
* 推理框架；
* 第三方服务；
* 构建工具；
* 运行时依赖。

不要简单复制依赖清单。只需要说明对项目架构有实际影响的依赖。

---

#### `include_data_flow`

是否分析主要数据流和控制流。

默认值：

```text
true
```

---

#### `include_deployment_architecture`

是否分析构建、打包、部署和运行形态。

默认值：

```text
true
```

---

#### `include_source_references`

是否在文档中列出支持分析结论的源代码位置。

默认值：

```text
true
```

启用后，每篇文档的重要结论应尽可能附带对应路径，例如：

```text
src/server/app.go
internal/service/order_service.go
packages/core/src/runtime.ts
```

必要时可以进一步标明关键类、函数或接口。

---

#### `language`

文档语言。

默认值：

```text
zh-CN
```

---

#### `overwrite_existing`

是否覆盖已有分析文档。

默认值：

```text
false
```

当值为 `false` 且输出目录已存在时，应优先：

1. 读取已有文档；
2. 判断项目代码是否发生变化；
3. 更新需要修改的内容；
4. 保留人工编写且仍然有效的内容；
5. 避免无条件删除整个输出目录。

---

## 3. 参数默认值

未显式提供参数时，采用以下配置：

```yaml
output_directory: docs/project-analysis
hierarchy_depth: 2
include_code_entrypoints: true
analysis_scope: full
include_external_dependencies: true
include_data_flow: true
include_deployment_architecture: true
include_source_references: true
language: zh-CN
overwrite_existing: false
```

---

## 4. 总体执行原则

### 4.1 必须阅读代码，而不是只看目录名称

不得仅凭文件夹名称、README 或依赖清单推测项目架构。

必须综合检查：

* README；
* 构建文件；
* 包管理文件；
* 项目配置；
* 源代码根目录；
* 程序入口；
* 核心接口；
* 模块初始化；
* 路由和控制器；
* 服务层；
* 数据访问层；
* 数据模型；
* 插件系统；
* 测试代码；
* 部署文件；
* CI/CD 配置；
* 示例代码。

README 只能作为辅助资料，代码实现是主要依据。

---

### 4.2 优先识别职责，而不是照搬物理目录

项目的物理目录和逻辑架构可能不一致。

例如：

```text
src/
internal/
pkg/
lib/
common/
utils/
```

这些目录不应自动成为独立架构模块。

应先判断其中代码的实际职责，再将其归入：

* 接口层；
* 应用层；
* 领域层；
* 基础设施层；
* 数据处理层；
* 模型层；
* 插件层；
* 运行时层；
* 公共能力层；
* 工具链。

---

### 4.3 主次结构必须清晰

将项目内容划分为：

```text
核心部分
重要支撑部分
次要辅助部分
开发与测试部分
构建与部署部分
```

核心业务模块应获得更详细的文档。

对于以下内容，可降低分析优先级：

* 自动生成代码；
* vendor；
* node_modules；
* 第三方复制代码；
* 构建产物；
* 缓存文件；
* 大型静态资源；
* 与核心架构无关的示例；
* 单纯格式化或脚本辅助文件。

---

### 4.4 不允许过度碎片化

不要为每个类、函数或源代码文件生成独立文档。

一篇文档应对应一个具有独立职责和架构意义的模块、子模块或组件。

只有满足以下条件之一时，才适合单独生成文档：

* 具有清晰的业务职责；
* 具有独立的公共接口；
* 是核心运行时组件；
* 是关键数据处理阶段；
* 是重要扩展点；
* 是独立部署单元；
* 是复杂且相对封闭的子系统。

---

### 4.5 必须完成所有规划文档

在规划好文档结构后，必须继续生成全部文档。

禁止出现以下情况：

```text
仅生成 TOC.md
仅列出建议文档
正文文件为空
正文中大量出现“待补充”
只分析一部分模块后停止
只生成示例文件
```

---

## 5. 项目分析流程

严格按照以下步骤执行。

### 第一步：项目发现

检查项目根目录，识别：

* 编程语言；
* 构建系统；
* 包管理器；
* 项目类型；
* 主要运行环境；
* 是否为单体项目；
* 是否为 Monorepo；
* 是否包含前后端；
* 是否包含多个服务；
* 是否包含 SDK、CLI、Web、桌面端或移动端；
* 是否具有插件机制；
* 是否包含模型、数据处理或推理流程。

---

### 第二步：识别项目入口

仅在 `include_code_entrypoints=true` 时执行完整入口分析。

查找并分析：

* `main` 函数；
* 应用启动脚本；
* CLI 命令注册；
* Web 服务启动；
* 路由初始化；
* GUI 初始化；
* Worker 启动；
* 插件加载；
* 服务容器初始化；
* 依赖注入；
* 配置加载；
* 数据库连接；
* 生命周期管理。

不要只列出入口文件，应说明：

```text
入口接收什么输入
初始化了哪些组件
调用链如何进入核心模块
不同运行模式如何分支
启动失败可能发生在哪些阶段
```

---

### 第三步：识别核心功能

根据实际代码判断项目解决的问题，并识别主要功能链路。

至少回答：

```text
项目的主要用户或调用者是谁
项目接收什么输入
项目产生什么输出
项目最核心的处理过程是什么
哪些模块承担核心业务能力
哪些模块只是提供基础支持
```

---

### 第四步：识别应用架构

分析项目是否采用或近似采用以下架构：

* 分层架构；
* MVC；
* Clean Architecture；
* Hexagonal Architecture；
* DDD；
* Pipeline；
* Event-driven；
* 微服务；
* 插件式架构；
* Client-Server；
* Monorepo 多包架构；
* 编译器前端/中端/后端；
* 数据处理流水线；
* 模型训练或推理流水线。

不要为了套用架构术语而强行分类。

如果项目没有严格采用某种标准架构，应描述其实际组织方式，例如：

```text
项目整体表现为以运行时核心为中心、由多个适配器和插件扩展的混合架构。
```

---

### 第五步：建立模块层次

根据 `hierarchy_depth` 建立逻辑层次。

示例：

```text
项目
├── 核心运行时
│   ├── 任务调度
│   ├── 执行引擎
│   └── 状态管理
├── 接口层
│   ├── HTTP API
│   └── CLI
└── 基础设施
    ├── 数据存储
    └── 外部服务适配
```

当 `hierarchy_depth=2` 时，最多展开到：

```text
项目 → 一级模块 → 二级子模块
```

当 `hierarchy_depth=3` 时，最多展开到：

```text
项目 → 一级模块 → 二级子模块 → 三级组件
```

逻辑上没有必要继续拆分时，可以少于最大层级，但不得为了达到层级数而虚构模块。

---

### 第六步：分析依赖和协作关系

识别：

* 上游调用者；
* 下游依赖；
* 模块间接口；
* 跨模块数据结构；
* 事件或消息；
* 同步调用；
* 异步调用；
* 状态共享；
* 依赖方向；
* 循环依赖；
* 扩展点。

说明模块之间为什么发生依赖，而不只是列出 import。

---

### 第七步：分析数据流和控制流

当 `include_data_flow=true` 时，描述一条或多条核心流程。

示例：

```text
用户请求
→ API 路由
→ 参数校验
→ 应用服务
→ 核心处理引擎
→ 数据存储
→ 响应序列化
→ 返回用户
```

对于编译器、AI、音视频或数据项目，可描述：

```text
输入读取
→ 预处理
→ 特征提取
→ 模型执行
→ 后处理
→ 输出生成
```

---

### 第八步：制定文档规划

在写入文件前，先形成内部文档规划，包括：

* 文档层级；
* 每篇文档的职责；
* 文件编号；
* 文件路径；
* 父子关系；
* 关联模块；
* TOC 展示顺序。

该规划用于生成文件，但不应替代正文。

---

### 第九步：生成全部文档

按照规划创建：

* 根目录 `TOC.md`；
* 项目总体概述；
* 架构总览；
* 各一级模块文档；
* 各二级子模块文档；
* 根据 `hierarchy_depth` 生成更深层级文档；
* 必要的入口、数据流、部署或扩展机制文档。

---

### 第十步：一致性检查

生成完成后必须检查：

* `TOC.md` 中的每个链接是否存在；
* 每个生成文件是否都出现在 `TOC.md`；
* 文件编号是否重复；
* 文件名和标题是否一致；
* 父子层级是否正确；
* 是否存在空文档；
* 是否存在未替换的占位符；
* 是否存在大量重复内容；
* 是否引用了不存在的源代码文件；
* 是否错误地分析了生成目录、依赖缓存或第三方代码。

发现问题后直接修正。

---

## 6. 文档目录与编号规范

### 6.1 根目录结构

默认输出结构示例：

```text
docs/project-analysis/
├── TOC.md
├── 00-project-overview.md
├── 01-architecture-overview.md
├── 02-core-runtime/
│   ├── 02-00-core-runtime-overview.md
│   ├── 02-01-task-scheduler.md
│   └── 02-02-execution-engine.md
├── 03-interface-layer/
│   ├── 03-00-interface-layer-overview.md
│   ├── 03-01-http-api.md
│   └── 03-02-cli.md
└── 04-infrastructure/
    ├── 04-00-infrastructure-overview.md
    ├── 04-01-storage.md
    └── 04-02-external-adapters.md
```

---

### 6.2 编号规则

使用层级编号保证排序稳定。

#### 项目级文档

```text
00-project-overview.md
01-architecture-overview.md
```

#### 一级模块目录

```text
02-core-runtime/
03-interface-layer/
04-infrastructure/
```

#### 一级模块总览

```text
02-00-core-runtime-overview.md
03-00-interface-layer-overview.md
```

#### 二级模块

```text
02-01-task-scheduler.md
02-02-execution-engine.md
03-01-http-api.md
```

#### 三级模块

当 `hierarchy_depth>=3` 时，可使用：

```text
02-core-runtime/
└── 02-01-task-scheduler/
    ├── 02-01-00-task-scheduler-overview.md
    ├── 02-01-01-task-queue.md
    └── 02-01-02-worker-pool.md
```

---

### 6.3 文件命名要求

文件名必须：

* 使用小写英文；
* 使用连字符分隔；
* 以编号开头；
* 文件扩展名为 `.md`；
* 编号反映文档层级；
* 名称简洁表达模块职责。

正确示例：

```text
02-01-request-routing.md
03-02-model-inference.md
04-01-database-storage.md
```

避免：

```text
模块1.md
其他.md
详细介绍.md
src目录.md
utils.md
```

---

## 7. TOC.md 生成规范

`TOC.md` 是整个文档集的唯一总目录。

必须链接到每一篇生成的 Markdown 文档，不得遗漏。

示例：

```markdown
# 项目结构与架构文档

## 项目总览

1. [项目概述](./00-project-overview.md)
2. [整体架构](./01-architecture-overview.md)

## 02 核心运行时

1. [核心运行时总览](./02-core-runtime/02-00-core-runtime-overview.md)
2. [任务调度](./02-core-runtime/02-01-task-scheduler.md)
3. [执行引擎](./02-core-runtime/02-02-execution-engine.md)

## 03 接口层

1. [接口层总览](./03-interface-layer/03-00-interface-layer-overview.md)
2. [HTTP API](./03-interface-layer/03-01-http-api.md)
3. [命令行接口](./03-interface-layer/03-02-cli.md)
```

当存在三级文档时，应在 TOC 中继续缩进：

```markdown
- [任务调度](./02-core-runtime/02-01-task-scheduler/02-01-00-task-scheduler-overview.md)
  - [任务队列](./02-core-runtime/02-01-task-scheduler/02-01-01-task-queue.md)
  - [Worker 池](./02-core-runtime/02-01-task-scheduler/02-01-02-worker-pool.md)
```

`TOC.md` 中还应包含：

```markdown
- 项目名称
- 分析时间
- 项目来源
- 分析范围
- 文档层级
- 是否包含代码入口分析
- 生成文档数量
```

---

## 8. 项目概述文档规范

文件：

```text
00-project-overview.md
```

至少包含：

```markdown
# 项目概述

## 1. 项目定位

## 2. 主要功能

## 3. 目标用户或调用者

## 4. 输入与输出

## 5. 技术栈

## 6. 项目核心组成

## 7. 核心运行流程

## 8. 文档阅读建议

## 9. 关键源代码位置
```

其中“文档阅读建议”应告诉读者：

* 首先阅读哪些文档；
* 只关注功能时阅读哪些文档；
* 只关注架构时阅读哪些文档；
* 需要修改代码时从哪里开始。

---

## 9. 架构总览文档规范

文件：

```text
01-architecture-overview.md
```

至少包含：

```markdown
# 整体架构

## 1. 架构摘要

## 2. 系统边界

## 3. 分层或组件结构

## 4. 模块职责划分

## 5. 模块依赖方向

## 6. 主要数据流

## 7. 主要控制流

## 8. 外部系统与依赖

## 9. 运行与部署形态

## 10. 扩展点

## 11. 架构特点与潜在风险

## 12. 关键源代码位置
```

可使用 Mermaid 表达模块关系，例如：

```mermaid
flowchart LR
    User[用户或调用方] --> Interface[接口层]
    Interface --> Application[应用层]
    Application --> Core[核心能力层]
    Core --> Infrastructure[基础设施层]
    Infrastructure --> External[外部系统]
```

Mermaid 图必须与代码分析结果一致，不得仅生成通用模板图。

---

## 10. 模块总览文档规范

每个一级模块目录中必须包含一个 `XX-00-*-overview.md`。

模块总览至少包含：

```markdown
# 模块名称

## 1. 模块职责

## 2. 在整体架构中的位置

## 3. 对外提供的能力

## 4. 内部子模块

## 5. 上游调用者

## 6. 下游依赖

## 7. 核心数据结构

## 8. 主要处理流程

## 9. 配置与扩展方式

## 10. 代码入口
```

当 `include_code_entrypoints=false` 时，将“代码入口”替换为：

```markdown
## 10. 功能边界与使用方式
```

继续包含：

```markdown
## 11. 设计特点

## 12. 潜在维护风险

## 13. 相关文档

## 14. 关键源代码位置
```

---

## 11. 子模块或组件文档规范

每篇具体子模块文档至少包含：

```markdown
# 子模块名称

## 1. 功能说明

## 2. 职责边界

## 3. 所属上级模块

## 4. 对外接口

## 5. 主要实现组成

## 6. 输入与输出

## 7. 处理流程

## 8. 依赖关系

## 9. 配置项

## 10. 错误处理

## 11. 扩展与修改建议

## 12. 关键源代码位置
```

当 `include_code_entrypoints=true` 时，还应根据实际情况增加：

```markdown
## 代码入口与调用链
```

示例格式：

```text
main.go:main
→ app.NewApplication
→ server.NewServer
→ router.RegisterRoutes
→ service.HandleRequest
→ runtime.Execute
```

不得虚构调用链。无法确认的调用关系应明确标注：

```text
根据静态代码分析推测
```

---

## 12. 不同分析模式的内容要求

### 12.1 `analysis_scope=full`

每篇文档应尽量覆盖：

* 功能职责；
* 架构位置；
* 代码组织；
* 模块接口；
* 数据流；
* 控制流；
* 运行方式；
* 配置方式；
* 扩展机制；
* 关键代码位置。

---

### 12.2 `analysis_scope=architecture`

重点覆盖：

* 系统边界；
* 分层方式；
* 模块划分；
* 依赖方向；
* 组件协作；
* 外部系统；
* 部署形态；
* 数据和控制流；
* 扩展机制；
* 架构风险。

降低以下内容的篇幅：

* 单个函数的实现；
* 细粒度算法；
* 普通工具函数；
* 局部代码技巧。

---

### 12.3 `analysis_scope=functional`

重点覆盖：

* 项目能完成哪些任务；
* 用户如何使用这些能力；
* 功能模块划分；
* 主要业务流程；
* 输入和输出；
* 模块间功能协作；
* 配置对功能的影响；
* 不同使用模式。

降低以下内容的篇幅：

* 底层框架实现；
* 构建细节；
* 内部工具代码；
* 低层调用链。

---

## 13. 代码入口分析规范

仅当 `include_code_entrypoints=true` 时完整执行。

至少区分以下入口类型：

```text
主程序入口
CLI 入口
HTTP 或 RPC 服务入口
桌面或 GUI 入口
后台 Worker 入口
定时任务入口
插件入口
测试或示例入口
```

对于每个重要入口，说明：

```text
入口文件
入口函数或类
启动参数
配置加载
组件初始化顺序
进入核心业务的调用路径
最终输出或长期运行状态
```

如果项目有多个应用，应分别描述，例如：

```text
服务端入口
管理端入口
命令行工具入口
后台任务入口
```

不要将测试入口和生产入口混为一谈。

---

## 14. 大型项目处理策略

对于大型 Monorepo 或代码量较大的项目：

1. 先识别各 Workspace、Package、Service 或 Application；
2. 判断哪些属于核心产品，哪些属于工具或示例；
3. 优先分析核心运行链路；
4. 对重复结构进行归类；
5. 不逐文件穷举；
6. 不因代码量大而只输出分析计划；
7. 仍然必须完成所有规划中的文档。

必要时可在项目概述中说明分析边界，例如：

```text
本次重点分析生产运行相关模块，测试夹具、第三方代码和自动生成文件仅作辅助参考。
```

---

## 15. 源代码证据规范

当 `include_source_references=true` 时，每篇文档末尾包含：

```markdown
## 关键源代码位置

| 路径 | 作用 |
|---|---|
| `src/app/main.go` | 主程序入口 |
| `internal/runtime/engine.go` | 核心执行引擎 |
| `internal/config/config.go` | 配置加载与校验 |
```

必要时可以增加符号名称：

```markdown
| 路径 | 关键符号 | 作用 |
|---|---|---|
| `src/server/app.go` | `NewServer` | 创建服务实例 |
| `src/server/router.go` | `RegisterRoutes` | 注册接口路由 |
```

只引用实际存在并已检查的路径。

---

## 16. 文档质量要求

生成的文档必须满足：

* 用词准确；
* 结构清晰；
* 主次分明；
* 避免重复；
* 避免空泛描述；
* 避免只罗列文件；
* 避免大段复制源代码；
* 结论有代码依据；
* 标题与文件名一致；
* 父子文档职责清晰；
* 每篇文档可以独立阅读；
* 不依赖读者先阅读全部源代码。

文档应重点解释：

```text
这个模块为什么存在
它承担什么职责
它与其他模块如何协作
修改它会影响什么
阅读代码应该从哪里开始
```

---

## 17. 禁止事项

禁止：

* 仅根据目录名称推测职责；
* 将所有文件逐一列出；
* 为每个工具函数生成文档；
* 把第三方依赖当作项目自身模块；
* 生成不存在的类、函数或文件；
* 虚构调用链；
* 输出只有标题的 Markdown 文件；
* 使用大量“可能”“大概”“通常”代替代码分析；
* 在未检查链接的情况下结束任务；
* 只生成目录而不生成正文；
* 只输出文档内容但不实际创建文件；
* 省略 `TOC.md`；
* 漏掉 TOC 到正文文件的链接；
* 在正文中留下 `TODO`、`待补充` 或占位符。

---

## 18. 最终完成报告

完成全部文件后，输出简短报告，格式如下：

```markdown
项目分析文档已生成。

- 项目来源：`<project_source>`
- 输出目录：`<output_directory>`
- 文档层级：`<hierarchy_depth>`
- 分析范围：`<analysis_scope>`
- 包含代码入口：`<include_code_entrypoints>`
- 生成文档数量：`<count>`
- 总目录：`<output_directory>/TOC.md`
```

同时报告：

* 是否发现多个程序入口；
* 是否发现 Monorepo 或多服务结构；
* 是否忽略了生成代码或第三方目录；
* 是否存在无法通过静态分析完全确认的部分。

---

# 执行指令

现在开始分析指定项目。

在开始生成文档前，应先读取项目代码并建立内部结构模型。

随后：

1. 按照参数确定分析范围；
2. 根据实际职责建立文档层次；
3. 创建带编号的目录和 Markdown 文件；
4. 完成每一篇正文；
5. 创建并完善 `TOC.md`；
6. 检查全部链接和文件；
7. 修复遗漏、空文件和编号错误；
8. 输出最终完成报告。

不得在仅完成规划或目录后停止。

---

# 调用参数模板

```yaml
project_source: "{{PROJECT_SOURCE}}"
output_directory: "{{OUTPUT_DIRECTORY | default: docs/project-analysis}}"
hierarchy_depth: "{{HIERARCHY_DEPTH | default: 2}}"
include_code_entrypoints: "{{INCLUDE_CODE_ENTRYPOINTS | default: true}}"
analysis_scope: "{{ANALYSIS_SCOPE | default: full}}"
include_external_dependencies: "{{INCLUDE_EXTERNAL_DEPENDENCIES | default: true}}"
include_data_flow: "{{INCLUDE_DATA_FLOW | default: true}}"
include_deployment_architecture: "{{INCLUDE_DEPLOYMENT_ARCHITECTURE | default: true}}"
include_source_references: "{{INCLUDE_SOURCE_REFERENCES | default: true}}"
language: "{{LANGUAGE | default: zh-CN}}"
overwrite_existing: "{{OVERWRITE_EXISTING | default: false}}"
```

# 调用示例

## 示例一：默认两层，包含代码入口

```yaml
project_source: "./my-project"
hierarchy_depth: 2
include_code_entrypoints: true
analysis_scope: full
```

## 示例二：三层架构分析，不分析代码入口

```yaml
project_source: "./my-project"
hierarchy_depth: 3
include_code_entrypoints: false
analysis_scope: architecture
```

## 示例三：只关注功能结构

```yaml
project_source: "https://github.com/example/project.git"
hierarchy_depth: 2
include_code_entrypoints: false
analysis_scope: functional
include_deployment_architecture: false
```
