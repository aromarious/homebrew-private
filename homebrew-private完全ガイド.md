# homebrew-private完全ガイド

このプライベートHomebrewタップでツールを配布するための包括的な手順書です。

## 目次

1. [前提条件](#前提条件)
2. [新規リポジトリを作成する場合](#新規リポジトリを作成する場合)
3. [既存リポジトリを対応させる場合](#既存リポジトリを対応させる場合)
4. [手動でツールを登録する場合](#手動でツールを登録する場合)
5. [トラブルシューティング](#トラブルシューティング)

## 前提条件

- GitHubアカウントとaromariousアカウントのPersonal Access Token
- homebrew-privateリポジトリへのアクセス権限

### Personal Access Tokenの設定

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token (classic)
3. 必要な権限: `repo` (Full control of private repositories), `workflow`

## 新規リポジトリを作成する場合

### 1. GitHubでリポジトリを作成

```bash
# GitHubでリポジトリを作成（プライベート推奨）
# https://github.com/aromarious/[tool-name]
```

### 2. ローカルでの初期設定

```bash
mkdir ~/Garage/[tool-name]
cd ~/Garage/[tool-name]
git init
git remote add origin git@github.com:aromarious/[tool-name].git
```

### 3. 必須ファイルの作成

#### 3.1 `.brew-tap`ファイル（必須）

```bash
cat > .brew-tap << 'EOF'
formula=[tool-name]
description=[ツールの説明]
homepage=https://github.com/aromarious/[tool-name]
license=[ライセンス名（MIT, ISC等）]
EOF
```

#### 3.2 GitHub Actions workflowファイル

```bash
mkdir -p .github/workflows
```

`.github/workflows/release.yml`を作成：

```yaml
name: Release

on:
  push:
    tags: ["v*"]
  workflow_dispatch:

jobs:
  create-release:
    runs-on: ubuntu-latest
    outputs:
      formula: ${{ steps.brew-tap.outputs.formula }}
      description: ${{ steps.brew-tap.outputs.description }}
      homepage: ${{ steps.brew-tap.outputs.homepage }}
      license: ${{ steps.brew-tap.outputs.license }}
    steps:
      - uses: actions/checkout@v1
      
      - name: Create CHANGELOG for release
        run: |
          echo "## Changes in ${{ github.ref_name }}" > latest-release.md
          echo "[リリース内容の説明]" >> latest-release.md
      
      - name: Create Release
        uses: softprops/action-gh-release@v1
        with:
          token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          body_path: ./latest-release.md
          draft: false
          prerelease: false
      
      - name: Get Brew Tap Parameters
        id: brew-tap
        run: cat ./.brew-tap >> $GITHUB_OUTPUT

  update-homebrew:
    needs: [create-release]
    runs-on: ubuntu-latest
    steps:
      - name: Set Archive URL
        id: archive
        run: |
          echo "archive_url=https://github.com/${{ github.repository }}/archive/refs/tags/${{ github.ref_name }}.tar.gz" >> $GITHUB_OUTPUT
      
      - name: Calculate SHA256
        id: sha256
        run: |
          curl -L -s "https://github.com/${{ github.repository }}/archive/refs/tags/${{ github.ref_name }}.tar.gz" -o release.tar.gz
          echo "sha256=$(sha256sum release.tar.gz | awk '{ print $1 }')" >> $GITHUB_OUTPUT
      
      - name: Get Version
        id: version
        run: |
          VERSION=$(echo ${{ github.ref }} | sed -e "s#refs/tags/##g")
          echo "version=$VERSION" >> $GITHUB_OUTPUT
      
      - name: Emit repository-dispatch event to Homebrew tap repository
        uses: peter-evans/repository-dispatch@v1
        with:
          token: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
          repository: aromarious/homebrew-private
          event-type: update-brew
          client-payload: >
            {
              "formula": "${{ needs.create-release.outputs.formula }}",
              "description": "${{ needs.create-release.outputs.description }}",
              "homepage": "${{ needs.create-release.outputs.homepage }}",
              "url": "${{ steps.archive.outputs.archive_url }}",
              "sha256": "${{ steps.sha256.outputs.sha256 }}",
              "version": "${{ steps.version.outputs.version }}",
              "license": "${{ needs.create-release.outputs.license }}"
            }
```

#### 3.3 READMEファイル

```bash
cat > README.md << 'EOF'
# [tool-name]

[ツールの説明]

## インストール

```bash
brew install aromarious/private/[tool-name]
```

## 使用方法

[使用方法の説明]
EOF
```

### 4. プロジェクト固有のファイル作成

#### Node.jsプロジェクトの場合

```bash
cat > package.json << 'EOF'
{
  "name": "[tool-name]",
  "version": "1.0.0",
  "description": "[ツールの説明]",
  "main": "index.js",
  "bin": {
    "[tool-name]": "bin/[tool-name]"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/aromarious/[tool-name]"
  },
  "license": "[ライセンス名]"
}
EOF

mkdir -p bin
```

#### Bashスクリプトの場合

```bash
touch [tool-name]
chmod +x [tool-name]
```

### 5. homebrew-privateでのテンプレート作成

`~/Garage/homebrew-private/templates/[tool-name].rb.tmpl`を作成：

```ruby
class [ToolNameCapitalized] < Formula
  desc "{{ description }}"
  homepage "{{ homepage }}"
  url "{{ url }}"
  sha256 "{{ sha256 }}"
  version "{{ version }}"
  license "{{ license }}"

  # 依存関係（必要に応じて）
  depends_on "node"  # Node.jsプロジェクトの場合

  def install
    ohai "Installing {{ formula }}..."
    
    # Node.jsプロジェクトの場合
    system "npm", "install"
    system "npm", "run", "build"  # ビルドが必要な場合
    libexec.install "package.json", "package-lock.json", "bin", "dist"
    bin.install_symlink libexec/"bin/{{ formula }}"
    
    # Bashスクリプトの場合
    # bin.install "[tool-name]"
  end

  test do
    system "#{bin}/{{ formula }}", "--version"
    # 追加のテストケース
  end
end
```

### 6. GitHub Secretsの設定

ツールリポジトリ（aromarious/[tool-name]）で：

1. Settings → Secrets and variables → Actions
2. New repository secret
3. Name: `PERSONAL_ACCESS_TOKEN`
4. Secret: aromariousアカウントのPersonal Access Token

### 7. 初回リリース

```bash
# コミットとプッシュ
git add .
git commit -m "Initial commit"
git push -u origin main

# リリースタグの作成
git tag v1.0.0
git push origin v1.0.0
```

## 既存リポジトリを対応させる場合

既存のリポジトリをhomebrew-private対応にする場合：

### 1. 必須ファイルを追加

上記の「新規リポジトリを作成する場合」の3.1〜3.2を実行

### 2. GitHub Secretsの設定

上記の6を実行

### 3. homebrew-privateでのテンプレート作成

上記の5を実行

### 4. リリースタグの作成

```bash
git tag v1.0.0
git push origin v1.0.0
```

## 手動でツールを登録する場合

自動化を使わずに手動でFormulaを作成する場合：

### 1. 必要な情報を準備

- `formula`: ツール名
- `description`: ツールの説明
- `homepage`: GitHubリポジトリのURL
- `url`: リリースのtarballのURL
- `sha256`: tarballのSHA256ハッシュ
- `version`: バージョン
- `license`: ライセンス

### 2. テンプレートファイルの作成

```bash
cd ~/Garage/homebrew-private
cp templates/display-rotate.rb.tmpl templates/[ツール名].rb.tmpl
```

テンプレートファイルを編集してツール固有の設定を調整

### 3. Formulaの生成

```bash
node scripts/update.js [ツール名] "[説明]" "[homepage]" "[url]" "[sha256]" "[version]" "[license]"
```

### 4. SHA256ハッシュの取得方法

```bash
curl -sL [tarball URL] | shasum -a 256
```

### 5. 例

```bash
node scripts/update.js display-rotate "Rotate your display easily on macOS CLI using displayplacer." "https://github.com/aromarious/display-rotate" "https://github.com/aromarious/display-rotate/archive/refs/tags/v1.1.0.tar.gz" "b2b596b127be2eb7d4a36034941758e379ab33ce2b03f2a76f3ce533e88f1017" "v1.1.0" "ISC"
```

## 自動化フローの全体像

1. **ツールリポジトリでタグ作成** → `release.yml`実行
2. **GitHubリリース作成** → アーカイブURL生成
3. **SHA256計算** → repository-dispatch送信
4. **homebrew-private** → `update-brew.yml`実行
5. **Formulaファイル生成** → 自動PR作成
6. **PRマージ** → Formula公開完了

## トラブルシューティング

### workflowが実行されない場合

- `PERSONAL_ACCESS_TOKEN`の権限確認（repoスコープ必須）
- `.brew-tap`ファイルの形式確認
- リポジトリのSecretsにPATが正しく設定されているか確認

### Formulaインストールが失敗する場合

- テンプレートの`install`メソッド確認
- 依存関係（`depends_on`）の確認
- ファイルパスの確認
- テストコマンドが正しく動作するか確認

### PRが自動作成されない場合

- repository-dispatchイベントの送信確認
- homebrew-privateの`update-brew.yml`ログ確認
- PATの権限がhomebrew-privateリポジトリに及んでいるか確認

### SHA256ハッシュが合わない場合

- アーカイブURLが正しいかチェック
- タグが正しくプッシュされているか確認
- リリースが正常に作成されているか確認

## 注意点

- `.brew-tap`ファイルの情報は正確に記入すること
- Formulaテンプレートでのクラス名は大文字開始のキャメルケースにすること
- テストコマンドは確実に動作するものを記載すること
- 依存関係は必要最小限に留めること
- すべての情報が正確であることを確認してからリリースすること