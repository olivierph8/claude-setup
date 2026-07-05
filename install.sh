#!/usr/bin/env bash
#
# Claude Code 一鍵安裝腳本
# 安裝 Dan 於 2026-07-05 整理的插件、skill 與工具組
#
#   1. Superpowers            https://github.com/obra/superpowers
#   2. claude-mem             https://github.com/thedotmack/claude-mem
#   3. context-infrastructure https://github.com/grapeot/context-infrastructure
#   4. gstack                 https://github.com/garrytan/gstack
#
# 用法：
#   bash install.sh                # 安裝全部四項
#   bash install.sh --skip-gstack  # 跳過 gstack（它的 Chromium 步驟較容易卡）
#
set -uo pipefail

BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
step() { echo -e "\n${BLUE}▶ $1${NC}"; }
ok()   { echo -e "${GREEN}  ✔ $1${NC}"; }
warn() { echo -e "${YELLOW}  ! $1${NC}"; }
die()  { echo -e "${RED}  ✘ $1${NC}"; exit 1; }

SKIP_GSTACK=false
[ "${1:-}" = "--skip-gstack" ] && SKIP_GSTACK=true

echo "════════════════════════════════════════════"
echo "  Claude Code 環境安裝腳本"
echo "════════════════════════════════════════════"

# ── 前置檢查 ────────────────────────────────
step "檢查前置需求"
command -v claude >/dev/null 2>&1 || die "找不到 claude CLI，請先安裝 Claude Code"
command -v node   >/dev/null 2>&1 || die "找不到 node，請先安裝 Node.js（需 ≥ 20）"
command -v git    >/dev/null 2>&1 || die "找不到 git"
NODE_MAJOR=$(node -p "process.versions.node.split('.')[0]")
[ "$NODE_MAJOR" -ge 20 ] || die "Node 版本需 ≥ 20（目前 $(node -v)）"
command -v bun >/dev/null 2>&1 && ok "bun 已安裝（gstack 需要）" || warn "未偵測到 bun，gstack setup 會嘗試自動安裝"
ok "claude / node $(node -v) / git 都就緒"

# ── 1. Superpowers（插件）─────────────────────
step "1/4 安裝 Superpowers 插件"
if claude plugin list 2>/dev/null | grep -q "superpowers@claude-plugins-official"; then
  ok "已安裝，略過"
else
  claude plugin install superpowers@claude-plugins-official && ok "Superpowers 安裝完成" \
    || warn "自動安裝失敗，請在 Claude Code 內手動執行：/plugin install superpowers@claude-plugins-official"
fi

# ── 2. claude-mem（記憶插件）──────────────────
step "2/4 安裝 claude-mem 記憶系統"
npx --yes claude-mem install </dev/null && ok "claude-mem 安裝完成" \
  || warn "安裝過程有警告，請檢查輸出"
echo -e "  啟動背景 worker ..."
npx --yes claude-mem start </dev/null >/dev/null 2>&1 && ok "worker 已啟動（http://localhost:37701）" \
  || warn "worker 未自動啟動，稍後可手動執行：npx claude-mem start"

# ── 3. context-infrastructure（藍圖 / 需設定）──
step "3/4 clone context-infrastructure 藍圖"
CI_DIR="$HOME/context-infrastructure"
if [ -d "$CI_DIR/.git" ]; then
  ok "已存在於 $CI_DIR，略過"
else
  git clone https://github.com/grapeot/context-infrastructure "$CI_DIR" \
    && ok "已 clone 至 $CI_DIR" || warn "clone 失敗"
fi
warn "context-infrastructure 是藍圖，需手動填寫 rules/USER.md 才會生效"

# ── 4. gstack（skill 套件）────────────────────
step "4/4 安裝 gstack skill 套件"
if [ "$SKIP_GSTACK" = true ]; then
  warn "依 --skip-gstack 指定，跳過 gstack"
else
  GS_DIR="$HOME/.claude/skills/gstack"
  if [ -d "$GS_DIR/.git" ]; then
    ok "已存在於 $GS_DIR，略過 clone"
  else
    git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git "$GS_DIR" \
      && ok "已 clone gstack" || warn "clone 失敗"
  fi
  if [ -x "$GS_DIR/setup" ]; then
    echo -e "  執行 gstack setup（會下載 Chromium，可能較久）..."
    ( cd "$GS_DIR" && ./setup --prefix </dev/null ) \
      && ok "gstack setup 完成（skill 以 gstack- 前綴載入）" \
      || warn "gstack setup 未完全成功 — 常見於 Chromium 下載卡住。見 README 的「gstack Chromium 繞過」段落。"
  else
    warn "找不到 gstack setup 腳本"
  fi
fi

# ── 完成 ────────────────────────────────────
echo -e "\n════════════════════════════════════════════"
echo -e "${GREEN}  安裝完成！${NC}"
echo "════════════════════════════════════════════"
echo "  下一步："
echo "   1. 重新啟動 Claude Code（讓插件與 skill 生效）"
echo "   2. 填寫 ~/context-infrastructure/rules/USER.md"
echo "   3. claude-mem 的記憶會從第二次 session 開始注入"
echo ""
echo "  驗證："
echo "   claude plugin list                 # superpowers, claude-mem"
echo "   ls ~/.claude/skills | grep gstack  # gstack-* skill"
