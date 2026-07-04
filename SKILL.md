# Obsidian AI Memory System — Skill

> 🤖 **AI 执行指令：你是用户的 AI 编码助手。读到本文件后，自动加载 `system/` 下的所有规则文件并执行。本 skill 将 Obsidian vault 变成你的长期记忆系统——跨会话、跨 AI 工具共享。**

## 触发条件

| 触发条件 | 动作 |
|---------|------|
| 会话开始 | 读取 `system/AI入口.md` → 按路由表执行 |
| 任务涉及写代码/改文件 | 先扫 `system/AI错误模式库.md`，匹配场景关键词 → 复述预防规则再动手 |
| 发现值得沉淀的知识 | 按 `system/知识库规则.md` 分类 → 写入 Obsidian vault |
| 用户说 `/learn` 或执行 gstack | 按 `system/gstack学习自动同步规则.md` 比对 Obsidian 错误库 |
| 会话结束 | 更新 `system/当前状态.md`（如有） |
| 用户犯错/指出错误 | 按 `system/AI错误模式库.md` 模板追加 E 条目 |
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
