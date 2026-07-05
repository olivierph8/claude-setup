#!/usr/bin/env bash
#
# Claude Code 一鍵安裝腳本
# 安裝 Dan 於 2026-07-05 整理的插件與工具組
#
# 用法：
#   bash install.sh              # 安裝全部核心項目
#   bash install.sh --with-gstack   # 另外含 gstack skill 套件（需額外手動步驟）
#
set -uo pipefail

BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
step() { echo -e "\n${BLUE}▶ $1${NC}"; }
ok()   { echo -e "${GREEN}  ✔ $1${NC}"; }
warn() { echo -e "${YELLOW}  ! $1${NC}"; }
die()  { echo -e "${RED}  ✘ $1${NC}"; exit 1; }

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
ok "claude / node $(node -v) / git 都就緒"

# ── 1. Superpowers（插件）─────────────────────
step "1/3 安裝 Superpowers 插件"
if claude plugin list 2>/dev/null | grep -q "superpowers@claude-plugins-official"; then
  ok "已安裝，略過"
else
  claude plugin install superpowers@claude-plugins-official && ok "Superpowers 安裝完成" \
    || warn "自動安裝失敗，請在 Claude Code 內手動執行：/plugin install superpowers@claude-plugins-official"
fi

# ── 2. claude-mem（記憶插件）──────────────────
step "2/3 安裝 claude-mem 記憶系統"
npx --yes claude-mem install </dev/null && ok "claude-mem 安裝完成" \
  || warn "安裝過程有警告，請檢查輸出"
echo -e "  啟動背景 worker ..."
npx --yes claude-mem start </dev/null >/dev/null 2>&1 && ok "worker 已啟動（http://localhost:37701）" \
  || warn "worker 未自動啟動，稍後可手動執行：npx claude-mem start"

# ── 3. context-infrastructure（藍圖 / 需設定）──
step "3/3 clone context-infrastructure 藍圖"
CI_DIR="$HOME/context-infrastructure"
if [ -d "$CI_DIR/.git" ]; then
  ok "已存在於 $CI_DIR，略過"
else
  git clone https://github.com/grapeot/context-infrastructure "$CI_DIR" \
    && ok "已 clone 至 $CI_DIR" || warn "clone 失敗"
fi
warn "context-infrastructure 是藍圖，需手動填寫 rules/USER.md 才會生效"

# ── 選用：gstack ─────────────────────────────
if [ "${1:-}" = "--with-gstack" ]; then
  step "選用：gstack skill 套件"
  warn "gstack 安裝較繁複（含 Chromium 下載），請依官方說明操作："
  echo "     https://github.com/garrytan/gstack"
  warn "注意：Chromium 安裝步驟可能需手動 curl + unzip 繞過。"
fi

# ── 完成 ────────────────────────────────────
echo -e "\n════════════════════════════════════════════"
echo -e "${GREEN}  安裝完成！${NC}"
echo "════════════════════════════════════════════"
echo "  下一步："
echo "   1. 重新啟動 Claude Code（讓插件 hook 生效）"
echo "   2. 填寫 ~/context-infrastructure/rules/USER.md"
echo "   3. claude-mem 的記憶會從第二次 session 開始注入"
echo ""
echo "  驗證：claude plugin list"
