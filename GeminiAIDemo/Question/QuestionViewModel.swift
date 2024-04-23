//
//  QuestionViewModel.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/4/19.
//

import Foundation
import GoogleGenerativeAI

class QuestionViewModel: ObservableObject {
    let model: GenerativeModel = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @Published var answer: String = ""
    @Published var prompt: String = ""
    @Published var isPrompt: Bool = false
    @Published var errorMessage: String = ""
    
    func submit() {
        guard self.isPrompt == false else { return }
        guard self.prompt.isEmpty == false else { return }
        self.answer = ""
        self.isPrompt.toggle()
        
        Task {
            do {
                let response = try await model.generateContent(self.prompt)
                TokenCounter.shared.counts += try await model.countTokens(self.prompt).totalTokens
                DispatchQueue.main.async {
                    self.isPrompt.toggle()
                    if let text = response.text {
                        self.answer = text
                    }
                }
            } catch {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isPrompt.toggle()
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
