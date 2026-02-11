# Python 1時間短縮版

この教材では、Pythonの基本を1時間で学びます。

## 学習目標

- Pythonの基本構文（変数、データ型、演算子）を理解する
- 制御フロー（if、for、while）を使えるようになる
- 簡単なプログラムを実装できるようになる

## Phase構成

### [Phase 1: Pythonの基本](./phase1-basics.md)
- 数値と演算子
- 文字列とリスト
- 入出力（print、input）
- 型変換

**所要時間**: 20分

### [Phase 2: 実践 - 制御フローとプログラム](./phase2-practice.md)
- if / elif / else
- for ループ、while ループ
- range()、break、continue
- 実践プログラム（数当てゲーム、リスト処理）

**所要時間**: 40分

## 学習の進め方

1. [Phase 1: Pythonの基本](./phase1-basics.md) を読んで理論を理解する
2. [Phase 2: 実践](./phase2-practice.md) の例を実際にコードを書きながら進める
3. 練習問題に取り組む

## 前提知識

- プログラミングの基本的な概念（変数、条件分岐、ループ）を知っていると理解しやすい
- ターミナル（コマンドライン）の基本的な操作

## 必要な環境

- Python 3.10以上（推奨: 3.12以上）
- テキストエディタ（VS Code、Sublime Textなど）

### venv（仮想環境）の準備

本教材では **venv 環境**で実行することを推奨します。

```bash
# study_books/python/basic ディレクトリへ移動
cd study_books/python/basic

# 仮想環境を作成
python -m venv venv

# 有効化（学習前に毎回実行）
# macOS / Linux:
source venv/bin/activate
# Windows (PowerShell):
venv\Scripts\Activate.ps1
# Windows (cmd):
venv\Scripts\activate.bat
```

プロンプトに `(venv)` が表示されればOKです。この状態で `python` コマンドを実行してください。

### Pythonの確認

```bash
# venv 有効化後
python --version
# または（venv 未使用時）
python3 --version
```

## 認定試験対応

本1時間版は **PCEP（Certified Entry-Level Python Programmer）** の基礎部分（Fundamentals、Control Flowの入門）に対応しています。

## 総所要時間

約1時間（理解度により変動）

## 次のステップ

1時間版を完了したら、より詳細な学習のために [3時間版](../3hours/README.md) に進むことをお勧めします。関数、辞書、例外処理、オブジェクト指向まで学べます。

---

## 教材情報

- **作成者**: 本教材はAIによって作成されています。内容に誤りや不正確な記述がある可能性があります。重要な情報は公式ドキュメント等で必ずご確認ください。
- **作成日**: 2026年2月
- **参考情報（出典）**:
  - [Python公式チュートリアル](https://docs.python.org/3/tutorial/)
  - [PEP 8 -- Style Guide for Python Code](https://peps.python.org/pep-0008/)
  - [Python Institute - PCEP Exam Syllabus](https://pythoninstitute.org/pcep-exam-syllabus)
