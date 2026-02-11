# Python 基礎 学習教材

このディレクトリには、Pythonの基礎を学習するための教科書が含まれています。
Python認定試験（PCEP、PCAP）の対策にも対応しています。

## 教材の種類

### [1時間短縮版](./1hour/)
Pythonの基本を素早く理解したい方向けの短縮版です。
- **対象**: Pythonを初めて学ぶ方、時間が限られている方
- **内容**: 基本構文、データ型、制御フロー、簡単なプログラム
- **所要時間**: 約1時間
- **詳細**: [1時間版のREADME](./1hour/README.md)を参照

### [3時間みっちり版](./3hours/)
Pythonを深く理解し、認定試験対策と実践的なプログラムを書けるようになるための詳細版です。
- **対象**: Pythonの基礎をしっかり理解し、PCEP/PCAP試験対策をしたい方
- **内容**: 理論から実践、関数、例外、OOPまで包括的に学習
- **所要時間**: 約3-4時間（理解度により変動）
- **詳細**: [3時間版のREADME](./3hours/README.md)を参照

## 学習の進め方

1. まずは[1時間版](./1hour/)で基本を掴む
2. より深く学びたい場合は[3時間版](./3hours/)に進む
3. 各Phaseの実践例を実際にコードを書きながら進める
4. 各Phaseの最後にある練習問題に取り組む
5. **演習用のファイルは [tutorial](./tutorial/) フォルダ下に作成していく**

## 認定試験対応

本教材は以下のPython Institute認定試験の出題範囲をカバーしています：

- **PCEP™ (Certified Entry-Level Python Programmer)**: 1時間版＋3時間版の前半
- **PCAP™ (Certified Associate in Python Programming)**: 3時間版全体

## 必要な環境

- Python 3.10以上（推奨: 3.12以上）
- テキストエディタまたはIDE（VS Code、PyCharmなど）
- ターミナルまたはコマンドプロンプト

### Pythonのインストール

1. [Python公式サイト](https://www.python.org/downloads/)から最新版をダウンロード
2. インストール時に「Add Python to PATH」にチェック
3. ターミナルで `python --version` を実行して確認

### venv（仮想環境）での学習

**本教材では venv 環境での学習を推奨します。** プロジェクトごとに依存関係を分離でき、システムのPythonに影響を与えません。

```bash
# python/basic ディレクトリに移動
cd study_books/python/basic

# 仮想環境を作成
python -m venv venv

# 仮想環境を有効化
# macOS / Linux:
source venv/bin/activate
# Windows (PowerShell):
venv\Scripts\Activate.ps1
# Windows (cmd):
venv\Scripts\activate.bat

# pip を最新化（任意）
pip install --upgrade pip

# プロンプトに (venv) が表示されていればOK
# 学習を始める際は、必ず venv を有効化してから python コマンドを実行する
```

学習終了後に仮想環境を無効化するには `deactivate` を実行します。

---

## 教材情報

- **作成者**: 本教材はAIによって作成されています。内容に誤りや不正確な記述がある可能性があります。重要な情報は公式ドキュメント等で必ずご確認ください。
- **作成日**: 2026年2月
- **参考情報（出典）**:
  - [Python公式チュートリアル](https://docs.python.org/3/tutorial/)
  - [Python公式ドキュメント](https://docs.python.org/3/)
  - [PEP 8 -- Style Guide for Python Code](https://peps.python.org/pep-0008/)
  - [Python Institute - PCEP Exam Syllabus](https://pythoninstitute.org/pcep-exam-syllabus)
  - [Python Institute - PCAP Exam Syllabus](https://pythoninstitute.org/pcap-exam-syllabus)
