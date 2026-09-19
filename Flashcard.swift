import Foundation

// MARK: - Flashcard Model
struct Flashcard: Identifiable {
    let id = UUID()
    let word: String
    let pronunciation: String
    let emojis: String
    let translation: String
    let explanation: String
}