# 🚪 AI 质量门禁系统 — 可复用模板

基于 Claude Code Agent + pre-commit hook 的代码质检门禁。适用于任何新项目。

---

## 📁 文件结构

```
.claude/
├── agents/
│   ├── pass.md              # 准入控制工程师（总调度）
│   ├── tester.md            # 单元测试工程师
│   └── quality-engineer.md  # 质量检测工程师
└── hooks/
    ├── pre-commit           # Git pre-commit hook 脚本
    └── install-hooks.sh     # 一键安装脚本
```

---

## 🚀 使用步骤（在新项目里执行）

1. 把 `.claude` 目录复制到你的项目根目录
2. 在终端执行：`chmod +x .claude/hooks/install-hooks.sh`
3. 运行：`.claude/hooks/install-hooks.sh`
4. 在 `.gitignore` 里加一行：`.claude/hooks/reports/`
5. 正常 `git commit`，门禁自动触发

### Windows 环境说明

Windows 没有 `chmod` 命令，手动操作：
- 把 `hooks\pre-commit` 复制到项目根目录下的 `.git\hooks\pre-commit`
- 注意 Windows 可能需要重命名成 `pre-commit`（不带扩展名）

---

## 🔧 适配不同语言

默认面向 **Python**（pytest + ruff + mypy + bandit）。

### Node.js / TypeScript 项目

修改 `agents/tester.md`（L1 层测试命令）：
```bash
# 原来的 Python 命令
cd backend && python -m pytest tests/ -v --tb=short
# 改成 Node.js
cd frontend && npm run test:run
```

修改 `agents/quality-engineer.md`（L2 层代码规范工具）：
```bash
# 原来的 Python 命令
cd backend && python -m ruff check app/
# 改成 JS/TS
cd frontend && npx eslint src/
```

其他语言（Go / Java / Rust）同理，把 L1/L2 层的命令换成对应语言的测试和 lint 工具即可。

---

## 🔐 管理员绕过

紧急情况下跳过检测：

```bash
# 方式一：环境变量
SKIP_AI_CHECK=1 git commit -m "紧急修复"

# 方式二：Git 原生绕过
git commit --no-verify -m "紧急修复"
```

两种绕过都会记录到 `.claude/hooks/bypass.log`，方便事后审计。

---

## ⚙️ 配置项

| 配置项 | 位置 | 默认值 |
|--------|------|--------|
| 覆盖率阈值 | `agents/tester.md` L2 层 | 80% |
| Hook 总超时 | `hooks/pre-commit` 的 `timeout` | 120秒 |
| 子 Agent 超时 | 各 agent 定义 | 60秒 |
| 报告保存路径 | `hooks/pre-commit` | `.claude/hooks/reports/` |
| Bypass 日志 | `hooks/pre-commit` | `.claude/hooks/bypass.log` |

---

## 📋 退出码

| 退出码 | 含义 |
|--------|------|
| 0 | 准入通过，允许 commit |
| 1 | 准入拒绝，阻止 commit |
| 2 | 检测异常（环境错误、超时等） |

---

## 📝 注意事项

1. 需要全局安装 Claude Code CLI：`npm install -g @anthropic-ai/claude-code`
2. 确保 Claude API 密钥已配置（`claude auth login`）
3. 每次门禁检测会生成一份 Markdown 报告到 `.claude/hooks/reports/`
4. 检测失败会阻止提交，按报告里的建议修复后重新 `git add` 再提交
5. 建议将 `.claude/hooks/reports/` 和 `.claude/hooks/bypass.log` 加入 `.gitignore`

---

*模板版本：v1.0 | 由 langchainRAG 项目提取*
