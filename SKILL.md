# Obsidian AI Memory System — Skill

> 🤖 **AI 执行指令：你是用户的 AI 编码助手。读到本文件后，自动加载 `system/` 下的所有规则文件并执行。本 skill 将 Obsidian vault 变成你的长期记忆系统——跨会话、跨 AI 工具共享。**

## 触发条件

| 触发条件 | 动作 |
|---------|------|
| 会话开始 | 读取 `system/AI入口.md` → 按路由表执行（含读写规则） |
| 任务涉及写代码/改文件 | 先扫 `system/AI错误模式库.md`，匹配场景关键词 → 复述预防规则再动手 |
| 发现值得沉淀的知识 | 按 `system/知识库规则.md` 分类 → 写入 Obsidian vault |
| 用户说 `/learn` 或执行 gstack | 按 `system/gstack学习自动同步规则.md` 比对 Obsidian 错误库 |
| 会话结束 | 🔴 强制执行写入规则（见 `system/AI入口.md` 写入规则表）：① 更新 `[[log]]` → ② 注册新文件到 `[[index]]` → ③ 🆕 自检本轮是否被用户纠正过 → 有则自动提取 E 条目到 `system/AI错误模式库.md` → ④ 更新 `system/当前状态.md` |
| 对 Obsidian vault 做了任何修改（修复、新增、重构、批量改动等） | 必须执行完整的「收尾三步」：① 更新 `system/当前状态.md`（做了什么+决定+待办）→ ② 追加 vault 的 `日志/知识库日志.md`（时间+操作摘要）→ ③ 判断是否有方法论价值：有则创建 `日志/会话沉淀/YYYY-MM-DD 主题.md`（面向其他 AI 的操作文档），无则跳过。三步全部完成才算结束。见 `system/AI错误模式库.md` E011。 |
| 用户犯错/指出错误 | 当场按 `system/AI错误模式库.md` 模板记录 E 条目；🆕 如当场未记录，会话结束时自动提取（见错误模式库「会话结束自动提取规则」） |
| 操作不可逆或指令模糊 | 按 `system/AI协作准则.md` 反问机制处理 |

## 规则文件位置

本 skill 的规则文件在 `system/` 目录下（相对于本 SKILL.md）。

如果作为 Claude Code skill 安装（`~/.claude/skills/obsidian-ai-memory/`），AI 自动读取同目录下的 `system/` 文件。

如果仅复制到 Obsidian vault，在你的项目 `CLAUDE.md` 中引用：

```markdown
## 知识库规则
读取并执行 `~/你的vault路径/系统/AI入口.md`
```

## 零依赖原则

本 skill 的所有规则都是纯 Markdown 文件。AI 只需要能读文件就能执行。不需要：
- ❌ 不需要 Node.js / Python / bun
- ❌ 不需要 API key
- ❌ 不需要 MCP server
- ❌ 不需要任何 CLI 工具
- ✅ 只需要文件系统读取权限

## 与 gstack 的协作

如果用户已安装 [gstack](https://github.com/garrytan/gstack)：
- `/learn` 产生的 learnings 自动同步到 Obsidian 错误模式库
- 同步规则见 `system/gstack学习自动同步规则.md`

如果没有 gstack：
- 错误模式库仍然有效（AI 会话中直接发现和记录）
- gstack learnings 数据（`~/.gstack/projects/*/learnings.jsonl`）如有，可直接 `cat` 读取
