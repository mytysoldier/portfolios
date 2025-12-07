import Foundation

enum EmotionEmoji {
    static func emoji(for emotion: String) -> String {
        switch emotion {
        case "Happy": return "😃"
        case "Calm": return "😌"
        case "Neutral": return "😐"
        case "Sad": return "😔"
        case "Angry": return "😡"
        case "Hurt": return "😢"
        case "Overwhelmed": return "😵‍💫"
        default: return "🙂"
        }
    }
}
