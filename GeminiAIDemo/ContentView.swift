//
//  ContentView.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/4/18.
//

import SwiftUI
import GoogleGenerativeAI

enum GeminiTyp: CaseIterable, Hashable {
    case question
    case chat
}

struct ContentView: View {
    
    @State var viewModel: CustomKeyViewModel = CustomKeyViewModel()
    
    @State var selected: GeminiTyp = .question
    @State var counter: TokenCounter = TokenCounter.shared
    @StateObject var question: QuestionViewModel = QuestionViewModel()
    @StateObject var chat: ChatViewModel = ChatViewModel()
    
    @State private var isPresentedNeedKey: Bool = true
    var body: some View {
        ZStack {
            if isPresentedNeedKey {
                CustomKeyView(isPresented: $isPresentedNeedKey )
                    .environmentObject(viewModel)
            } else {
                ZStack {
                    switch selected {
                    case .question:
                        QuestionView()
                            .environmentObject(question)
                    case .chat:
                        ChatView()
                            .environmentObject(chat)
                    }
                }
                .overlay(alignment: .trailing) {
                    Button(action: {
                        selected = selected == .question ? .chat : .question
                    }, label: {
                        Image(systemName: selected == .question ? "arrow.right" : "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                    })
                    .padding()
                    .background(.white.opacity(0.3))
                    .clipShape(Circle())
                    .padding(.trailing, 10)
                    .ignoresSafeArea(.keyboard)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
