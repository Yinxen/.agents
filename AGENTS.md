# Agent Skills 管理指南

本目录下的 skills **不要直接修改文件**，统一通过 `npx skills` 命令管理。
如果用户直接发来一个安装命令或技能，就是意味着你需要全局安装他
## 常用命令

### 安装 skill

```bash
# 全局安装（安装到 ~/.agents/skills/）
npx skills add <repo> -g -y
npx skills add <repo> --skill <name> -g -y
npx skills add <repo> --skill <name> --agent <agent> -g -y

# 示例
npx skills add vercel-labs/agent-skills -g
npx skills add anthropics/skills --skill frontend-design -g -y
```

### 查看已安装的 skill

```bash
# 查看全局 skill
npx skills ls -g

# 查看指定 agent 的 skill
npx skills ls -g -a opencode

# JSON 格式输出
npx skills ls -g --json
```

### 更新 skill

```bash
# 更新所有全局 skill
npx skills update -g

# 更新指定 skill
npx skills update <name> -g
```

### 删除 skill

```bash
# 交互式删除
npx skills remove -g

# 删除指定 skill
npx skills remove <name> -g -y

# 删除所有全局 skill
npx skills remove --all -g -y
```

### 搜索 skill

```bash
# 交互式搜索
npx skills find

# 按关键词搜索
npx skills find typescript
```

### 查看仓库中可用的 skill（不安装）

```bash
npx skills add <repo> --list
```

## 当前全局 Skills

| Skill | 来源 |
|-------|------|
| find-skills | vercel-labs/skills |
| frontend-design | anthropics/skills |
| canvas-design | anthropics/skills |
| docx | - |
| pptx | - |
| xlsx | - |
| skill-creator | - |
| ui-ux-pro-max | - |

更多 skill 可在 https://skills.sh/ 发现。
## 备份
本项可以通过git 进行管理，并推送到github进行备份
