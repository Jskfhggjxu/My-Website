# 🚀 Tory Script Hub

Tory 的 Roblox 脚本站 —— 纯静态、数据驱动、GitHub Actions 自动部署到 GitHub Pages。
零后端、零服务器费用，改一个 JSON 就能发新脚本。

---

## 📁 目录结构

```
ToryScriptHub/
├── index.html                 # 首页（Hero + 精选脚本 + Discord CTA）
├── scripts.html               # 脚本库页（分类筛选 + 搜索）
├── .nojekyll                  # 让 GitHub Pages 跳过 Jekyll 处理
├── assets/
│   ├── css/style.css          # 全部样式
│   └── js/main.js             # 数据渲染 / 筛选 / 搜索 / 复制链接
├── data/
│   └── scripts.json           # ⭐ 脚本数据（新增脚本改这里）
└── .github/workflows/
    └── deploy.yml             # GitHub Actions 部署工作流
```

---

## 🚀 部署到 GitHub Pages（5 分钟）

1. **建仓库**：在 GitHub 新建一个仓库（建议名 `tory-script-hub` 或直接用你的用户名仓库 `<username>.github.io`）。
2. **推送代码**：
   ```bash
   git init
   git add .
   git commit -m "init: Tory Script Hub"
   git branch -M main
   git remote add origin https://github.com/<你的用户名>/<仓库名>.git
   git push -u origin main
   ```
3. **开启 Pages + Actions**：
   - 进入仓库 **Settings → Pages**
   - "Build and deployment" 的 **Source** 选择 **GitHub Actions**（不是 Deploy from a branch！）
4. **等 1~2 分钟**：push 后工作流 `Deploy to GitHub Pages` 会自动运行。跑完后 Settings → Pages 页面顶部会显示你的网址：
   - 仓库是 `<用户名>.github.io` → 网址就是 `https://<用户名>.github.io/`
   - 普通仓库 → `https://<用户名>.github.io/<仓库名>/`

> 以后每次 `git push`，网站都会自动重新部署，无需任何操作。

---

## ✍️ 新增 / 修改脚本（核心操作）

打开 `data/scripts.json`，在 `"scripts"` 数组里复制一个对象改成你的：

```jsonc
{
  "id": "my-script",                          // 唯一 ID，英文
  "title": "My Script",                       // 显示名称
  "description": "一行话说明这个脚本干嘛的",    // 描述
  "category": "Utility",                      // 分类（决定筛选按钮）
  "tags": ["tag1", "tag2"],                   // 标签，可搜索
  "version": "1.0.0",                         // 版本号
  "updated": "2026-08-17",                    // 更新日期 YYYY-MM-DD
  "download": "https://raw.githubusercontent.com/.../my-script.lua",  // ⭐ 下载/复制链接
  "size": "2.1 KB",                           // 文件大小（展示用）
  "featured": true                            // true = 显示在首页精选
}
```

几个要点：

- **下载链接**推荐用 GitHub 仓库里的 `raw` 链接（右上角点 Raw 复制），或者你 Discord 里的附件直链 / Pastebin。
- 分类是自动生成的：把 `category` 换成新值，筛选栏会自动多出对应按钮。
- 想把 `.lua` 源文件也放进仓库？在仓库根目录建 `scripts/` 文件夹，把文件丢进去，链接写 `https://raw.githubusercontent.com/<用户名>/<仓库名>/main/scripts/xxx.lua`。

---

## 💻 本地预览

直接用浏览器打开 `index.html` 不行（fetch 本地 JSON 会被 CORS 拦），要用本地服务器：

```bash
cd ToryScriptHub
python3 -m http.server 8000
# 打开 http://localhost:8000
```

---

## 🎨 想改样式 / 文案？

- **配色**：`assets/css/style.css` 顶部的 `:root` 变量（`--accent` 是主色，现在是 Roblox 红）。
- **首页文案**：直接改 `index.html`。
- **简介 / Discord 链接**：改 `data/scripts.json` 里的 `owner` 字段，全站自动同步。

---

## ❓ 常见问题

- **Deploy 报错？** 确认 Settings → Pages 的 Source 是 **GitHub Actions**，且默认分支是 `main`。
- **改了 JSON 网站没变？** Actions 跑完 + 浏览器强刷（Ctrl+Shift+R）。
- **想绑定自定义域名？** Settings → Pages → Custom domain，然后在仓库根目录加 `CNAME` 文件。

---

© Tory · Built with ❤️ & Lua
