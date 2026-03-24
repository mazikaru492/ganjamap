# GANJAMAP セットアップガイド

このガイドに従って、Supabaseデータベースをセットアップし、アプリを完全に動作させます。

---

## ステップ1: Supabaseデータベースのセットアップ

### 1.1 Supabaseダッシュボードにアクセス
https://supabase.com/dashboard にログイン

### 1.2 プロジェクトを選択
`qvhjruyhortkygaqhdrt` プロジェクトを開く

### 1.3 SQLエディターでセットアップスクリプトを実行

1. 左メニューの **SQL Editor** をクリック
2. **+ New query** をクリック
3. `supabase/setup-complete.sql` の内容を全てコピー
4. エディタにペースト
5. **Run** ボタン（または `Ctrl+Enter`）をクリック

✅ 実行成功すると:
- 8つのテーブルが作成されます
- Row Level Securityポリシーが設定されます
- 35件のサンプルショップデータが挿入されます

---

## ステップ2: Supabase認証設定の更新

### 2.1 Site URLの変更

1. Supabaseダッシュボードで **Authentication** → **URL Configuration** を開く
2. **Site URL** を以下に変更:
   ```
   https://ganjamap.vercel.app
   ```
3. **Save** をクリック

### 2.2 Redirect URLsの追加

**Redirect URLs** セクションに以下を追加:
```
https://ganjamap.vercel.app/auth/callback
https://ganjamap.vercel.app/**
```

---

## ステップ3: Google Cloud Consoleの設定確認

### 3.1 Google Maps APIキーのリファラー制限

1. [Google Cloud Console](https://console.cloud.google.com/) を開く
2. **APIs & Services** → **Credentials** を選択
3. 使用中のAPIキーをクリック
4. **Application restrictions** セクションで以下を確認:
   - **HTTP referrers (websites)** を選択
   - 許可リストに以下が含まれているか確認:
     ```
     https://ganjamap.vercel.app/*
     localhost:3000/*
     ```

### 3.2 必要なAPIの有効化

以下のAPIが有効になっているか確認:
- ✅ Maps JavaScript API
- ✅ Places API (New)
- ✅ Geocoding API

---

## ステップ4: Vercel環境変数の確認

Vercelダッシュボードで以下の環境変数が設定されているか確認:

```
NEXT_PUBLIC_SUPABASE_URL=https://qvhjruyhortkygaqhdrt.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=sb_publishable_jaZnk1422GkNs1KMdE6_3g_wKimeCgd
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=AIzaSyCwlr9gUH_5N1PcTNyDV0wRp5RM7kWGfc4
```

変更した場合は **Redeploy** が必要です。

---

## ステップ5: 動作確認

### ローカル環境での確認

```bash
npm run dev
```

http://localhost:3000 を開いて:
- ✅ マップが表示される
- ✅ ショップリストに35件が表示される
- ✅ エリアフィルター（Sukhumvit, Silom等）が動作する
- ✅ ショップをクリックするとマップにフォーカスする

### 本番環境での確認

https://ganjamap.vercel.app を開いて同様にテスト

---

## トラブルシューティング

### マップにショップが表示されない

**原因1: データベースにデータがない**
- ステップ1のSQLスクリプトを実行したか確認
- Supabaseダッシュボードの **Table Editor** → **shops** で35件のデータがあるか確認

**原因2: RLSポリシーの問題**
- `shop_images` テーブルに `shop_images are public` ポリシーが設定されているか確認
- SQL Editorで以下を実行:
  ```sql
  SELECT * FROM shops LIMIT 5;
  ```
  エラーが出る場合はRLS設定に問題あり

**原因3: Google Maps APIキーの制限**
- ブラウザのコンソールを開いて `RefererNotAllowedMapError` エラーがないか確認
- Google Cloud Consoleでリファラー制限を確認

### Googleログイン後にlocalhost:3000にリダイレクトされる

- ステップ2.1のSite URL設定を確認
- Redirect URLsに本番URLが含まれているか確認

### 店舗写真が表示されない

- RLSポリシーで `shop_images` テーブルへの公開読み取りが許可されているか確認
- SQL Editorで以下を実行:
  ```sql
  GRANT SELECT ON shop_images TO anon, authenticated;
  ```

---

## 完了！

すべてのステップが完了すると、アプリは完全に動作します:
- 📍 35件のサンプルショップがマップに表示
- 🔍 エリアフィルター・検索機能
- 🔐 Googleログイン機能
- 📱 モバイル最適化済みUI

## 次のステップ（オプション）

### 実際のショップデータを追加する場合

Google Places APIを使って実データを取得:
```bash
node scripts/scrape-shops.mjs
```

**注意**: このスクリプトは大量のAPIコールを行います（無料枠を超える可能性あり）
