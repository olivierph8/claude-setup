# Claude Code 環境安裝包

> 整理日期：2026-07-05 · by Dan
> 一鍵重現這台機器上安裝的 Claude Code 插件與工具組。

## 🚀 快速安裝

```bash
# 下載這個資料夾後，執行：
bash install.sh

# 若也要裝 gstack：
bash install.sh --with-gstack
```

**前置需求**：Claude Code（含 `claude` CLI）、Node.js ≥ 20、git。

安裝完 **重啟 Claude Code** 讓插件生效。

---

## 📦 內容清單

| # | 名稱 | 類型 | 一句話 | 安裝方式 |
|---|------|------|--------|----------|
| 1 | **Superpowers** | Claude Code 插件 | 一套開發用 skill（TDD、除錯、寫計畫、平行 subagent…） | `claude plugin install superpowers@claude-plugins-official` |
| 2 | **claude-mem** | Claude Code 插件 | 自動捕捉每次 session、壓縮成記憶、下次自動注入 | `npx claude-mem install` |
| 3 | **context-infrastructure** | 藍圖（clone 後設定） | 讓 AI 長期記住你是誰的情境結構範本 | `git clone …/grapeot/context-infrastructure` |
| + | **gstack**（選用） | Skill 套件 | 大型 skill 工具組（QA、設計審查、部署…） | 見官方 repo，需手動步驟 |

---

## 🔍 各項目說明

### 1. Superpowers
- **來源**：https://github.com/obra/superpowers
- **裝完有什麼**：`superpowers:*` 一系列 skill，例如
  `brainstorming`、`test-driven-development`、`systematic-debugging`、
  `writing-plans` / `executing-plans`、`writing-skills`、`using-git-worktrees` 等。
- **開箱即用**：✅ 裝完即可在 Claude Code 內叫用。

### 2. claude-mem（記憶系統）
- **來源**：https://github.com/thedotmack/claude-mem
- **做什麼**：被動記錄你在每個專案做的事，下次打開自動把相關 context 帶回來。
- **注意事項**：
  - 記憶注入從**第二次** session 才開始。
  - 資料全部留在本機 `~/.claude-mem`。
  - 背景 worker：`npx claude-mem start`，介面 http://localhost:37701
  - 剛裝好若看到 `failed to load: cache-miss`，**重啟 Claude Code 即恢復**。
  - 常用指令：`/how-it-works`、`/learn-codebase`（把整個 repo 吃進記憶）。

### 3. context-infrastructure（藍圖，非開箱即用）
- **來源**：https://github.com/grapeot/context-infrastructure
- **重點**：這是**範本**，不是成品。clone 只是第一步。
  - ✅ **必做**：填寫 `rules/USER.md`（你的稱呼、時區、背景、偏好）—— CP 值最高。
  - ⚠️ 記憶引擎（`observer.py` / `reflector.py`）**無法開箱即用**：
    repo 沒附 `opencode_client.py`，需自行接 Claude／OpenAI API + 設 cron。
  - 原本為 OpenCode 設計，部分 subagent 語法用於 Claude Code 需調整。

### + gstack（選用，安裝較繁複）
- **來源**：https://github.com/garrytan/gstack
- **注意**：setup 會下載 Chromium，某些環境需手動 `curl` + `unzip` 繞過。
- skill 以 `gstack-` 前綴載入（例如 `gstack-qa`、`gstack-ship`、`gstack-design-review`）。

---

## ✅ 安裝後驗證

```bash
claude plugin list          # 應看到 superpowers 與 claude-mem
ls ~/context-infrastructure # 藍圖已 clone
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:37701  # 200 = claude-mem worker 運行中
```

在 Claude Code 內：輸入 `/` 應能看到 `superpowers:` 開頭的 skill。

---

## 📝 給接手的人

- Superpowers 與 claude-mem 是**插件**，裝完即用。
- context-infrastructure 是**你自己的**情境結構 —— 每個人都該填自己的 `USER.md`，
  不要直接複製別人的 axioms／skills 內容（那代表原作者的視角）。
- 有問題先跑「安裝後驗證」那三行,對照哪一項沒過。
