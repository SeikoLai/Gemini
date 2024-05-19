//
//  CustomKey.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/5/19.
//

import SwiftUI

struct CustomKey: View {
    @State private var viewModel: CustomKeyViewModel = CustomKeyViewModel()
    
    var body: some View {

        ZStack {
         
            LinearGradient(colors: [Color(hex: "1488CC"), Color(hex: "2B32B2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            TextField("Enter your Gemini API key", text: $viewModel.APIKey)
                .foregroundStyle(Color(.label))
                .padding()
                .background(Color(.systemBackground))
        }
    }
}
#if DEBUG
struct EnterKeyView_Previews: PreviewProvider {
    static var previews: some View {
        CustomKey()
    }
}
#endif
