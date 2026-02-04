#!/usr/bin/env bash
set -euo pipefail

# スクリプトの所在を解決（相対パス出力のため）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DATE="${1:-$(date +%F)}"

# .env を読み込んで AUTHOR を取得（引数があればそれを優先）
ENV_FILE="${SCRIPT_DIR}/.env"
if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$ENV_FILE"
  set +a
fi

# 走査対象（ROOT=/path/to/repos で上書き可）
ROOT="${ROOT:-/Users/yoshiki.takamatsu/Documents/repos}"
# 出力先ルート（OUT_ROOT=/path/to/output で上書き可）
OUT_ROOT="${OUT_ROOT:-${SCRIPT_DIR}/output}"

if [ -n "${2:-}" ]; then
  AUTHOR="$2"
else
  AUTHOR="${AUTHOR:-}"
fi

if [ -z "$AUTHOR" ]; then
  echo "AUTHOR is not set. Add AUTHOR to .env or pass it as the 2nd argument." >&2
  exit 1
fi

# ローカル日の範囲に限定
DAY_START="${DATE} 00:00:00"
DAY_END="${DATE} 23:59:59"

OUT_DIR="${OUT_ROOT}/${DATE}"
OUT_DETAIL_CSV="${OUT_DIR}/daily_code_detail.csv"
OUT_SUMMARY_CSV="${OUT_DIR}/daily_code_summary.csv"

mkdir -p "$OUT_DIR"

# CSV ヘッダー（詳細）
printf "date,repo,added,deleted,touched\n" > "$OUT_DETAIL_CSV"

total_add=0
total_del=0

# 除外ディレクトリ（カンマ区切りで上書き可）
DEFAULT_EXCLUDES="DerivedData,.build,SourcePackages,checkouts,node_modules,.gradle,build,dist,Pods,Carthage,.swiftpm,target,out,venv,.venv"
EXCLUDE_PATTERNS="${EXCLUDE_PATTERNS:-$DEFAULT_EXCLUDES}"
IFS=',' read -r -a EXCLUDE_LIST <<< "$EXCLUDE_PATTERNS"

EXCLUDE_EXPR=()
for p in "${EXCLUDE_LIST[@]}"; do
  [ -z "$p" ] && continue
  if [ ${#EXCLUDE_EXPR[@]} -gt 0 ]; then
    EXCLUDE_EXPR+=( -o )
  fi
  EXCLUDE_EXPR+=( -path "*/$p/*" )
done

# ROOT 配下の Git リポジトリを検出して集計
FIND_ARGS=("$ROOT")
if [ ${#EXCLUDE_EXPR[@]} -gt 0 ]; then
  FIND_ARGS+=( "(" "${EXCLUDE_EXPR[@]}" ")" -prune -o )
fi
FIND_ARGS+=( -type d -name .git -print0 )

while IFS= read -r -d '' gitdir; do
  repo="$(dirname "$gitdir")"

  # 当日の追加/削除行を author 指定で合計（バイナリは除外）
  stats=$(git -C "$repo" log \
    --since "$DAY_START" \
    --until "$DAY_END" \
    --author "$AUTHOR" \
    --no-merges \
    --numstat \
    --pretty=tformat: 2>/dev/null \
    | awk '{ if ($1 ~ /^[0-9]+$/) add+=$1; if ($2 ~ /^[0-9]+$/) del+=$2 } END { printf "%d %d", add+0, del+0 }')

  add=$(printf "%s" "$stats" | awk '{print $1}')
  del=$(printf "%s" "$stats" | awk '{print $2}')
  touched=$((add + del))

  # 変更がないリポジトリは出力しない
  if [ "$add" -eq 0 ] && [ "$del" -eq 0 ]; then
    continue
  fi

  # リポジトリ別の行（変更があるものだけ）
  printf "%s,\"%s\",%d,%d,%d\n" "$DATE" "$repo" "$add" "$del" "$touched" >> "$OUT_DETAIL_CSV"

  total_add=$((total_add + add))
  total_del=$((total_del + del))

done < <(find "${FIND_ARGS[@]}")

# 合計行（詳細）
total_touched=$((total_add + total_del))
printf "%s,TOTAL,%d,%d,%d\n" "$DATE" "$total_add" "$total_del" "$total_touched" >> "$OUT_DETAIL_CSV"

# サマリー（その日の合計のみ）
printf "date,added,deleted,touched\n" > "$OUT_SUMMARY_CSV"
printf "%s,%d,%d,%d\n" "$DATE" "$total_add" "$total_del" "$total_touched" >> "$OUT_SUMMARY_CSV"

echo "Wrote $OUT_DETAIL_CSV"
echo "Wrote $OUT_SUMMARY_CSV"
