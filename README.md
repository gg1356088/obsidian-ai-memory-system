# Obsidian AI Memory System

> 把 Obsidian 变成 AI agents 的共享记忆系统——跨 Claude Code / Codex / Hermes / 任意 AI 自动沉淀错误模式、同步项目学习、自进化知识结构。**AI 读到即执行，零 SDK 依赖。**

## 解决什么问题

| 痛点 | 本系统的解法 |
|------|------------|
| AI 老犯同样的错 | **错误模式库**——每次踩坑记录 E 编号，下次任何 AI 读到自动预防 |
| Claude Code 学到的东西 Codex 不知道 | **Obsidian 共用大脑**——所有 AI 读写同一份 markdown，不互相覆盖 |
| 知识越积越多但越来越乱 | **自进化机制**——每天自动健康扫描，每周整理，每月结构审查 |
| gstack learnings 只有 Claude Code 能用 | **gstack→Obsidian 自动同步**——JSONL 纯文件，任何 AI 都能读 |
| 换个 AI 工具经验全部丢失 | **跨 AI 共享记忆**——不分工具，知识跟着 vault 走 |
| 不知道沉淀什么、怎么沉淀 | **自动写入规则**——AI 读到触发条件自动判断并写入 |

## 核心架构

```
                    ┌─────────────────────────┐
                    │   Obsidian Vault         │
                    │   （长期知识中枢）          │
                    │                          │
                    │   system/  ← AI 行为规则  │
                    │   templates/ ← 模板       │
                    │   ...你的分类...           │
                    │                          │
                    │   所有 AI 工具共读共写       │
                    └──────┬──────────┬────────┘
                           │          │
              ┌────────────┘          └────────────┐
              ▼                                    ▼
    ┌──────────────────┐              ┌──────────────────┐
    │ Claude Code       │              │ Codex / Hermes   │
    │ /learn → 错误库   │              │ cat JSONL → 错误库│
    │ SKILL.md 自动加载 │              │ 读到即执行        │
    └──────────────────┘              └──────────────────┘
```

## 五分钟上手

### 方式 1：一键安装到 Claude Code

```bash
git clone https://github.com/gg1356088/obsidian-ai-memory-system.git ~/.claude/skills/obsidian-ai-memory
cd ~/.claude/skills/obsidian-ai-memory
bash setup.sh
```

重启 Claude Code 后，AI 会自动读取 system/ 下的规则并执行。

### 方式 2：仅复制到 Obsidian vault

```bash
git clone https://github.com/gg1356088/obsidian-ai-memory-system.git /tmp/obsidian-ai-memory
cp -r /tmp/obsidian-ai-memory/system /path/to/your-obsidian-vault/系统/
cp -r /tmp/obsidian-ai-memory/templates /path/to/your-obsidian-vault/模板/
```

在你的项目 `CLAUDE.md` 或 `AGENTS.md` 中加一行：

```markdown
读取并执行 `~/你的vault路径/系统/AI入口.md`
```

### 方式 3：零依赖（任何 AI 都能用）

不需要安装任何东西。告诉你的 AI：

> 读取 `/path/to/vault/系统/AI入口.md`，按里面的路由表执行

所有系统文件都是纯 Markdown——AI 读到即执行，不依赖 SDK、API key、或特定工具。

## 包含什么

| 文件 | 作用 | AI 什么时候读 |
|------|------|-------------|
| `system/AI入口.md` | 路由层——按任务类型精准读取 | 会话开始 |
| `system/AI协作准则.md` | 反问机制、Grill-Me、错误处理 | 会话开始 |
| `system/AI错误模式库.md` | 防踩坑——E001-E005 示例 | 任务匹配时 |
| `system/自进化机制.md` | 自动健康扫描、每日进化 | 会话开始 + 定时 |
| `system/知识库规则.md` | 8 大分类、命名、写入规范 | 写新内容时 |
| `system/AI数据层.md` | 结构化索引（AI 快速目录） | 会话开始 |
| `system/Obsidian共用大脑架构.md` | 跨 AI 共享设计 | 搭建多 AI 环境时 |
| `system/gstack学习自动同步规则.md` | gstack→Obsidian 同步 | /learn 后 |
| `system/知识收集工作流.md` | Inbox→分类→去重→入库 | 知识收集时 |
| `system/字段规范.md` | Frontmatter 字段参考 | 写 frontmatter 时 |
| `system/图谱化读取说明.md` | 知识图谱读取策略 | 理解知识关系时 |
| `system/AI人格画像模板.md` | AI 人格画像空模板 | 配置新 AI 时 |
| `templates/identity.md` | 你的身份（空模板） | 填完后每次读取 |
| `templates/user.md` | 用户画像（空模板） | 填完后每次读取 |
| `templates/soul.md` | 价值观/风格（空模板） | 填完后每次读取 |

## 适用于哪些 AI

| AI 工具 | 如何使用 |
|---------|---------|
| **Claude Code** | 安装为 skill（方式 1）→ `/learn` 自动触发同步，system/ 规则自动加载 |
| **Codex** | 方式 3 → `codex exec` 读取 system/ 文件并执行 |
| **Hermes** | 方式 3 → bash 脚本读 JSONL + 写 Obsidian |
| **Cursor** | 方式 2 → 复制到 vault，在 `.cursor/rules/` 中引用 |
| **Gemini CLI** | 方式 3 → 在 AGENTS.md 引用 Obsidian 路径 |
| **GitHub Copilot** | 方式 2 → 复制到 vault，在 `.github/copilot-instructions.md` 引用 |
| **任意 CLI 类 AI** | 方式 3 → 能读文件就能用，零依赖 |

## 自进化循环

```
AI 犯错 → 登记到 AI错误模式库.md（分配 E 编号）
                ↓
         下次会话 → 任何 AI 读到 → 匹配场景关键词 → 复述预防规则 → 不再犯
                ↓
         gstack /learn → learnings.jsonl → 自动比对 → 缺失则追加 E 条目
                ↓
         每日 cron → 健康扫描 → 断链/孤儿/空分类/gstack 同步 → 进化日志
```

## License

MIT — 随意使用、修改、分发。

## 关联

- [GStack](https://github.com/garrytan/gstack) — AI 编码技能套件（`/learn` 的数据源）
- [Obsidian](https://obsidian.md) — 知识库平台
- [Superpowers](https://github.com/obra/superpowers) — AI 开发方法论
