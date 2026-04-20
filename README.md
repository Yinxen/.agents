# Global Agent Skills

全局安装的 AI Agent Skills，通过以下命令安装：

```bash
skill add <repo> --skill <name> -g -y
```

## 已安装的 Skills

| Skill | 来源 | 描述 |
|-------|------|------|
| [find-skills](#find-skills) | vercel-labs/skills | 帮助发现和安装新 skill |
| [frontend-design](#frontend-design) | anthropics/skills | 生成高质量前端界面代码 |
| [canvas-design](#canvas-design) | anthropics/skills | 创建海报、艺术设计等视觉作品 |
| [docx](#docx) | - | 创建和编辑 Word 文档 |
| [pptx](#pptx) | - | 创建和编辑 PowerPoint 演示文稿 |
| [xlsx](#xlsx) | - | 创建和编辑 Excel 电子表格 |
| [skill-creator](#skill-creator) | - | 创建、修改和测试 skill |
| [ui-ux-pro-max](#ui-ux-pro-max) | - | Web/移动端 UI/UX 设计 |

---

### find-skills

帮助用户发现和安装 agent skills。当用户询问"如何做 X"、"有没有能做 X 的 skill"时触发。

```bash
skill add vercel-labs/skills --skill find-skills -g -y
```

---

### frontend-design

创建高质量、生产级的前端界面。适用于网站、落地页、Dashboard、React 组件、HTML/CSS 布局等。

```bash
skill add anthropics/skills --skill frontend-design -g -y
```

---

### canvas-design

使用设计理念创建精美的视觉作品，输出 `.png` 和 `.pdf` 文件。适用于海报、艺术设计等静态视觉内容。

```bash
skill add anthropics/skills --skill canvas-design -g -y
```

---

### docx

处理 Word 文档（`.docx`）的创建、读取、编辑。支持目录、标题、页码、信头等专业格式。

---

### pptx

处理 PowerPoint 文件（`.pptx`）的创建、读取、编辑。适用于幻灯片、演示文稿、Pitch Deck 等。

---

### xlsx

处理电子表格文件（`.xlsx`、`.csv` 等）的创建、读取、编辑。适用于数据清洗、公式计算、图表生成等。

---

### skill-creator

创建新 skill、修改现有 skill、运行 eval 测试 skill 性能。

---

### ui-ux-pro-max

Web 和移动端 UI/UX 设计智能助手。包含 50+ 风格、161 色板、57 字体搭配，支持 React、Next.js、Vue、Svelte、SwiftUI、React Native、Flutter、Tailwind、shadcn/ui、HTML/CSS 等 10 种技术栈。

---

## 目录结构

```
~/.agents/
├── .skill-lock.json    # skill 安装记录
├── README.md           # 本文件
└── skills/
    ├── canvas-design/
    ├── docx/
    ├── find-skills/
    ├── frontend-design/
    ├── pptx/
    ├── skill-creator/
    ├── ui-ux-pro-max/
    └── xlsx/
```
