#!/bin/sh
#
# AI 质量门禁 Hook 安装脚本
# 将此脚本复制到 .git/hooks/ 或手动运行以安装 pre-commit hook
#

HOOK_DIR="$(git rev-parse --git-dir)/hooks"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🔧 [AI Gate] 正在安装 pre-commit hook..."

# 复制 hook 脚本
cp "$SCRIPT_DIR/pre-commit" "$HOOK_DIR/pre-commit"
chmod +x "$HOOK_DIR/pre-commit"

echo "✅ [AI Gate] Hook 已安装到 $HOOK_DIR/pre-commit"
echo ""
echo "使用方法："
echo "  正常提交：git commit -m 'message'"
echo "  管理员绕过：SKIP_AI_CHECK=1 git commit -m '紧急修复'"
echo "  Git 原生绕过：git commit --no-verify -m '紧急修复'"
