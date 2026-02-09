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

trim_spaces() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf "%s" "$s"
}

escape_regex() {
  printf "%s" "$1" | sed -e 's/[][\\.^$*+?{}|()]/\\&/g'
}

build_author_regex() {
  local input="$1"
  if [[ "$input" == *","* ]]; then
    local parts=()
    IFS=',' read -r -a parts <<< "$input"
    local escaped=()
    local p
    for p in "${parts[@]}"; do
      p="$(trim_spaces "$p")"
      [ -z "$p" ] && continue
      escaped+=( "$(escape_regex "$p")" )
    done
    if [ ${#escaped[@]} -eq 0 ]; then
      printf "%s" "$input"
    else
      local joined=""
      for p in "${escaped[@]}"; do
        if [ -n "$joined" ]; then
          joined="${joined}|${p}"
        else
          joined="$p"
        fi
      done
      printf "(%s)" "$joined"
    fi
  else
    printf "%s" "$input"
  fi
}

AUTHOR_REGEX="$(build_author_regex "$AUTHOR")"

run_numstat() {
  local label="$1"
  shift
  local err_file out status
  err_file="$(mktemp)"
  set +e
  out="$("$@" 2>"$err_file" | awk '{ if ($1 ~ /^[0-9]+$/) add+=$1; if ($2 ~ /^[0-9]+$/) del+=$2 } END { printf "%d %d", add+0, del+0 }')"
  status=$?
  set -e
  if [ $status -ne 0 ] || [ -s "$err_file" ]; then
    echo "[warn] ${label}" >&2
    cat "$err_file" >&2
  fi
  rm -f "$err_file"
  printf "%s" "$out"
}

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
DEFAULT_EXCLUDES="DerivedData,.build,SourcePackages,checkouts,node_modules,.gradle,gradle-cache,build,dist,Pods,Carthage,.swiftpm,target,out,venv,.venv"
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

# git diff から除外するファイル（カンマ区切りで上書き可）
DEFAULT_EXCLUDE_FILES=".gradle-home/caches/8.9/kotlin-dsl/accessors/014b15b002bdda6bc879f837b03893e7/sources/org/gradle/kotlin/dsl/Accessors6kce2f9onf1yvha3oi0wn04jf.kt"
EXCLUDE_FILES="${EXCLUDE_FILES:-$DEFAULT_EXCLUDE_FILES}"

IFS=',' read -r -a EXCLUDE_FILE_LIST_RAW <<< "$EXCLUDE_FILES"
EXCLUDE_FILE_LIST=()
for p in "${EXCLUDE_FILE_LIST_RAW[@]}"; do
  p="$(trim_spaces "$p")"
  [ -z "$p" ] && continue
  EXCLUDE_FILE_LIST+=( "$p" )
done

DIFF_PATHS=()
if [ ${#EXCLUDE_FILE_LIST[@]} -gt 0 ]; then
  DIFF_PATHS+=( -- . )
  for p in "${EXCLUDE_FILE_LIST[@]}"; do
    DIFF_PATHS+=( ":(exclude)$p" )
  done
fi

DIFF_ARGS=( --numstat )
if [ ${#DIFF_PATHS[@]} -gt 0 ]; then
  DIFF_ARGS+=( "${DIFF_PATHS[@]}" )
fi

# 未追跡ファイルを集計するか（1=含める, 0=除外）
INCLUDE_UNTRACKED="${INCLUDE_UNTRACKED:-0}"

is_excluded_file() {
  local f="$1"
  local p
  for p in "${EXCLUDE_FILE_LIST[@]}"; do
    if [ "$f" = "$p" ]; then
      return 0
    fi
  done
  return 1
}

# ROOT 配下の Git リポジトリを検出して集計
FIND_ARGS=("$ROOT")
if [ ${#EXCLUDE_EXPR[@]} -gt 0 ]; then
  FIND_ARGS+=( "(" "${EXCLUDE_EXPR[@]}" ")" -prune -o )
fi
FIND_ARGS+=( -type d -name .git -print0 )

while IFS= read -r -d '' gitdir; do
  repo="$(dirname "$gitdir")"

  # 当日の追加/削除行を author 指定で合計（バイナリは除外）
  stats=$(run_numstat "git log (committed): $repo" \
    git -C "$repo" log \
    --since "$DAY_START" \
    --until "$DAY_END" \
    --extended-regexp \
    --author "$AUTHOR_REGEX" \
    --no-merges \
    --numstat \
    --pretty=tformat:)

  add=$(printf "%s" "$stats" | awk '{print $1}')
  del=$(printf "%s" "$stats" | awk '{print $2}')

  # ワークツリー/ステージング/未追跡の差分も加算
  work_stats=$(run_numstat "git diff (working tree): $repo" \
    git -C "$repo" diff "${DIFF_ARGS[@]}")
  work_add=$(printf "%s" "$work_stats" | awk '{print $1}')
  work_del=$(printf "%s" "$work_stats" | awk '{print $2}')

  cached_stats=$(run_numstat "git diff (staged): $repo" \
    git -C "$repo" diff --cached "${DIFF_ARGS[@]}")
  cached_add=$(printf "%s" "$cached_stats" | awk '{print $1}')
  cached_del=$(printf "%s" "$cached_stats" | awk '{print $2}')

  untracked_add=0
  untracked_del=0
  if [ "$INCLUDE_UNTRACKED" = "1" ]; then
    while IFS= read -r -d '' file; do
      if is_excluded_file "$file"; then
        continue
      fi
      diff_stats=$(run_numstat "git diff (untracked): $repo :: $file" \
        git -C "$repo" diff --numstat --no-index /dev/null "$file")
      file_add=$(printf "%s" "$diff_stats" | awk '{print $1}')
      file_del=$(printf "%s" "$diff_stats" | awk '{print $2}')
      untracked_add=$((untracked_add + file_add))
      untracked_del=$((untracked_del + file_del))
    done < <(git -C "$repo" ls-files --others --exclude-standard -z 2>/dev/null)
  fi

  add=$((add + work_add + cached_add + untracked_add))
  del=$((del + work_del + cached_del + untracked_del))
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
