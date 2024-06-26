//
//  CustomKeyViewModel.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/5/19.
//

import Foundation
import Combine
import KeychainSwift

final class CustomKeyViewModel: ObservableObject {
    
    @Published var APIKey: String = ""
    @Published var save: Bool = true
    
    private let prefixKey: String = "GeminiAI-APIKey-"
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        $save
             .subscribe(on: DispatchQueue.global())
             .sink { isSave in
                 let keychain = KeychainSwift()
                 
                 if isSave {
                     keychain.set(self.APIKey, forKey: "\(self.prefixKey)\(self.APIKey)")
                 } else {
                     keychain.delete("\(self.prefixKey)\(self.APIKey)")
                 }
             }
             .store(in: &cancellable)
    }
}
