# Audio Waveform Gift

音声ファイルを"ギフト"として見せるSwiftUIデモアプリ。音声を選ぶと、ギフトボックスの演出と波形のきらめきが再生され、最後にシステムの共有シートでファイルを共有できます。

## 特徴
- 音声ファイル選択（UTType.audio）と共有用の一時コピー
- 波形カードのアニメーション（スパークル・リボン）
- ギフトボックスの落下/開封演出とフルスクリーンのスパークル
- アニメーション後に自動で共有シートを表示

## 動作環境
- Xcode 15+
- iOS 17+

## 実行方法
1. Xcodeで`audioWaveformGift.xcodeproj`を開く。
2. iOSシミュレータまたは実機を選択。
3. ビルドして実行。

## 使い方
1. 「音声ファイルを選ぶ」をタップして音声を選択。
2. ギフト演出と波形アニメーションを確認。
3. 共有シートが自動で表示されるので共有または閉じる。

## 構成
- `audioWaveformGift/ContentView.swift` メインUIとアニメーション進行
- `audioWaveformGift/WaveformGiftView.swift` 波形カードとスパークル
- `audioWaveformGift/GiftBoxAnimationViews.swift` ギフトボックスとオーバーレイ
- `audioWaveformGift/ShareSheet.swift` ドキュメントピッカーと共有シート
- `audioWaveformGift/audioWaveformGiftApp.swift` アプリのエントリ

## 補足
- 選択した音声ファイルは共有用に一時領域へコピーします。
- アニメーションは`TimelineView(.animation)`とフェーズ状態で制御しています。
