---
allowed-tools: Search(./*), Glob(./*), Grep(./*), WebSearch(*), WebFetch(*), Bash(ls:*), Write(./.deep-planning.md), Write(/tmp/deep-plan-agent-context.txt)
description: Deep Planning - 自動継続型4段階システム  
argument-hint: [プロジェクト名または機能の説明]
---

# 🏗️ Deep Planning: $ARGUMENTS
## 🔄 自動状態判定と継続実行

プロジェクト管理ディレクトリを準備：

! DATE=$(perl -MPOSIX -le 'print strftime("%Y-%m-%d %H:%M:%S", localtime)')
! PLAN_FILE=".deep-planning.md"
! PROJECT_NAME="$ARGUMENTS"

現在のプロジェクト状態を自動判定：

! if [ -f "$PLAN_FILE" ]; then
    if grep -q "<!-- Phase: Completed -->" "$PLAN_FILE"; then
        echo "🎉 PROJECT COMPLETED - Ready for deployment"
        grep -A 5 "## 📊 Final Statistics" "$PLAN_FILE" || echo "Stats not available"
    elif grep -q "<!-- Phase: Tasks -->" "$PLAN_FILE"; then
        echo "✅ TASK PROGRESS - Implementation in progress"
        TOTAL=$(grep -c "^- \[.\]" "$PLAN_FILE" 2>/dev/null || echo "0")
        DONE=$(grep -c "^- \[x\]" "$PLAN_FILE" 2>/dev/null || echo "0")
        echo "Progress: $DONE/$TOTAL tasks completed"
    elif grep -q "<!-- Phase: Planning -->" "$PLAN_FILE"; then
        echo "📋 PLANNING PHASE - Creating detailed implementation plan"
    elif grep -q "<!-- Phase: Discussion -->" "$PLAN_FILE"; then
        echo "💭 DISCUSSION PHASE - Clarifying requirements"
    elif grep -q "<!-- Phase: Investigation -->" "$PLAN_FILE"; then
        echo "🔍 INVESTIGATION PHASE - Analyzing codebase"
    else
        echo "🔄 CONTINUING existing project..."
    fi
    PROJECT_NAME=$(grep "^# Deep Planning:" "$PLAN_FILE" | sed 's/^# Deep Planning: //' || echo "$ARGUMENTS")
  else
    echo "🆕 INITIALIZING new project: $PROJECT_NAME"
  fi

---

## 🔍 Phase 1: Silent Investigation (Detective Mode)

**"No commentary, no narration - just focused research"**

### プロジェクト初期化（新規の場合のみ）

! if [ ! -f "$PLAN_FILE" ]; then
    cat > "$PLAN_FILE" << EOF
# Deep Planning: $PROJECT_NAME

**Created**: $DATE
**Last Updated**: $DATE  
**Current Phase**: Investigation
**Progress**: 0% (0/0 tasks completed)

<!-- Phase: Investigation -->

---

## 🔍 Step 1: Silent Investigation

### Project Structure
<!-- Investigation results will be populated here -->

### Code Analysis
<!-- Code analysis results -->

### Dependencies & Tech Stack  
<!-- Dependency analysis -->

### Technical Context
<!-- Technical debt and constraints -->

---

## 💭 Step 2: Discussion & Requirements
<!-- Status: Not Started -->

### Questions for Clarification
<!-- Project-specific questions will be generated -->

### Decisions Made
<!-- User responses recorded here -->

### Requirements Confirmed
<!-- Final requirements summary -->

---

## 📋 Step 3: Implementation Plan
<!-- Status: Not Started -->

[Overview]
<!-- Project overview and approach -->

[Types]
<!-- Type definitions and interfaces -->

[Files] 
<!-- File creation, modification, deletion plan -->

[Functions]
<!-- Function specifications -->

[Classes]
<!-- Class design and modifications -->

[Dependencies]
<!-- Package and library requirements -->

[Testing]
<!-- Testing strategy and coverage -->

[Implementation Order]
<!-- Step-by-step implementation sequence -->

---

## ✅ Step 4: Task Progress  
<!-- Status: Not Started -->

<!-- Tasks will be auto-generated from Implementation Plan -->

---

## 📝 Notes & Context

<!-- Additional project insights and context -->

EOF
    echo "✅ プロジェクトファイル初期化完了: $PLAN_FILE"
  fi

### Silent Investigation実行

**Detective Mode**: "No commentary, no narration - just focused research"

プロジェクトの言語・フレームワーク・アーキテクチャを調査し、以下の情報を `.deep-planning.md` の Step 1 セクションに記録してください：

#### 調査対象
1. **Project Structure** - ディレクトリ構成と主要コンポーネント
2. **Tech Stack** - 使用言語・フレームワーク・主要ライブラリ  
3. **Architecture Pattern** - 設計パターンとプロジェクト規模
4. **Dependencies** - パッケージ管理とバージョン情報
5. **Technical Context** - 制約事項・技術的負債・TODO項目

#### 分析例
```
=== SAMPLE OUTPUT ===
Project Structure: Go microservice with Clean Architecture
Tech Stack: Go 1.21, Gin framework, PostgreSQL, Redis
Architecture: cmd/api + internal/domain + pkg/infrastructure  
Dependencies: 15 external packages, Docker containerized
Technical Context: 3 TODO items in auth module, deprecated JWT lib
```

**調査完了後**: Phase を Discussion に更新し、発見された技術スタックに基づくプロジェクト固有の質問を準備してください。

**Silent完了マーカー**: 調査終了後に以下を実行：
- Current Phase: Discussion に更新
- `<!-- Phase: Discussion -->` マーカーに変更
- Last Updated タイムスタンプ更新

---

## 💭 Phase 2: Discussion & Requirements (Targeted Questions)

**"Targeted questions, not generic"** - プロジェクト固有の具体的質問

### 動的質問生成

調査結果に基づいて、以下のアプローチでプロジェクト固有の質問を生成、生成完了後にユーザーに質問をおこなってください：

1. **発見された技術スタック**に基づく実装選択肢
2. **既存のアーキテクチャパターン**との整合性確認  
3. **特定された制約・技術的負債**への対処方針
4. **プロジェクト固有のコンテキスト**からの要件確認

### 標準質問フレームワーク + プロジェクト固有質問

**🎯 Purpose & Success (目的と成功指標)**
- この機能の主要な目的は？
- どのような状態で「完成」と判断しますか？
- 既存の[検出された機能]への影響をどう考えますか？

**🔧 Technical Approach (技術的アプローチ)**  
- 既存の[検出されたパターン]を拡張 vs 新規実装？
- [発見された技術スタック]の制約下でのベストプラクティスは？
- パフォーマンス要件（特に[検出されたボトルネック]関連）は？

**🚧 Constraints & Requirements (制約と要件)**
- [特定されたTODO/技術的負債]との優先順位は？
- [既存の依存関係]との互換性要件は？
- テスト戦略（[検出されたテストパターン]に合わせて）は？

### ユーザー回答の記録

回答内容を `.deep-planning.md` の Step 2 セクションに記録し、Phase を Planning に更新。

---

## 📋 Phase 3: Implementation Plan (AI-Powered Comprehensive Planning)

**"persistent-planner エージェントと堅牢なテンプレートの融合"** - 動的生成と構造化された詳細度

### persistent-planner エージェントによる詳細計画の補強

以下のテンプレート各セクションについて、persistent-planner エージェントを使用して
詳細な内容を自動生成します。Phase 1の調査結果とPhase 2の要件を基に、
プロジェクトに最適化された具体的な計画を作成してください。

### 詳細実装計画テンプレート

Investigation セクションと Discussion セクションの内容を基に、詳細な実装計画を作成し、`.deep-planning.md` の Step 3: Implementation Plan セクションに記録してください：

以下の8つのセクションをすべて具体的に記入：

[Overview] - **persistent-planner エージェントで以下を分析・生成：**
- プロジェクトの概要と採用するアプローチ
- アーキテクチャ決定の理由
- 既存システムとの統合方針

[Types] - **persistent-planner エージェントで以下を設計：**
- 言語固有の型定義（TypeScript interfaces、Go structs、Ruby classes、Python type hints等）
- インターフェース・プロトコル設計
- データ構造とスキーマの詳細

[Files] - **persistent-planner エージェントで以下を特定：**
- 新規作成するファイルの完全パス
- 変更するファイルとその理由  
- 削除が必要なファイル

[Functions] - **persistent-planner エージェントで以下を仕様化：**
- 新規実装する関数の詳細仕様
- 変更する既存関数の修正内容
- 関数シグネチャと返り値

[Classes] - **persistent-planner エージェントで以下を設計：**
- 新規作成するクラスの設計
- 既存クラスの変更内容
- 継承関係とメソッド定義

[Dependencies] - **persistent-planner エージェントで以下を分析：**
- 追加が必要なパッケージとバージョン
- 更新が必要な既存依存関係
- 設定ファイルの変更内容

[Testing] - **persistent-planner エージェントで以下を策定：**
- テスト戦略と実装方針
- カバレッジ目標
- テストファイル構成

[Implementation Order] - **persistent-planner エージェントで以下を計画：**
- Phase別の実装手順
- 各Phaseの完了条件
- リスクとそれへの対策

各セクションは実装者が迷わない程度に具体的に記述し、ファイルパス、関数名、クラス名は実際のものを使用してください。

### 🤖 persistent-planner エージェントによる計画詳細化

プロジェクト「$PROJECT_NAME」の詳細実装計画を生成するため、
persistent-planner エージェントを起動してください：

**エージェントへの指示内容：**
```
プロジェクト「$PROJECT_NAME」の実装計画を詳細化してください。

以下のコンテキストを参照：
1. `.deep-planning.md` の Phase 1 (Silent Investigation) の調査結果
2. Phase 2 (Discussion & Requirements) の要件と制約
3. プロジェクトのコードベース構造

上記8つのセクション（Overview, Types, Files, Functions, Classes, Dependencies, Testing, Implementation Order）について、
それぞれ具体的で実装者が迷わない内容を生成してください。

- ファイルパス、関数名、クラス名は実際のプロジェクト構造に基づく
- 実装順序は依存関係を考慮した論理的な順番
- 各項目に推定時間と難易度を含める
- プロジェクトの技術スタックに最適化されたアプローチを採用

生成した内容を `.deep-planning.md` の Step 3: Implementation Plan セクションの
対応する[セクション]内に記録してください。
```

### エージェント情報自動抽出

persistent-planner エージェントへの情報受け渡しを自動化：

! # Phase 1の調査結果を抽出
! INVESTIGATION=$(sed -n '/## 🔍 Step 1:/,/## 💭 Step 2:/p' "$PLAN_FILE" | sed '$d')

! # Phase 2の要件を抽出  
! REQUIREMENTS=$(sed -n '/## 💭 Step 2:/,/## 📋 Step 3:/p' "$PLAN_FILE" | sed '$d')

! # エージェント用プロンプトファイル作成 (/tmp に配置)
! cat > /tmp/deep-plan-agent-context.txt << EOF
# persistent-planner エージェント用コンテキスト情報

## プロジェクト情報
- プロジェクト名: $PROJECT_NAME
- 作成日時: $DATE

## Phase 1: 調査結果
$INVESTIGATION

## Phase 2: 要件と制約
$REQUIREMENTS

## 指示
上記情報を基に、Implementation Planの8セクション（Overview, Types, Files, Functions, Classes, Dependencies, Testing, Implementation Order）を詳細化してください。
各項目は実装者が迷わない具体性を持ち、実際のファイルパス、関数名、クラス名を使用してください。
EOF

! echo "📝 persistent-planner エージェント用コンテキスト情報を /tmp/deep-plan-agent-context.txt に生成しました"
! echo "💡 エージェント実行時にこのファイルを参照してください"

### Planning完了処理

計画作成後に以下を更新：
- Current Phase: Task Progress  
- `<!-- Phase: Tasks -->` マーカーに変更
- Last Updated タイムスタンプ

---

## ✅ Phase 4: Task Progress (AI-Enhanced Structured Execution)

**"persistent-planner エージェントによる実行可能なタスク分解"** - 動的で追跡可能な実装ステップ

### persistent-planner エージェントによるタスクリスト自動生成

Implementation Plan の [Implementation Order] セクションを基に、
persistent-planner エージェントが実行可能なタスクリストを自動生成します：

**エージェントへの指示内容：**
```
`.deep-planning.md` の Step 3: Implementation Plan の [Implementation Order] セクションの内容を分析し、
以下の要件で詳細なタスクリストを生成してください：

## タスク生成要件：
1. **各実装フェーズを具体的なタスクに分解**
2. **推定時間と難易度を現実的に算出**
3. **依存関係を明確化**
4. **チェック可能な完了条件を設定**

## タスク形式：
- [ ] タスク名 - 推定時間 [難易度] (関連ファイル) 
  - 前提条件: xxx
  - 完了条件: xxx

## 難易度レベル：
- [S] 15分-1時間 (設定変更、簡単な実装)
- [M] 1-4時間 (通常の機能実装)
- [L] 4-8時間 (複雑な機能、アーキテクチャ変更)
- [XL] 8時間以上 (大規模リファクタリング、新システム)

## Phase分類例：
### Phase 1: Foundation Setup
### Phase 2: Core Implementation  
### Phase 3: Integration & Testing
### Phase 4: Documentation & Deployment (必要に応じて)

生成したタスクリストを `.deep-planning.md` の Step 4: Task Progress セクションに記録してください。
```

### 従来の手動タスク生成（バックアップ）

persistent-planner エージェントが利用できない場合の手動生成テンプレート：

Implementation Plan の [Implementation Order] を基に、詳細なタスクリストを生成し、`.deep-planning.md` の Step 4: Task Progress セクションに記録してください：

各タスクは以下の形式で記述：
- [ ] タスク名 - 推定時間 [難易度] (関連ファイル)

Phase分けして、以下のようにStep 4セクションに書き込んでください：

### Phase 1: Foundation Setup  
- [ ] Git branch creation - 15分 [S]
- [ ] Dependencies installation - 30分 [S] (package.json/go.mod/Gemfile等)
- [ ] Type definitions setup - 2時間 [M] (言語に応じた型定義ファイル)

### Phase 2: Core Implementation
- [ ] Main logic implementation - 6時間 [L] (メインロジックファイル)
- [ ] Helper functions - 3時間 [M] (ユーティリティ関数)
- [ ] Error handling - 2時間 [M] (エラーハンドリング)

### Phase 3: Integration & Testing
- [ ] Unit tests - 4時間 [M] (tests/)
- [ ] Integration testing - 3時間 [M] 
- [ ] End-to-end validation - 2時間 [M]

各タスクには以下を含める：
- 具体的なファイルパス（該当する場合）
- 推定作業時間（現実的な見積もり）  
- 難易度レベル [S/M/L/XL]
- 前提条件や依存関係


### 🔄 TodoWrite ツールによるタスク管理

**重要**: タスク実行時は必ず以下の2つをセットで管理してください：

1. **次のタスク** - TodoWrite で現在作業中のタスクを管理
2. **.deep-planning.md の更新** - タスク完了ごとに進捗を更新

#### タスク実行の標準フロー

**1. タスク開始時**:
- TodoWrite ツールで以下の2項目を登録：
  ```
  - [ ] [実装タスク名] - 現在のタスク
  - [ ] .deep-planning.md の更新 - 進捗記録
  ```
- .deep-planning.md の該当タスクを `[~]` (進行中) に更新

**2. タスク実行中**:
- TodoWrite のステータスを `in_progress` に維持
- 作業内容を適宜コメントとして記録

**3. タスク完了時**:
- TodoWrite で実装タスクを `completed` に更新
- .deep-planning.md の該当タスクを `[x]` (完了) に更新
- 完了日時と実施内容をコメントとして追記
- TodoWrite で .deep-planning.md 更新タスクも `completed` に
- 次のタスクがあれば、新たに TodoWrite に登録

#### セッション継続性の確保

別セッションで作業を再開する際：
1. `.deep-planning.md` を読み込んで現在の進捗を確認
2. TodoWrite ツールで未完了タスクを再登録
3. 前回の作業状態から継続

#### 実装例
```bash
# セッション開始時の確認
! echo "📋 現在の進捗状況を確認中..."
! grep "^- \[~\]" .deep-planning.md || echo "進行中のタスクはありません"
! echo "📝 次の未着手タスク:"
! grep "^- \[ \]" .deep-planning.md | head -1

# TodoWrite への登録例
次のタスクと .deep-planning.md 更新を TodoWrite に登録：
- API エンドポイントの実装
- .deep-planning.md の進捗更新
```

### 進捗管理システム

タスク状態の管理方法：

```bash
# タスク状態マーカー
- [ ] 未着手
- [~] 進行中  
- [x] 完了
- [!] ブロック中
```

### タスク状態の同期管理

**TodoWrite と .deep-planning.md の同期**:
- TodoWrite の `in_progress` ⟷ .deep-planning.md の `[~]`
- TodoWrite の `completed` ⟷ .deep-planning.md の `[x]`
- TodoWrite の `pending` ⟷ .deep-planning.md の `[ ]`

**更新タイミング**:
- **タスク開始**: 即座に両方を更新
- **タスク完了**: 両方を同時に更新
- **ブロック発生**: `[!]` に更新し、理由を記録

**同期確認コマンド**:
```bash
! echo "📊 TodoWrite と .deep-planning.md の同期状態確認"
! PENDING_DEEP=$(grep -c "^- \[ \]" .deep-planning.md 2>/dev/null || echo "0")
! PROGRESS_DEEP=$(grep -c "^- \[~\]" .deep-planning.md 2>/dev/null || echo "0")
! DONE_DEEP=$(grep -c "^- \[x\]" .deep-planning.md 2>/dev/null || echo "0")
! BLOCKED_DEEP=$(grep -c "^- \[!\]" .deep-planning.md 2>/dev/null || echo "0")
! echo "Deep Planning: 未着手:$PENDING_DEEP 進行中:$PROGRESS_DEEP 完了:$DONE_DEEP ブロック:$BLOCKED_DEEP"
```

**進捗計算と表示**:

! if [ -f "$PLAN_FILE" ]; then
    TOTAL=$(grep -c "^- \[.\]" "$PLAN_FILE" 2>/dev/null || echo "0")
    DONE=$(grep -c "^- \[x\]" "$PLAN_FILE" 2>/dev/null || echo "0")
    PROGRESS=$((TOTAL > 0 ? DONE * 100 / TOTAL : 0))
    echo "📊 Progress: $DONE/$TOTAL tasks ($PROGRESS%)"
    
    if [ $PROGRESS -eq 100 ]; then
        echo "🎉 All tasks completed! Ready for project completion."
    else
        echo "📅 Next tasks:"
        grep "^- \[ \]" "$PLAN_FILE" | head -3 || echo "No pending tasks found"
    fi
  fi

### 完了処理

全タスク完了時の自動処理：

! if [ -f "$PLAN_FILE" ] && [ "$(grep -c "^- \[ \]" "$PLAN_FILE" 2>/dev/null || echo "1")" = "0" ]; then
    echo "🎉 PROJECT COMPLETION DETECTED"
    # Phase: Completed マーカーの設定
    # 完了統計の生成
    # サマリーレポートの作成
  fi

---

## 🔧 継続実行とメンテナンス

### 自動継続システム with TodoWrite

次回 `/deep-plan` 実行時：
1. **状態自動判定**: ファイル内マーカーで現在フェーズを特定
2. **コンテキスト復元**: プロジェクト名と進捗を自動読み込み
3. **TodoWrite 自動登録**: 進行中/次のタスクを TodoWrite に復元
4. **適切なフェーズ実行**: 中断した箇所から自動継続
5. **進捗レポート**: 現在の状況を即座に表示

### TodoWrite 復元システム

セッション間でのタスク継続を自動化：

```bash
! # 進行中タスクの復元
! IN_PROGRESS=$(grep "^- \[~\]" .deep-planning.md | head -1 | sed 's/^- \[~\] //')
! if [ -n "$IN_PROGRESS" ]; then
!   echo "🔄 進行中タスクを発見: $IN_PROGRESS"
!   echo "📝 TodoWrite に復元してください:"
!   echo "  1. $IN_PROGRESS"
!   echo "  2. .deep-planning.md の更新"
! fi

! # 次の未着手タスクの確認
! NEXT_TASK=$(grep "^- \[ \]" .deep-planning.md | head -1 | sed 's/^- \[ \] //')
! if [ -n "$NEXT_TASK" ]; then
!   echo "📅 次の未着手タスク: $NEXT_TASK"
! fi

! # 完了済みタスクの統計
! COMPLETED_COUNT=$(grep -c "^- \[x\]" .deep-planning.md 2>/dev/null || echo "0")
! TOTAL_TASKS=$(grep -c "^- \[.\]" .deep-planning.md 2>/dev/null || echo "0")
! if [ "$TOTAL_TASKS" -gt 0 ]; then
!   PROGRESS_PERCENT=$((COMPLETED_COUNT * 100 / TOTAL_TASKS))
!   echo "📊 進捗状況: $COMPLETED_COUNT/$TOTAL_TASKS tasks completed ($PROGRESS_PERCENT%)"
! fi
```

### 自動TodoWrite登録の推奨手順

1. **進行中タスクがある場合**:
   - 上記コマンドで表示されたタスクを TodoWrite に登録
   - ステータスを `in_progress` に設定

2. **新規タスクを開始する場合**:
   - 次の未着手タスクを TodoWrite に `pending` で登録
   - .deep-planning.md 更新タスクもセットで登録

3. **作業再開**:
   - TodoWrite のタスクを `in_progress` に更新
   - .deep-planning.md の該当タスクを `[~]` に更新

### トラブルシューティング

**状態リセット**（必要時のみ）:
! rm -f .deep-planning.md

**手動フェーズ調整**:
! sed -i 's/<!-- Phase: [^>]* -->/<!-- Phase: Investigation -->/' .deep-planning.md

**進捗再計算**:
! grep -E "^- \[" .deep-planning.md | sort | uniq -c
