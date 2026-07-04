---
title: gstack学习自动同步规则
type: schema
status: active
created: 2026-07-05
tags: [gstack, learnings, cross-ai, auto-sync, error-patterns]
---

# gstack 学习自动同步规则

> 🤖 当任何 AI agent 发现 gstack learnings 存在但 Obsidian 错误模式库中缺失对应条目时，自动执行同步。

## 一、触发条件

| 触发条件 | 动作 |
|---------|------|
| 执行 /learn 或读取 learnings.jsonl | 逐条比对 Obsidian 系统/AI错误模式库.md |
| 发现 gstack learning 无对应 E 编号 | 自动分配编号并追加条目 |
| 会话结束时 | 检查本轮是否新增 gstack learning |

## 二、同步规则

### 2.1 比对逻辑

```
FOR each gstack learning:
  1. 提取 learning.key 和 learning.insight
  2. 扫描 AI错误模式库.md 中所有 E 条目的场景关键词和现象
  3. 关键词至少命中 2 个 → 已存在，跳过
  4. 标题相似度 > 70% → 已存在，添加交叉引用
  5. 以上都不匹配 → 新条目，分配下一个 E 编号并追加
```

### 2.2 写入格式

```markdown
### E[N]：[简短标题]

| 字段 | 内容 |
|------|------|
| 日期 | YYYY-MM-DD |
| 来源 | gstack learning `[key]` |
| 场景关键词 | `[从 learning 推断]` |
| 现象 | [从 learning.insight 提取] |
| 根因 | [从 learning.insight 推断] |
| 预防规则 | [转化为可执行的预防规则] |
```

### 2.3 交叉引用

如果 gstack learning 对应已有 E 条目，在该 E 条目的来源字段追加 gstack learning 引用。

## 三、gstack learnings 数据位置

```bash
~/.gstack/projects/<slug>/learnings.jsonl

# 列出所有项目的 learnings
find ~/.gstack/projects -name "learnings.jsonl" 2>/dev/null

# 读取
cat ~/.gstack/projects/<your-project-slug>/learnings.jsonl
```

JSONL 格式：每行一个 JSON 对象，字段包括 skill、type、key、insight、confidence、files、ts。

## 四、零依赖方案

不需要安装 GStack。learnings 是纯 JSONL 文件，任何 AI 直接读。

```bash
# 任何 AI 三步完成同步：
cat ~/.gstack/projects/<slug>/learnings.jsonl
grep "gstack learning" 系统/AI错误模式库.md
# 缺失则按模板追加 E 条目到 AI错误模式库.md
```

## 五、安装 GStack（可选，仅 Claude Code）

```bash
git clone https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack && ./setup
```

## 六、同步后验证

- [ ] AI错误模式库.md 中 E 编号连续无跳号
- [ ] 新条目来源标注了 gstack learning
- [ ] 新条目预防规则是可执行的
- [ ] 在日志/每日进化/中记录了本次同步

## 关联

- [[系统/AI错误模式库]]
- [[系统/自进化机制]]
- [[系统/知识库规则]]
- [[系统/AI协作准则]]
