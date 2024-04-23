//
//  TokenCounter.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/4/22.
//

import Foundation
import Combine

final class TokenCounter: ObservableObject {
    
    private static let countsKey: String = "com.gemini.tokens.counts"
    
    static let shared: TokenCounter = TokenCounter()
    
    @Published var counts: Int = 0
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        self.counts = UserDefaults.standard.integer(forKey: TokenCounter.countsKey)
        
        $counts
            .sink {
                UserDefaults.standard.setValue($0, forKey: TokenCounter.countsKey)
            }
            .store(in: &cancellable)
    }
}
