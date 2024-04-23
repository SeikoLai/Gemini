//
//  ChatViewModel.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/4/19.
//

import Foundation
import GoogleGenerativeAI

class ChatViewModel: ObservableObject {
    let model: GenerativeModel = GenerativeModel(name: "gemini-pro",
                                                 apiKey: APIKey.default,
                                                 generationConfig: GenerationConfig())
    @Published var history: [ModelContent] = []
    @Published var message: String = ""
    @Published var errorMessage: String = ""
    @Published var isWaiting: Bool = false
    
    func send(_ message: String) async {
        guard message.isEmpty == false else { return }
        Task {
            // Initialize the chat
            let chat = model.startChat(history: self.history)
            DispatchQueue.main.async {
                self.history.append(ModelContent(role: "user", parts: message))
                self.isWaiting.toggle()
            }
            
            do {
                let response = try await chat.sendMessage(message)
                TokenCounter.shared.counts += try await model.countTokens(history).totalTokens
                if let text = response.text {
                    DispatchQueue.main.async {
                        self.history.append(ModelContent(role: "model", parts: text))
                        self.isWaiting = false
                        self.message = ""
                    }
                }
            } catch {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isWaiting = false
                }
            }
        }
    }
}

extension ModelContent: Identifiable {
    public var id: UUID {
        return UUID()
    }
}
