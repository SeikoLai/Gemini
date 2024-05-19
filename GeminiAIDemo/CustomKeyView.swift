//
//  CustomKeyView.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/5/19.
//

import SwiftUI

struct CustomKeyView: View {
    @EnvironmentObject var viewModel: CustomKeyViewModel
    
    var body: some View {

        NavigationStack {
                        
            ZStack {
                LinearGradient(colors: [Color(hex: "1488CC"), Color(hex: "2B32B2")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack {
                    NavigationLink("Go to get API key".capitalized) {
                        SafariWebView(url: URL(string: "https://aistudio.google.com")!)
                    }
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                    .padding()
                    
                    Spacer()
                    
                    TextField("Enter your Gemini API key".capitalized, text: $viewModel.APIKey)
                        .font(.system(.headline, design: .monospaced))
                        .foregroundStyle(Color(.gray))
                        .padding()
                        .background(.white)
                    
                    Toggle("Safely saved to your keychain for next time".capitalized, isOn: $viewModel.save)
                        .font(.system(.subheadline, design: .monospaced))
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(Color(.white))
                        .padding()
                    
                    Spacer()
                }
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
#if DEBUG
struct EnterKeyView_Previews: PreviewProvider {
    static var previews: some View {
        CustomKeyView()
            .environmentObject(CustomKeyViewModel())
    }
}
#endif
