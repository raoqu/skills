---
name: business-research-analysis
description: Research a business topic from user-provided context by using iterative web search and page reading to gather evidence, then create `docs/business/{yyyyMMdd}_{business_name}/REQUEST.md` and `OUTPUT.md` in the project path. Use when Codex needs to perform business discovery, market research, competitor analysis, customer/problem analysis, business-model validation, GTM research, or lightweight commercial due diligence for a company, product, market, or business opportunity.
---

# Business Research Analysis

## Overview

根据用户提供的业务背景，先固定调研范围和问题，再使用搜索工具进行多轮检索与页面读取，最后在项目路径下输出结构化调研结果。
始终保留用户原始上下文，始终给出可追溯来源，始终把事实、推断和待确认项分开写。

## Workflow

1. 提取用户给出的业务对象、目标、限制条件、地理范围、时间范围和决策场景。
2. 如果用户信息不完整，先基于已有上下文整理出最关键的待回答问题，再围绕这些问题设计第一轮搜索词。
3. 确认项目根目录；如果用户没有单独指定路径，默认使用当前工作区根目录。
4. 创建 `docs/business/{yyyyMMdd}_{business_name}/`；如果 `docs/business` 不存在则一并创建。
5. 先写 `REQUEST.md`，完整记录用户原始上下文，再补充本次调研目标、范围和必要假设。
6. 使用搜索工具做第一轮广泛检索，优先获取官方页面、行业报告、新闻报道、监管/协会资料、产品定价页、用户讨论或招聘信息等高信号来源。
7. 打开候选页面并提取关键信息，记录哪些问题已经回答、哪些仍然缺失、哪些结论彼此冲突。
8. 进行第二轮及后续搜索，针对缺口、冲突点、时间敏感信息和关键假设设计更窄、更具体的检索词。
9. 当核心问题已有足够证据或新增搜索的边际收益明显下降时，停止继续检索。
10. 生成 `OUTPUT.md`，输出结论、依据、风险、机会、待确认项和来源列表。

## Search Strategy

- 先宽后窄：先确认赛道、对象、基本商业模式，再深入客户、竞争、渠道、定价、监管和增长约束。
- 每一轮搜索后都重写问题清单，不要机械重复相同关键词。
- 优先近期且一手的来源；对时效性强的信息写清具体日期。
- 遇到数字、份额、融资、价格、政策、时间线等敏感信息时，至少交叉验证两类来源。
- 不要把单一新闻稿、营销文案或二手转载直接当作定论。
- 如果搜索结果明显不足，明确写出“已搜索但证据不足”的范围，而不是补全想象。

## Directory And Naming Rules

- 目录固定为 `docs/business/{yyyyMMdd}_{business_name}`。
- `yyyyMMdd` 使用当前本地日期，例如 `20260413`。
- `business_name` 使用简洁且稳定的名称。
- 如果名称主要由拉丁字母和数字组成，转成小写并用连字符替换空格。
- 如果名称是中文，保留简短中文名，但避免空格和路径标点。
- 除非用户明确要求，不要在该目录下额外创建无关文件。

## REQUEST.md Rules

- 首先记录用户原始上下文，尽量保留原文，不要擅自改写语义。
- 明确写出调研对象、目标、范围、输出路径和调研日期。
- 如果你补充了工作假设，单独列在“假设”部分，不要混入“原始上下文”。
- 如果用户已经给出明确问题列表，原样保留。

## OUTPUT.md Rules

- 先给“核心结论摘要”，让读者快速判断是否值得继续。
- 把“事实”“推断”“待确认”区分开。
- 输出必须围绕用户的业务问题，而不是泛化成教科书式行业介绍。
- 结论后面给证据，不要只给观点。
- 有不确定性时，直接指出不确定性的来源，例如样本不足、来源冲突、信息过期、仅有间接证据。
- 给出下一步建议时，要贴近业务决策，例如继续访谈、验证渠道、补充财务假设、关注某个监管变化。
- 在文末列出来源，至少包含标题或站点、链接，以及必要时的发布日期/访问日期。

## Required Coverage

根据题目相关性覆盖下列维度，不需要为了凑结构强行写无关部分：

- 研究对象与问题定义
- 业务概览与价值主张
- 目标客户与需求信号
- 市场环境与行业趋势
- 竞争格局与替代方案
- 商业模式、收入逻辑或定价线索
- 核心风险、约束和未知项
- 可执行建议与下一步验证动作

## Evidence Rules

- 优先引用原始来源，例如官网、官方文档、财报、监管公告、产品页面、招聘页面、创始人采访原文。
- 次优先使用高质量媒体、研究机构、行业协会、数据库摘要。
- 标注明显推断，例如 `推断：该产品主要靠渠道分销而非直销增长。`
- 标注明显待确认项，例如 `待确认：尚未找到公开可验证的客单价数据。`
- 如果多个来源冲突，写出冲突点，不要只保留最顺手的一个。

## Deliverable Checklist

- 确保 `docs/business/{yyyyMMdd}_{business_name}/REQUEST.md` 存在。
- 确保 `docs/business/{yyyyMMdd}_{business_name}/OUTPUT.md` 存在。
- 确保 `REQUEST.md` 含有用户原始上下文。
- 确保 `OUTPUT.md` 含有结论、依据、风险/未知项和来源。
- 确保时效性强的信息写明具体日期。
- 确保没有把猜测写成事实。

## Resources

在开始写文件前，先读取 [references/output-contract.md](references/output-contract.md) 作为输出模板和最小覆盖清单。
