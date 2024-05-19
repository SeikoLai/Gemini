//
//  CustomKeyViewModel.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/5/19.
//

import Foundation
import Combine

final class CustomKeyViewModel: ObservableObject {
    
    @Published var APIKey: String = ""
    @Published var save: Bool = true
}
