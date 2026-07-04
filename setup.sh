#!/usr/bin/env bash
# Obsidian AI Memory System — 一键安装脚本
# 用法：bash setup.sh [obsidian-vault-path]
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_NAME="obsidian-ai-memory"

echo "============================================"
echo " Obsidian AI Memory System — 安装"
echo "============================================"
echo ""

# ── 1. 检测安装目标 ──────────────────────────────────
DEFAULT_VAULT="$HOME/obsidian知识内容库"
VAULT_PATH="${1:-$DEFAULT_VAULT}"

echo "📍 Obsidian vault 路径：$VAULT_PATH"

# ── 2. 安装为 Claude Code skill ─────────────────────
CLAUDE_SKILLS_DIR="$HOME/.claude/skills/$SKILL_NAME"

if [ -d "$HOME/.claude" ]; then
    echo ""
    echo "🔧 检测到 Claude Code，安装为 skill..."

    if [ "$SCRIPT_DIR" != "$CLAUDE_SKILLS_DIR" ]; then
        rm -rf "$CLAUDE_SKILLS_DIR"
        cp -r "$SCRIPT_DIR" "$CLAUDE_SKILLS_DIR"
        echo "   ✅ 已安装到 $CLAUDE_SKILLS_DIR"
    else
        echo "   ✅ 已在正确位置"
    fi

    echo "   💡 重启 Claude Code 后生效"
else
    echo ""
    echo "⚠️  未检测到 Claude Code（~/.claude 不存在），跳过 skill 安装"
fi

# ── 3. 复制系统文件到 Obsidian vault ─────────────────
if [ -d "$VAULT_PATH" ]; then
    echo ""
    echo "📂 复制规则文件到 Obsidian vault..."

    # 创建目录
    mkdir -p "$VAULT_PATH/系统"
    mkdir -p "$VAULT_PATH/模板"

    # 复制系统文件（跳过当前状态，那是用户自己的）
    for f in "$SCRIPT_DIR/system/"*.md; do
        basename=$(basename "$f")
        if [ "$basename" != "当前状态.md" ]; then
            cp "$f" "$VAULT_PATH/系统/"
            echo "   ✅ 系统/$basename"
        fi
    done

    # 复制模板
    for f in "$SCRIPT_DIR/templates/"*.md; do
        basename=$(basename "$f")
        if [ ! -f "$VAULT_PATH/模板/$basename" ]; then
            cp "$f" "$VAULT_PATH/模板/"
            echo "   ✅ 模板/$basename"
        else
            echo "   ⏭️  模板/$basename 已存在，跳过"
        fi
    done

    echo ""
    echo "📝 下一步：填写模板文件"
    echo "   - $VAULT_PATH/模板/identity.md  ← 你是谁"
    echo "   - $VAULT_PATH/模板/user.md      ← 用户画像"
    echo "   - $VAULT_PATH/模板/soul.md       ← 价值观/风格"
else
    echo ""
    echo "⚠️  Obsidian vault 路径不存在：$VAULT_PATH"
    echo "   跳过文件复制。手动复制："
    echo "   cp -r $SCRIPT_DIR/system $VAULT_PATH/系统/"
    echo "   cp -r $SCRIPT_DIR/templates $VAULT_PATH/模板/"
fi

# ── 4. 验证 ──────────────────────────────────────────
echo ""
echo "============================================"
echo " 安装完成"
echo "============================================"
echo ""
echo "✅ 已安装的文件："
echo ""
echo "   系统规则（AI 读到即执行）："
for f in "$SCRIPT_DIR/system/"*.md; do
    echo "   - $(basename "$f")"
done
echo ""
echo "   用户模板（需要你填写）："
for f in "$SCRIPT_DIR/templates/"*.md; do
    echo "   - $(basename "$f")"
done
echo ""
echo "🚀 下一步："
echo "   1. 填写 templates/ 下的模板文件"
echo "   2. 在你的项目 CLAUDE.md 中引用 Obsidian vault"
echo "   3. 重启 Claude Code（如安装了 skill）"
echo "   4. 下次会话 AI 自动开始执行规则"
