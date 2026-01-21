# LangSmith + LLM App

LangSmith の Run 記録と LLM 呼び出しの動作確認用の小さなサンプルです。  
現状は `main.py` で Gemini を呼び出し、LangSmith に入出力を記録します。  
Streamlit 化はこれから進める予定です（`TODO.md` を参照）。

## 必要条件
- Python 3.10+

## セットアップ
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

`.env` を作成し、以下を設定してください。
```
LANGSMITH_API_KEY=...
LANGSMITH_PROJECT_NAME=...   # 任意
LANGSMITH_ENDPOINT=...       # 任意（未設定なら https://api.smith.langchain.com）
GEMINI_API_KEY=...
```

## 実行（現状）
```bash
python main.py
```

## 今後の予定
- Streamlit でプロンプト入力とモデル選択をできる UI を追加
- OpenAI / Claude など複数プロバイダ対応
