#!/bin/bash
# 全日付のCSVデータを統合するスクリプト

OUTPUT_DIR="$(dirname "$0")/output"
AGGREGATED_DIR="${OUTPUT_DIR}/aggregated"

mkdir -p "${AGGREGATED_DIR}"

# Summary CSVを統合
echo "date,added,deleted,touched" > "${AGGREGATED_DIR}/all_summary.csv"
for dir in "${OUTPUT_DIR}"/20*/; do
    if [ -f "${dir}/daily_code_summary.csv" ]; then
        tail -n +2 "${dir}/daily_code_summary.csv" >> "${AGGREGATED_DIR}/all_summary.csv"
    fi
done

# Detail CSVを統合
echo "date,repo,added,deleted,touched" > "${AGGREGATED_DIR}/all_detail.csv"
for dir in "${OUTPUT_DIR}"/20*/; do
    if [ -f "${dir}/daily_code_detail.csv" ]; then
        # TOTALの行を除外して追加
        tail -n +2 "${dir}/daily_code_detail.csv" | grep -v ",TOTAL," >> "${AGGREGATED_DIR}/all_detail.csv"
    fi
done

echo "Aggregated CSV files created in ${AGGREGATED_DIR}"
