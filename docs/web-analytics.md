# Web Analytics / 計測ツールについて

このサイトに導入している計測・SEO関連ツールのまとめ。
スニペットはすべて `src/layouts/Base.astro` の `<head>` 内にあり、全ページに配信される。

## GoatCounter（アクセス解析）

- **役割**: ページビューの計測。Cookieなし・個人情報なしの軽量プライバシー重視型
- **ダッシュボード**: https://hyoshida123.goatcounter.com
- **スニペット**:
  ```html
  <script data-goatcounter="https://hyoshida123.goatcounter.com/count"
          async src="https://gc.zgo.at/count.js"></script>
  ```
- **備考**: 無料プラン。Cookieを使わないため同意バナーは不要。
  計測をやめたい場合はこのscriptタグを削除するだけ。

## Ahrefs Web Analytics（アクセス解析 + サイト所有権確認）

- **役割**: アクセス解析（こちらもCookieなし）。
  Ahrefs Webmaster Tools のサイト所有権確認も兼ねている
- **ダッシュボード**: https://ahrefs.com/ （Webmaster Tools にログイン）
- **スニペット**:
  ```html
  <script src="https://analytics.ahrefs.com/analytics.js"
          data-key="rHZRdnbDe96toffwY19gaA" async></script>
  ```
- **備考**: `data-key` は所有権確認に使われているため、
  **このタグを削除すると Ahrefs の Site Audit 等が使えなくなる**。
  削除する場合は先に別の確認方法（DNSレコード等）へ切り替えること。

## Ahrefs Site Audit（SEO診断）

- **役割**: サイトを定期クロールして、リンク切れ・メタ情報の不備・
  パフォーマンス問題などをレポートする
- **場所**: Ahrefs Webmaster Tools 内の Site Audit
- **備考**: 上記 Web Analytics による所有権確認が前提。
  クロール対象は `robots.txt` と `sitemap-index.xml` を参照する。

## Google Search Console（検索パフォーマンス）

- **役割**: Google検索でのインデックス状況・表示回数・検索クエリの確認、
  サイトマップの送信
- **ダッシュボード**: https://search.google.com/search-console
- **確認タグ**（解析スクリプトではなく所有権確認用のmetaタグ）:
  ```html
  <meta name="google-site-verification" content="ABM1-Drq7hiGw833m7Q9YfonfmRsmb0RirhGD3goQ8c" />
  ```
- **サイトマップ**: `https://hyoshida123.github.io/sitemap-index.xml` を送信済み
  （Astroの `@astrojs/sitemap` がビルド時に自動生成）
- **備考**: このmetaタグを削除すると所有権確認が外れるので消さないこと。

## 過去に使っていたもの

- **Google Analytics (Universal Analytics, `UA-122255220-1`)**:
  旧Jekyllサイトに設置されていたが、UA自体が2023年にサービス終了して
  計測されない状態だったため、2026年7月のAstro移行時に撤去した。
