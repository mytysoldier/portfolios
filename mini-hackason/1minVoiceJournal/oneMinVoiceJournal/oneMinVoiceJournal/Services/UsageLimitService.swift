import Foundation

struct UsageLimitService {
    private let userDefaults = UserDefaults.standard
    private let dailyLimitKey = "oneMinVoiceJournal.dailyUsageCount"
    private let lastUsageDateKey = "oneMinVoiceJournal.lastUsageDate"
    private let maxDailyUsage = 10

    /// 今日の使用可能回数が残っているかチェック
    func canUseAPI() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = getLastUsageDate()

        // 日付が変わっていればカウントをリセット
        if lastDate != today {
            resetCount()
            return true
        }

        let currentCount = getCurrentCount()
        return currentCount < maxDailyUsage
    }

    /// 現在の使用回数を取得
    func getCurrentCount() -> Int {
        return userDefaults.integer(forKey: dailyLimitKey)
    }

    /// 残りの使用可能回数を取得
    func getRemainingCount() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = getLastUsageDate()

        // 日付が変わっていればリセット
        if lastDate != today {
            return maxDailyUsage
        }

        let currentCount = getCurrentCount()
        return max(0, maxDailyUsage - currentCount)
    }

    /// 使用回数をインクリメント
    mutating func incrementUsage() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = getLastUsageDate()

        // 日付が変わっていればリセット
        if lastDate != today {
            resetCount()
        }

        let currentCount = getCurrentCount()
        userDefaults.set(currentCount + 1, forKey: dailyLimitKey)
        userDefaults.set(today, forKey: lastUsageDateKey)
    }

    /// 最後に使用した日付を取得
    private func getLastUsageDate() -> Date {
        if let date = userDefaults.object(forKey: lastUsageDateKey) as? Date {
            return Calendar.current.startOfDay(for: date)
        }
        // 初回は過去の日付を返してリセットをトリガー
        return Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    }

    /// カウントをリセット
    private func resetCount() {
        userDefaults.set(0, forKey: dailyLimitKey)
    }
}
