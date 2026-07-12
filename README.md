# hyoshida123.github.io

Personal website built with [Astro](https://astro.build/).

Live at https://hyoshida123.github.io/

## Development

```bash
npm install
npm run dev
```

## Build

```bash
npm run build
npm run preview
```

## Deploy

Pushing to `master` triggers the GitHub Actions workflow
(`.github/workflows/deploy.yml`), which builds the site and deploys it to
GitHub Pages.

## Writing a post

Add a Markdown file to `src/content/blog/`:

```markdown
---
title: 記事タイトル
date: 2026-07-12
lang: ja # or en
description: 一覧やOGPに使われる説明文（任意）
---

本文
```

The filename becomes the URL: `foo.md` → `/blog/foo/`.
