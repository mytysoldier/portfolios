# Python 3時間みっちり版

この教材では、Pythonを深く理解し、認定試験（PCEP/PCAP）対策と実践的なプログラムを書けるようになることを目指します。

## 学習目標

- Pythonの理論的背景を理解する
- 制御フロー、データ構造、関数、例外を完全に理解する
- オブジェクト指向プログラミングを実装できるようになる
- モジュール、パッケージ、ファイルI/Oを使えるようになる
- 実践的なアプリケーションを構築できるようになる

## Phase構成

### [Phase 1: Pythonの理論と基本概念](./phase1-theory.md)
- インタプリタとコンパイラ
- リテラル、演算子、優先順位
- PEP 8 コーディング規約

**所要時間**: 25分

### [Phase 2: 制御フロー](./phase2-control-flow.md)
- if / elif / else、match文
- for / while、range()
- break、continue、else節

**所要時間**: 30分

### [Phase 3: データ構造](./phase3-data-structures.md)
- リスト、タプル、セット、辞書
- リスト内包表記
- 文字列の詳細

**所要時間**: 35分

### [Phase 4: 関数と例外](./phase4-functions-exceptions.md)
- 関数定義、デフォルト/キーワード引数
- *args、**kwargs、ラムダ
- try/except/else/finally

**所要時間**: 40分

### [Phase 5: オブジェクト指向プログラミング](./phase5-oop.md)
- クラス、インスタンス、継承
- プライベート変数、特殊メソッド
- イテレータ、ジェネレータ

**所要時間**: 50分

### [Phase 6: 実践的なプログラム構築](./phase6-practical-program.md)
- モジュールとパッケージ
- ファイルI/O、JSON
- タスク管理アプリの構築

**所要時間**: 40分

## 認定試験対応

本3時間版は、以下のPython Institute認定試験の出題範囲をカバーしています：

| 試験 | 対応Phase | 主なトピック |
|------|-----------|-------------|
| **PCEP** | Phase 1-4 | Fundamentals, Control Flow, Data Collections, Functions & Exceptions |
| **PCAP** | Phase 1-6 全体 | 上記に加え Modules, Strings, OOP, List Comprehensions, Lambdas, Generators |

- [PCEP Exam Syllabus](https://pythoninstitute.org/pcep-exam-syllabus)
- [PCAP Exam Syllabus](https://pythoninstitute.org/pcap-exam-syllabus)

## 学習の進め方

1. 各Phaseを順番に進める
2. 理論を読んだら、すぐに実践例を試す
3. 練習問題に必ず取り組む
4. 理解が不十分な場合は、前のPhaseに戻る

## 前提知識

- プログラミングの基本的な概念（変数、条件分岐、ループ）
- ターミナル（コマンドライン）の基本的な操作

## 必要な環境

- Python 3.10以上（推奨: 3.12以上）
- テキストエディタまたはIDE（VS Code、PyCharmなど）

### venv（仮想環境）での学習

**本教材では venv 環境での学習を前提としています。**

```bash
# study_books/python/basic ディレクトリへ移動
cd study_books/python/basic

# 初回のみ: 仮想環境を作成
python -m venv venv

# 学習前に毎回: 仮想環境を有効化
# macOS / Linux:
source venv/bin/activate
# Windows (PowerShell):
venv\Scripts\Activate.ps1
# Windows (cmd):
venv\Scripts\activate.bat

# pip を最新化（任意）
pip install --upgrade pip
```

`(venv)` がプロンプトに表示されていれば、この環境内で `python` や `pip` を実行できます。学習終了時は `deactivate` で無効化します。

## 総所要時間

約3.5-4時間（理解度により変動）

## 次のステップ

3時間版を完了したら、以下に挑戦してみましょう：

- **PCEP試験**: Python Instituteのエントリーレベル認定
- **PCAP試験**: Python Instituteのアソシエイトレベル認定
- 実際のプロジェクトでPythonを活用する

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
