# daily-code-metrics

日々の Git 変更量（追加/削除行数）を、指定ディレクトリ配下の全リポジトリから集計し、
日付フォルダに CSV で出力するツールです。

## できること
- ルート配下の全 Git リポジトリを自動検出
- 自分の Git author による変更だけを集計
- リポジトリ別と合計の追加/削除/純増を CSV に出力
- 以下は自動で除外: `DerivedData`, `.build`, `SourcePackages`, `checkouts`, `node_modules`, `.gradle`, `build`, `dist`, `Pods`, `Carthage`, `.swiftpm`, `target`, `out`, `venv`, `.venv`
- merge commit は除外（`--no-merges`）

## 使い方

```bash
# .env を作成
cp .env.sample .env

# 今日の分（ローカル日付）
./collect_daily_code.sh

# 日付を指定
./collect_daily_code.sh 2026-02-04

# 日付と author を指定（正規表現可）
./collect_daily_code.sh 2026-02-04 "email1|email2"

# 日付と author を複数指定（カンマ区切り）
./collect_daily_code.sh 2026-02-04 "email1,email2"

# ローカルの未コミット差分も集計したい場合は以下を含める
# - ワークツリーの変更
# - ステージング済みの変更
# - 未追跡ファイル
```

## 可視化（Python + venv）
matplotlib でグラフを出力します。出力先は `output/report/YYYY-MM-DD/` です。

```bash
# venv を作成
python -m venv .venv

# venv を有効化
source .venv/bin/activate

# 依存をインストール
python -m pip install -r requirements.txt

# グラフ出力
python visualize_metrics.py
```

集計単位の指定（デフォルトは日次）:
```bash
python visualize_metrics.py --granularity daily
python visualize_metrics.py --granularity weekly
python visualize_metrics.py --granularity monthly
```

カスタム出力先の例:
```bash
python visualize_metrics.py --plots-dir output/report/custom
```

## 出力
出力先:

```
output/YYYY-MM-DD/daily_code_detail.csv
output/YYYY-MM-DD/daily_code_summary.csv
```

詳細ファイルの列:
- date
- repo
- added
- deleted
- touched

最終行に TOTAL の合計が入ります。

サマリーファイルの列:
- date
- added
- deleted
- touched

## 設定（任意）
環境変数で上書きできます。

```bash
# 走査するルートを変更
ROOT="/path/to/repos" ./collect_daily_code.sh

# 出力先を変更
OUT_ROOT="/path/to/output" ./collect_daily_code.sh
```

## .env
スクリプトと同じディレクトリに `.env` を置いてください。
テンプレートは `.env.sample` です。

例:
```
AUTHOR="yoshiki.takamatsu"
ROOT="/path/to/repos"
OUT_ROOT="/path/to/output"
EXCLUDE_PATTERNS="DerivedData,.build,SourcePackages,checkouts,node_modules,.gradle,build,dist,Pods,Carthage,.swiftpm,target,out,venv,.venv"
```
