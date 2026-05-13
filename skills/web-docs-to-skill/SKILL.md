---
name: web-docs-to-skill
description: Convert any web documentation site into a reusable SKILL. Use when users provide a documentation URL and want to create a skill from it. This skill crawls documentation sites, extracts all pages from navigation menus, and synthesizes the content into a well-structured SKILL with optional reference documents. Perfect for creating custom skills from GitBook, MkDocs, Docusaurus, VitePress, or any similar documentation frameworks. Triggers whenever user mentions converting docs to skill, creating skill from documentation, or importing web docs.
---

# Web Documentation to SKILL Converter

This skill transforms web documentation sites into portable SKILLs that can be installed and used in other sessions.

## Workflow

### Step 1: Analyze the Documentation Site

First, fetch the documentation site to understand its structure:

**Option A: Using browser-use** (for interactive sites requiring JavaScript):
```bash
browser-use open <url>
browser-use state
```

**Option B: Using webfetch** (for most documentation sites - recommended):
```bash
webfetch <url> --format markdown
```

1. **Identify the documentation framework** by examining:
   - URL patterns (e.g., `/docs/`, `/guide/`, `/v1/`)
   - Common navigation elements (sidebar, top nav, TOC)
   - Footer links to "Docs", "Documentation", "Guide"

2. **Detect the menu/navigation structure**:
   - Look for sidebar navigation, hamburger menus, or breadcrumbs
   - Find all section links and their hierarchy
   - Identify any collapsible/expandable menu sections

### Step 2: Extract All Page URLs

#### For Standard Documentation Sites (GitBook, MkDocs, Docusaurus, VitePress):

**Option A: Using browser-use:**
```bash
browser-use open <url>
browser-use state  # Get element indices
browser-use eval "document.querySelectorAll('nav a, .sidebar a, .menu a')"  # Extract links
```

**Option B: Using webfetch (recommended):**
```bash
webfetch <url> --format markdown  # Returns markdown with navigation links
```

Then manually identify the navigation structure from the fetched content.

#### For GitHub Wiki or Similar:

1. Use the wiki's built-in navigation (usually sidebar or bottom nav)
2. Follow "Edit" links to understand URL structure
3. Use `webfetch` tool to retrieve page content directly

#### For Single-Page Documentation:

1. Look for accordion sections or tabbed content
2. Scroll through entire page to find all sections
3. Use `browser-use scroll` commands to reveal hidden content

### Step 3: Extract Content from Each Page

For each discovered URL, extract:

1. **Title**: From `<h1>`, page title, or breadcrumb
2. **Content**: Main article/body text (remove navigation, headers, footers)
3. **Code examples**: Preserve with proper formatting
4. **Headings structure**: H1-H6 hierarchy for organization
5. **Frontmatter/metadata**: If applicable (VitePress, Docusaurus)

**Using webfetch:**
```bash
webfetch <url> --format markdown  # Gets full page as markdown
```

**Using browser-use:**
```bash
browser-use get html --selector "main"        # Get main content
browser-use get text <heading-index>          # Get specific sections
```

```bash
browser-use get html --selector "main"        # Get main content
browser-use get text <heading-index>          # Get specific sections
```

### Step 4: Synthesize into SKILL Structure

#### Decide on Structure

**Option A: Single SKILL.md** (if content is < 300 lines)
- All content in one SKILL.md
- Use clear headings and code block formatting

**Option B: SKILL.md + References** (if content is > 300 lines)
- Main SKILL.md provides overview and key patterns
- Reference docs (`references/*.md`) contain detailed content
- Use `@path` references to load additional docs as needed

#### Create SKILL.md Template

```markdown
---
name: <xxx-docs>  # Must follow xxx-docs pattern (e.g., "vue-docs", "react-docs", "tailwind-docs")
description: <2-3 sentences about what this skill does and when to use it>
---

# <Documentation Title>

## Overview
<Purpose and scope of the documentation>

## Key Concepts
<Summarized concepts with links to reference sections>

## Quick Start
<Most common/getting started patterns>

## Common Patterns
<Frequently used patterns extracted from docs>

## Reference
<Detailed reference material - or link to references/>

## Examples
<Representative code examples from the docs>
```

#### Create Reference Documents

For `references/*.md` files:
- `references/concepts.md` - Core concepts and terminology
- `references/api.md` - API references if applicable
- `references/config.md` - Configuration options
- `references/troubleshooting.md` - Common issues and solutions

### Step 5: Organize and Output

1. **Create the skill directory**:
   ```
   xxx-docs/
   ├── SKILL.md
   └── references/
       ├── concepts.md
       ├── api.md
       └── ...
   ```

2. **Save all files** using the Write tool to appropriate paths

3. **Verify the skill** by reviewing:
   - All key content is captured
   - Code examples are complete and properly formatted
   - Navigation/reference structure makes sense

## Document Framework Detection Guide

### GitBook
- URL pattern: Often has `/[book]/[page]` structure
- Navigation: Usually left sidebar with collapsible sections
- Look for: "Edit this page" link in footer

### MkDocs (Material theme)
- URL pattern: `/<section>/<page>/`
- Navigation: Left sidebar with nested sections
- Look for: `material/` in CSS classes

### Docusaurus
- URL pattern: `/docs/<version>/<section>/<page>`
- Navigation: Left sidebar with version selector
- Look for: `navbar`, `sidebar`, `doc MainDoc` classes

### VitePress
- URL pattern: `/<section>/<page>.html`
- Navigation: Left sidebar, dark/light toggle
- Look for: `.VitePress` in HTML

### GitHub Wiki
- URL pattern: `wiki/<Page-Name>`
- Navigation: Sidebar with page hierarchy
- Content: Markdown rendered to HTML

## Content Extraction Tips

1. **Remove boilerplate**: Skip navigation menus, headers, footers, ads, related links
2. **Preserve code blocks**: Keep language markers (```js, ```python, etc.)
3. **Handle tabs/modals**: Extract content from all tabs/accordion sections
4. **Respect rate limits**: Add delays between requests if scraping
5. **Handle auth if needed**: Use `browser-use connect` with user's Chrome if docs require login

## Output Convention

- Skill name: Must follow `xxx-docs` pattern, derived from documentation title (e.g., "vue-docs" from Vue.js docs, "tailwind-docs" from Tailwind CSS docs)
- Description: Pushy and specific about when to use this skill
- Directory: Created at project root as a sibling directory (e.g., `./vue-docs/`)
- References: Grouped by topic in `references/` directory

## Testing the Generated Skill

After creating the skill:
1. Attempt to use the generated skill for a relevant task
2. Verify content accuracy against original documentation
3. Check that code examples are complete and runnable
4. Ensure the description correctly describes the skill's scope
