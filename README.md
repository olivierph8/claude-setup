# Claude Code 環境安裝包

> 整理日期：2026-07-05 · by Dan
> 一鍵重現這台機器上安裝的 Claude Code 插件、skill 與工具組。

## 🚀 快速安裝

```bash
git clone https://github.com/olivierph8/claude-setup
cd claude-setup
bash install.sh                # 安裝全部四項
# bash install.sh --skip-gstack   # 若不想裝 gstack（Chromium 步驟較容易卡）
```

**前置需求**：Claude Code（含 `claude` CLI）、Node.js ≥ 20、git、bun（gstack 需要，setup 會嘗試自動裝）。

安裝完 **重啟 Claude Code** 讓插件與 skill 生效。

---

## 📦 內容清單

| # | 名稱 | 類型 | 一句話 | 來源 |
|---|------|------|--------|------|
| 1 | **Superpowers** | Claude Code 插件 | 開發用 skill（TDD、除錯、寫計畫、平行 subagent…） | https://github.com/obra/superpowers |
| 2 | **claude-mem** | Claude Code 插件 | 自動捕捉 session、壓縮成記憶、下次自動注入 | https://github.com/thedotmack/claude-mem |
| 3 | **context-infrastructure** | 藍圖（clone 後設定） | 讓 AI 長期記住你是誰的情境結構範本 | https://github.com/grapeot/context-infrastructure |
| 4 | **gstack** | Skill 套件 | 56+ 個 skill：QA、設計審查、部署、除錯、文件… | https://github.com/garrytan/gstack |

---

## 🔍 各項目說明

### 1. Superpowers
- **裝完有什麼**：`superpowers:*` 系列 skill，例如
  `brainstorming`、`test-driven-development`、`systematic-debugging`、
  `writing-plans` / `executing-plans`、`writing-skills`、`using-git-worktrees` 等。
- **開箱即用**：✅ 裝完即可在 Claude Code 內叫用。

### 2. claude-mem（記憶系統）
- **做什麼**：被動記錄你在每個專案做的事，下次打開自動把相關 context 帶回來。
- **注意事項**：
  - 記憶注入從**第二次** session 才開始。
  - 資料全部留在本機 `~/.claude-mem`。
  - 背景 worker：`npx claude-mem start`，介面 http://localhost:37701
  - 剛裝好若看到 `failed to load: cache-miss`，**重啟 Claude Code 即恢復**。
  - 常用指令：`/how-it-works`、`/learn-codebase`（把整個 repo 吃進記憶）。

### 3. context-infrastructure（藍圖，非開箱即用）
- **重點**：這是**範本**，不是成品。clone 只是第一步。
  - ✅ **必做**：填寫 `rules/USER.md`（你的稱呼、時區、背景、偏好）—— CP 值最高。
  - ⚠️ 記憶引擎（`observer.py` / `reflector.py`）**無法開箱即用**：
    repo 沒附 `opencode_client.py`，需自行接 Claude／OpenAI API + 設 cron。
  - 原本為 OpenCode 設計，部分 subagent 語法用於 Claude Code 需調整。

### 4. gstack（skill 套件）
- **裝完有什麼**：56+ 個 `gstack-*` skill —— 例如
  `gstack-qa`、`gstack-ship`、`gstack-review`、`gstack-design-review`、
  `gstack-investigate`、`gstack-land-and-deploy`、`gstack-make-pdf` 等。
- **手動安裝方式**（腳本已自動做）：
  ```bash
  git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack \
    && cd ~/.claude/skills/gstack && ./setup --prefix
  ```
  - `--prefix`：指令加 `gstack-` 前綴（例 `/gstack-qa`）。想要短指令用 `--no-prefix`（`/qa`）。
- **⚠️ gstack Chromium 繞過**：`./setup` 會下載 Chromium 供瀏覽器 QA 用，某些環境會**卡在下載**。
  若 setup 卡住或報 Chromium 錯誤，手動下載對應版本再解壓到 Playwright 快取目錄即可
  （`curl` 抓官方 Chromium zip → `unzip` 到 `~/Library/Caches/ms-playwright/…`）。
  gstack 其他 skill 不受影響，只有需要瀏覽器的 QA 功能會用到。

---

## ✅ 安裝後驗證

```bash
claude plugin list                 # 應看到 superpowers 與 claude-mem
ls ~/context-infrastructure        # 藍圖已 clone
ls ~/.claude/skills | grep gstack  # gstack-* skill 一整排
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:37701  # 200 = claude-mem worker 運行中
```

在 Claude Code 內：輸入 `/` 應能看到 `superpowers:` 與 `gstack-` 開頭的 skill。

---

## 📝 給接手的人

- Superpowers 與 claude-mem 是**插件**，gstack 是 **skill 套件**，三者裝完即用。
- context-infrastructure 是**你自己的**情境結構 —— 每個人都該填自己的 `USER.md`，
  不要直接複製別人的 axioms／skills 內容（那代表原作者的視角）。
- 有問題先跑「安裝後驗證」那幾行，對照哪一項沒過。
