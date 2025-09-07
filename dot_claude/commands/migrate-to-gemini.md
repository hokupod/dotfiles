---
description: Claude CodeのコマンドをGemini CLI用のTOMLスラッシュコマンドに変換するための汎用ガイド
argument-hint: all | [コマンド名1] [コマンド名2]... | カテゴリ名/
---

# Claude Code → Gemini CLI コマンド移行ガイド: $ARGUMENTS

## 概要

Claude CodeのMarkdownコマンドをGemini CLIのTOMLコマンドに変換するための**汎用的な変換ガイド**です。機械的な自動変換ではなく、**厳密な変換ルール**に従った手動変換を推奨します。

## 実行モード

引数に応じて異なる移行を実行します：

### `all` - 全コマンド移行
```
/migrate-to-gemini all
```
~/.claude/commands/ 内の全ての.mdファイルを対象に移行を実行

### 個別コマンド移行
```
/migrate-to-gemini daily-note git-commit
```
指定したコマンド名のファイルのみを移行

### カテゴリ別移行
```
/migrate-to-gemini git/
```
特定のカテゴリに分類されるべきコマンドのみを移行（末尾の/で判別）

### 引数なし - インタラクティブモード
```
/migrate-to-gemini
```
対話的にコマンドを選択して移行

---

## 移行対象の決定

引数の内容: **$ARGUMENTS**

**移行対象コマンド**:
- `all` が指定された場合: ~/.claude/commands/*.md の全ファイル
- 個別コマンドが指定された場合: 指定されたコマンドのみ（拡張子.mdは自動付与）
- カテゴリが指定された場合（末尾に/）: そのカテゴリに適したコマンドを自動判別
- 引数なしの場合: 利用可能なコマンド一覧を表示し、ユーザーに選択を促す

まず既存のコマンド一覧を確認します：

```bash
find ~/.claude/commands -name "*.md" -exec basename {} .md \;
```

## 変換の前提条件

### Gemini CLI仕様の制約
- **使用可能フィールド**: `description`と`prompt`のみ
- **ファイル形式**: `.toml`ファイル
- **引数**: `{{args}}`プレースホルダー
- **SHELL実行**: `!{コマンド}`構文

### 変換対象外の要素
- `shortcut`、`allowed-tools`等のClaude Code固有フィールド
- `argument-hint`は`description`に統合
- 複雑なBashスクリプト（手動調整が必要）

## 厳密な変換ルール

### 1. ファイル構造の変換

#### Claude Code形式（入力）
```markdown
---
description: "コマンドの説明"
shortcut: "sc"              # ← 削除
argument-hint: "引数ヒント" # ← descriptionに統合
allowed-tools: [...]        # ← 削除
---

# コマンドタイトル: $ARGUMENTS

コマンドの内容...
```

#### Gemini CLI形式（出力）
```toml
# Claude Code → Gemini CLI 移行
# 元ファイル: ~/.claude/commands/元ファイル名.md

description = "コマンドの説明 - 引数: 引数ヒント"

prompt = """
# コマンドタイトル: {{args}}

コマンドの内容...
"""
```

### 2. プレースホルダー変換ルール

| Claude Code | Gemini CLI | 備考 |
|-------------|------------|------|
| `$ARGUMENTS` | `{{args}}` | 必須変換 |
| `$ARGUMENTS`を含む条件文 | `{{args}}`を含む条件文 | 条件ロジックも更新 |
| `引数なしの場合は$ARGUMENTS` | `引数なしの場合は{{args}}` | 文中の参照も更新 |

### 3. SHELL実行の変換ルール

#### 基本パターン
| 変換前（Claude Code） | 変換後（Gemini CLI） | 用途 |
|----------------------|----------------------|------|
| ```bash<br/>コマンド<br/>``` | `!{コマンド}` | 基本的なコマンド実行 |
| `$(コマンド)` | `!{コマンド}` | コマンド置換 |

#### 日付・時刻処理
| 変換前 | 変換後 | 説明 |
|--------|--------|------|
| `TODAY=$(date +%Y-%m-%d)` | `!{TODAY=$(date +%Y-%m-%d); echo $TODAY}` | 日付取得と表示 |
| `$(perl -MPOSIX -le '...')` | `!{date +適切な形式}` | Perl日付処理をdateコマンドに |

#### Git情報取得
```bash
# 変換前
```bash
git status --porcelain
git diff --stat
```

# 変換後
!{echo "=== Git Status ==="}
!{git status --porcelain}
!{echo "=== Changes ==="}
!{git diff --stat}
```

### 4. ディレクトリ構造の設計

#### 推奨される分類方法
```
~/.gemini/commands/
├── git/              # Git関連コマンド
├── file/             # ファイル操作コマンド
├── analysis/         # 分析・調査コマンド
├── dev/              # 開発支援コマンド
├── note/             # ノート・ドキュメント管理
├── ai/               # AI作業支援コマンド
├── web/              # Web関連コマンド
└── utils/            # その他ユーティリティ
```

#### 分類基準
| カテゴリ | 判断基準 | 例 |
|----------|----------|-----|
| `git/` | Git操作・解析 | コミット、ブランチ、履歴分析 |
| `file/` | ファイル・フォルダ操作 | 検索、変換、整理 |
| `analysis/` | 調査・分析手法 | Five Whys、原因分析 |
| `dev/` | 開発支援 | ビルド、テスト、デプロイ |
| `note/` | ノート・文書管理 | 日報、メモ、知識管理 |
| `web/` | Web・ネットワーク | 検索、API呼び出し |

## 環境設定

### ステップ 1: ディレクトリ構造の準備

```bash
# 基本ディレクトリの作成（必要に応じて調整）
mkdir -p ~/.gemini/commands/{git,file,analysis,dev,note,ai,web,utils}

# または、独自の分類を使用
# mkdir -p ~/.gemini/commands/{your-category1,your-category2}
```

### ステップ 2: 変換設定の定義

#### 自分の環境に合わせて設定
```bash
# 変数定義（例）
CLAUDE_COMMANDS_DIR="~/.claude/commands"
GEMINI_COMMANDS_DIR="~/.gemini/commands"

# 自分のコマンド一覧を確認
ls $CLAUDE_COMMANDS_DIR/*.md
```

## 実際の変換手順

### ステップ 1: コマンドの分析と分類

#### 1-1. 既存コマンドの一覧化
```bash
# 自分の環境のコマンドを確認
find ~/.claude/commands -name "*.md" -exec basename {} .md \;
```

#### 1-2. コマンドの分類決定
各コマンドの機能を分析し、適切なカテゴリを決定：

```bash
# 各コマンドの内容確認
for file in ~/.claude/commands/*.md; do
    echo "=== $(basename $file) ==="
    head -10 "$file"
    echo ""
done
```

### ステップ 2: フロントマター情報の抽出

#### 2-1. 自動抽出スクリプト例
```bash
#!/bin/bash
extract_frontmatter() {
    local file="$1"
    local field="$2"
    sed -n '/^---$/,/^---$/p' "$file" | \
        grep "^${field}:" | \
        sed "s/^${field}:[[:space:]]*//" | \
        sed 's/^"//' | sed 's/"$//'
}

# 使用例
COMMAND_FILE="~/.claude/commands/your-command.md"
DESCRIPTION=$(extract_frontmatter "$COMMAND_FILE" "description")
ARGUMENT_HINT=$(extract_frontmatter "$COMMAND_FILE" "argument-hint")
```

#### 2-2. description構築
```bash
# argument-hintがある場合
if [ -n "$ARGUMENT_HINT" ]; then
    FINAL_DESCRIPTION="$DESCRIPTION - 引数: $ARGUMENT_HINT"
else
    FINAL_DESCRIPTION="$DESCRIPTION"
fi
```

### ステップ 3: 本文の変換

#### 3-1. 基本的な置換
```bash
# プレースホルダー変換
sed 's/\$ARGUMENTS/{{args}}/g' 

# Perl日付処理の変換例
sed 's/TODAY=\$(perl -MPOSIX[^)]*))/TODAY=\$(date +%Y-%m-%d)/g'
```

#### 3-2. SHELL実行への変換
```bash
# bashブロックをSHELL実行に変換
# 手動変換が推奨（複雑な構造のため）
```

### ステップ 4: TOMLファイル生成

#### テンプレート
```toml
# Claude Code → Gemini CLI 移行
# 元ファイル: ~/.claude/commands/[元ファイル名].md
# 変換日時: [日時]

description = "[構築したdescription]"

prompt = """
[変換済み本文]
"""
```

## 変換例

### 例1: シンプルなテキスト処理コマンド

#### 変換前（Claude Code）
```markdown
---
description: "ファイル内のテキストを検索して置換"
argument-hint: "検索パターン 置換文字列"
---

# テキスト置換: $ARGUMENTS

指定されたパターンで検索・置換を実行します。

引数: $ARGUMENTS
```

#### 変換後（Gemini CLI）
```toml
description = "ファイル内のテキストを検索して置換 - 引数: 検索パターン 置換文字列"

prompt = """
# テキスト置換: {{args}}

指定されたパターンで検索・置換を実行します。

引数: {{args}}
"""
```

### 例2: SHELL実行を含むコマンド

#### 変換前（Claude Code）
```markdown
---
description: "Gitリポジトリの状態を分析"
---

# Git分析: $ARGUMENTS

```bash
git status --porcelain
git log --oneline -10
```
```

#### 変換後（Gemini CLI）
```toml
description = "Gitリポジトリの状態を分析"

prompt = """
# Git分析: {{args}}

!{echo "=== 現在の状態 ==="}
!{git status --porcelain}
!{echo "=== 最近のコミット ==="}
!{git log --oneline -10}
"""
```

## 検証・品質保証

### 構文チェック
```bash
# 必須フィールドの確認
find ~/.gemini/commands -name "*.toml" -exec grep -L "^description = " {} \;
find ~/.gemini/commands -name "*.toml" -exec grep -L "^prompt = " {} \;

# 引数プレースホルダーの確認
grep -r "\$ARGUMENTS" ~/.gemini/commands  # これは空であるべき
grep -r "{{args}}" ~/.gemini/commands     # 正しく変換されているか
```

### 動作テスト
```bash
# 基本的な実行テスト
gemini /category:command-name "test arguments"

# SHELL実行の動作確認
# （実際にコマンドを実行して出力を確認）
```

## トラブルシューティング

### よくある問題と対処法

#### 1. TOML構文エラー
- **問題**: クォートの不整合、特殊文字のエスケープ不備
- **対処**: マルチライン文字列（`"""`）内の特殊文字をチェック

#### 2. 引数が認識されない
- **問題**: `$ARGUMENTS`の変換漏れ
- **対処**: `grep -r "\$ARGUMENTS" ~/.gemini/commands`で確認

#### 3. SHELL実行されない
- **問題**: `!{}`構文の記述ミス
- **対処**: シンプルなコマンドで段階的にテスト

#### 4. カテゴリが見つからない
- **問題**: ディレクトリ構造とファイル配置の不整合
- **対処**: `find ~/.gemini/commands -name "*.toml"`でパス確認

### デバッグ手順
```bash
# 1. ファイル存在確認
ls -la ~/.gemini/commands/category/command.toml

# 2. ファイル内容確認
cat ~/.gemini/commands/category/command.toml

# 3. Gemini CLIでの認識確認
gemini --list-commands | grep command-name

# 4. 実行テスト
gemini /category:command-name --help
```

## ベストプラクティス

### 変換前の準備
1. **バックアップ**: 既存のコマンドをバックアップ
2. **カテゴリ設計**: 将来の拡張を考慮した分類体系
3. **命名規則**: 一貫性のあるファイル・コマンド名

### 変換時の注意点
1. **段階的変換**: 一度に全部ではなく、カテゴリごとに変換
2. **テスト実行**: 各コマンド変換後に動作確認
3. **ドキュメント化**: 変換履歴やカスタマイズ内容の記録

### 保守・更新
1. **定期レビュー**: 使用頻度の低いコマンドの整理
2. **機能拡張**: 新しいパターンの変換ルール追加
3. **共有**: チーム内での変換ルール統一

---

**注意**: このガイドは汎用的な変換原則を示しており、個々のコマンドの複雑さに応じて追加の手動調整が必要な場合があります。環境や要件に応じてカスタマイズしてください。