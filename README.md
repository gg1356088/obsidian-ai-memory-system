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

### Claude Code（推荐安装为 Skill）

```bash
git clone https://github.com/gg1356088/obsidian-ai-memory-system.git ~/.claude/skills/obsidian-ai-memory
cd ~/.claude/skills/obsidian-ai-memory
bash setup.sh ~/你的obsidian-vault路径
```

重启 Claude Code 后生效。AI 自动加载 `system/` 下的规则，`/learn` 自动触发 gstack→Obsidian 同步。

**手动方式（不安 skill）：** 在你的项目根目录 `CLAUDE.md` 中加一行：

```markdown
读取并执行 `~/你的vault路径/系统/AI入口.md`
读取并执行 `~/你的vault路径/系统/AI协作准则.md`
读取并执行 `~/你的vault路径/系统/AI错误模式库.md`
```

---

### Codex

两种接入方式，按需选：

**A. 全局配置（推荐）** — 一次配置，所有 Codex 项目共享大脑：

```bash
# 1. 下载系统文件到 Obsidian vault
git clone https://github.com/gg1356088/obsidian-ai-memory-system.git /tmp/obsidian-ai-memory
cp -r /tmp/obsidian-ai-memory/system ~/你的obsidian-vault路径/系统/

# 2. 写入 Codex 全局配置文件
cat >> ~/.codex/AGENTS.md << 'EOF'

## 🧠 共用大脑
每次会话启动时：
1. 读取 `~/你的obsidian-vault路径/系统/AI入口.md`，按路由表决定读哪些规则
2. 扫描 `~/你的obsidian-vault路径/系统/AI错误模式库.md`，匹配当前任务的场景关键词
3. 发现值得沉淀的知识 → 按 `~/你的obsidian-vault路径/系统/知识库规则.md` 写回 Obsidian
EOF
```

**B. 单项目配置** — 在具体项目的 `AGENTS.md` 中引用：

```markdown
读取并执行 `~/你的vault路径/系统/AI入口.md`
读取并执行 `~/你的vault路径/系统/AI错误模式库.md`
写入规则：所有长期知识写入 Obsidian（`~/你的vault路径/`），不写入本项目目录
```

**验证：** 启动 Codex 新会话，问它 "请从我的 Obsidian 共用大脑加载规则"，看它能否读对文件。

---

### Hermes

Hermes 通过 bash hooks 读取 Obsidian vault 中的规则。配置方法：

**1. 下载系统文件：**

```bash
git clone https://github.com/gg1356088/obsidian-ai-memory-system.git /tmp/obsidian-ai-memory
cp -r /tmp/obsidian-ai-memory/system ~/你的obsidian-vault路径/系统/
```

**2. 配置 session-start hook：**

在 Hermes 的 `~/.hermes/config.yaml`（或项目根目录的 `.hermes.yaml`）中添加：

```yaml
hooks:
  session_start:
    - command: |
        cat ~/你的obsidian-vault路径/系统/当前状态.md
      description: "加载跨会话记忆"
    - command: |
        cat ~/你的obsidian-vault路径/系统/AI错误模式库.md
      description: "加载错误预防规则"
  task_start:
    - command: |
        cat ~/你的obsidian-vault路径/系统/AI入口.md
      description: "按路由表精准加载规则"

  session_end:
    - command: |
        echo "## 上一轮做了什么" > ~/你的obsidian-vault路径/系统/当前状态.md.tmp
        echo "（请在此记录本轮关键产出和决策）" >> ~/你的obsidian-vault路径/系统/当前状态.md.tmp
        mv ~/你的obsidian-vault路径/系统/当前状态.md.tmp ~/你的obsidian-vault路径/系统/当前状态.md
      description: "更新跨会话状态"
```

**3. 配置 gstack→Obsidian 自动同步：**

```yaml
hooks:
  post_task:
    - command: |
        LEARNINGS_FILE="$HOME/.gstack/projects/$(basename $(pwd))/learnings.jsonl"
        if [ -f "$LEARNINGS_FILE" ]; then
          echo "📋 gstack learnings 已更新，记得比对 Obsidian 错误模式库"
          echo "   cat $LEARNINGS_FILE"
          echo "   缺失条目追加到 系统/AI错误模式库.md"
        fi
      description: "提醒对比 gstack learnings"
```

**验证：** 启动 Hermes 新会话，看它是否自动 `cat` 了 Obsidian 状态文件和错误模式库。

---

### 零依赖（任意 AI 都能用）

不依赖任何特定工具——只要 AI 能读文件就能用。

告诉你的 AI：

> 读取 `/path/to/vault/系统/AI入口.md`，按里面的路由表执行。所有系统文件都是纯 Markdown，读到即执行。

| AI 工具 | 配置位置 | 加什么 |
|---------|---------|--------|
| **Claude Code** | `~/.claude/skills/` 或项目 `CLAUDE.md` | `读取 ~/vault/系统/AI入口.md` |
| **Codex** | `~/.codex/AGENTS.md` 或项目 `AGENTS.md` | 同上 |
| **Hermes** | `~/.hermes/config.yaml` hooks | `cat ~/vault/系统/` + 文件路径 |
| **Cursor** | `.cursor/rules/` | 复制 `system/` 文件过去 |
| **Gemini CLI** | 项目 `AGENTS.md` | `读取 ~/vault/系统/AI入口.md` |
| **GitHub Copilot** | `.github/copilot-instructions.md` | 同上 |
| **任意 CLI 类 AI** | 项目 `AGENTS.md` / `CLAUDE.md` | 同上 |

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

## 各 AI 工具配置速查

| AI 工具 | 配置方式 | 核心能力 |
|---------|---------|---------|
| **Claude Code** | Skill 安装 → `sys-shared-brain` 自动加载 | `/learn` → gstack→Obsidian 自动同步 |
| **Codex** | `~/.codex/AGENTS.md` 全局 or 项目 `AGENTS.md` | 零依赖——读到即执行 |
| **Hermes** | `~/.hermes/config.yaml` hooks | Session-start / task-start / session-end hooks |
| **Cursor** | `.cursor/rules/` 复制 system/ 文件 | 规则自动注入 |
| **Gemini CLI** | 项目 `AGENTS.md` 引用 Obsidian 路径 | 零依赖——读到即执行 |
| **GitHub Copilot** | `.github/copilot-instructions.md` | 零依赖——读到即执行 |

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
