import SwiftUI

struct ContentView: View {
    // Our Data
    let flashcards = [
        Flashcard(word: "Dumela", pronunciation: "(doo-MEH-lah)", emojis: "🚪 + 🍈", translation: "Hello", explanation: "Imagine opening a DOOR to find a MELON."),
        Flashcard(word: "Ke a leboha", pronunciation: "(keh-ah-leh-BO-hah)", emojis: "🛶 + 🎀", translation: "Thank you", explanation: "Imagine a CANOE tied with a ribbon (BO-hah)."),
        Flashcard(word: "Tsamaya hantle", pronunciation: "(tsa-MAH-yah hahn-TLEH)", emojis: "🚶 + 👋", translation: "Goodbye (Go well)", explanation: "Walking away and waving gracefully.")
    ]
    
    // State to track cards and swipe movements
    @State private var currentIndex = 0
    @State private var offset: CGSize = .zero
    @State private var color: Color = .clear
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // MARK: - THE FLASHCARD
                ZStack {
                    if !flashcards.isEmpty {
                        let currentCard = flashcards[currentIndex]
                        
                        VStack(spacing: 20) {
                            Text(currentCard.word)
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text(currentCard.pronunciation)
                                .font(.title3)
                                .foregroundColor(.secondary)
                            
                            Text(currentCard.emojis)
                                .font(.system(size: 70))
                                .padding(.vertical, 10)
                            
                            Text(currentCard.translation)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(currentCard.explanation)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                        .padding(40)
                        .background(Color(UIColor.secondarySystemGroupedBackground))
                        .cornerRadius(25)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        // This overlay changes color slightly as you swipe!
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(color.opacity(0.2))
                        )
                        .padding(.horizontal, 20)
                        // ANIMATION MODIFIERS
                        .offset(x: offset.width, y: 0)
                        .rotationEffect(.degrees(Double(offset.width / 20)))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    offset = gesture.translation
                                    withAnimation {
                                        changeColor(width: offset.width)
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        swipeCard(width: offset.width)
                                    }
                                }
                        )
                    }
                }
                
                // MARK: - ACTION BUTTONS
                HStack(spacing: 40) {
                    Button(action: {
                        withAnimation(.spring()) {
                            swipeCard(width: -200) // Simulate left swipe
                        }
                    }) {
                        VStack {
                            Image(systemName: "arrow.uturn.backward.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                            Text("Again")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.red)
                        }
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            swipeCard(width: 200) // Simulate right swipe
                        }
                    }) {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.green)
                            Text("Got It")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.green)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - SWIPE LOGIC
    func swipeCard(width: CGFloat) {
        if width > 100 {
            // Swiped Right - "Got It"
            nextCard()
        } else if width < -100 {
            // Swiped Left - "Again"
            nextCard()
        } else {
            // Reset position if not swiped far enough
            offset = .zero
            color = .clear
        }
    }
    
    func nextCard() {
        if currentIndex < flashcards.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0 // Loop back
        }
        offset = .zero
        color = .clear
    }
    
    func changeColor(width: CGFloat) {
        if width > 0 {
            color = .green
        } else if width < 0 {
            color = .red
        } else {
            color = .clear
        }
    }
}

#Preview {
    ContentView()
}