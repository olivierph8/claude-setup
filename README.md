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

## 📦 內容清單（一句話版）

| # | 名稱 | 類型 | 一句話 | 來源 |
|---|------|------|--------|------|
| 1 | **Superpowers** | 插件 | 一套「怎麼做好開發」的工作流 skill（先計畫、先測試、系統化除錯…） | https://github.com/obra/superpowers |
| 2 | **claude-mem** | 插件 | 自動記憶 + 一堆生產力 skill（規劃、讀懂專案、產報告、做投影片…） | https://github.com/thedotmack/claude-mem |
| 3 | **context-infrastructure** | 藍圖 | 讓 AI 長期記住你是誰的情境結構範本 | https://github.com/grapeot/context-infrastructure |
| 4 | **gstack** | Skill 套件（56+） | 一條龍開發流程 skill：規劃 → QA → 審查 → 上線 → 文件 | https://github.com/garrytan/gstack |

---

## 🔍 各項目能做什麼（詳細版）

### 1. Superpowers — 「開發方法論」skill 包
在 Claude Code 內以 `superpowers:` 前綴叫用。核心是**強迫養成好習慣**：動手前先想、寫程式先寫測試、遇 bug 先系統化查。

| Skill | 能做什麼 |
|-------|----------|
| `brainstorming` | 動手前先釐清需求與設計，避免做錯方向 |
| `writing-plans` / `executing-plans` | 把大任務拆成有審查點的計畫，再分段執行 |
| `test-driven-development` | 先寫測試、再寫實作（TDD） |
| `systematic-debugging` | 遇到 bug 用系統化流程找根因，而不是亂猜 |
| `requesting-code-review` / `receiving-code-review` | 完成後請 AI 審查、以及如何正確消化審查意見 |
| `verification-before-completion` | 宣稱「做完了」前，先跑驗證拿出證據 |
| `dispatching-parallel-agents` / `subagent-driven-development` | 把獨立工作平行派給多個子代理，加速 |
| `using-git-worktrees` | 用 git worktree 隔離工作區，不污染主線 |
| `finishing-a-development-branch` | 收尾分支：合併 / 開 PR / 清理的決策 |
| `writing-skills` | 教你打造自己的 skill |

**開箱即用**：✅

### 2. claude-mem — 自動記憶 + 生產力 skill 包
除了背景自動記憶，還附一整組 `claude-mem:` 前綴的 skill：

| Skill | 能做什麼 |
|-------|----------|
| `mem-search` | 搜尋跨 session 的記憶：「上次那個問題怎麼解的？」 |
| `learn-codebase` | 一次讀完整個專案原始碼，讓 AI 快速上手 |
| `make-plan` / `do` | 產生分階段實作計畫，並用子代理執行 |
| `smart-explore` | 用 AST 結構搜尋程式碼，比逐檔讀更省 token |
| `pathfinder` | 畫出程式架構地圖、找出重複系統、提出統一方案 |
| `design-is` | 用 Dieter Rams 十大設計原則審查 UI 設計 |
| `oh-my-issues` | 把一堆雜亂的 GitHub issue 依「根本原因」分群整理 |
| `babysit` | 盯著一個 PR / 審查循環，直到可以合併 |
| `standup` | 跨分支 / worktree 做「每日站會」比對進度 |
| `timeline-report` / `weekly-digests` | 把專案開發史寫成敘事報告（整體 / 逐週） |
| `what-the` | 把技術內容用白話拆解成「誰、什麼、為什麼」 |
| `wowerpoint` | 把一份文件變成可分享的投影片 PDF |
| `version-bump` | 自動化版本號 + 發 release |
| `knowledge-agent` | 從記憶累積建一個可問答的「知識腦」 |

**注意事項**：
- 記憶注入從**第二次** session 才開始；資料全部留在本機 `~/.claude-mem`。
- 背景 worker：`npx claude-mem start`，介面 http://localhost:37701
- 剛裝好若看到 `failed to load: cache-miss`，**重啟 Claude Code 即恢復**。

### 3. context-infrastructure — 情境結構藍圖（非開箱即用）
不是 skill 包，是一套**目錄結構範本**，教你如何讓 AI 長期記住你。

- ✅ **必做**：填寫 `rules/USER.md`（稱呼、時區、背景、偏好）—— CP 值最高，填完 AI 立刻更懂你。
- `rules/skills/`：25+ 個 starter skill 範例（深度調研流程、平行子代理、認知畫像萃取…），供**參考格式**用。
- `rules/axioms/`：43 條決策原則（代表原作者視角，參考用，別直接複製）。
- ⚠️ 記憶引擎（`observer.py` / `reflector.py`）**無法開箱即用**：repo 沒附 `opencode_client.py`，需自行接 Claude／OpenAI API + 設 cron。

### 4. gstack — 一條龍開發流程 skill（56+）
以 `gstack-` 前綴載入，覆蓋一個專案從頭到尾的每個階段：

| 階段 | 代表 skill | 能做什麼 |
|------|-----------|----------|
| **規劃** | `gstack-spec`、`gstack-plan-ceo-review`、`gstack-plan-eng-review`、`gstack-plan-design-review` | 把模糊想法變精確規格；用 CEO／工程／設計等不同視角審查計畫 |
| **QA 測試** | `gstack-qa`、`gstack-qa-only`、`gstack-browse` | 系統化測試網站並修 bug；無頭瀏覽器實測 |
| **審查** | `gstack-review`、`gstack-health`、`gstack-devex-review` | 上線前 PR 審查；程式碼品質儀表板；開發體驗稽核 |
| **設計** | `gstack-design-consultation`、`gstack-design-review`、`gstack-design-shotgun`、`gstack-design-html` | 產出設計系統；設計師之眼挑毛病；多變體比較；產 production HTML/CSS |
| **上線** | `gstack-ship`、`gstack-land-and-deploy` | 跑測試、改 CHANGELOG、開 PR、合併、部署一條龍 |
| **除錯** | `gstack-investigate`、`gstack-ios-fix` | 系統化根因調查；iOS 自動修 bug |
| **文件** | `gstack-document-generate`、`gstack-make-pdf`、`gstack-diagram` | 從零產生文件；markdown 轉出版級 PDF；英文描述轉圖表 |
| **安全** | `gstack-cso` | Chief Security Officer 模式做安全審查 |
| **iOS** | `gstack-ios-qa`、`gstack-ios-design-review` | 真機 iOS QA 與設計稽核 |

- **⚠️ gstack Chromium 繞過**：`./setup` 會下載 Chromium 供瀏覽器 QA 用，某些環境會**卡在下載**。
  若卡住或報 Chromium 錯誤，手動下載對應版本再解壓到 Playwright 快取
  （`curl` 抓官方 Chromium zip → `unzip` 到 `~/Library/Caches/ms-playwright/…`）。
  只有需要瀏覽器的 QA 功能會用到，其他 skill 不受影響。

---

## ✅ 安裝後驗證

```bash
claude plugin list                 # 應看到 superpowers 與 claude-mem
ls ~/context-infrastructure        # 藍圖已 clone
ls ~/.claude/skills | grep gstack  # gstack-* skill 一整排
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:37701  # 200 = claude-mem worker 運行中
```

在 Claude Code 內：輸入 `/` 應能看到 `superpowers:`、`claude-mem:`、`gstack-` 開頭的 skill。

---

## 📝 給接手的人

- Superpowers、claude-mem、gstack 三者裝完即用（skill 直接叫用）。
- context-infrastructure 是**你自己的**情境結構 —— 每個人都該填自己的 `USER.md`，
  不要直接複製別人的 axioms／skills 內容（那代表原作者的視角）。
- 有問題先跑「安裝後驗證」那幾行，對照哪一項沒過。
