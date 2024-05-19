//
//  QuestionView.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/4/18.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var viewModel: QuestionViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack {
            Text("Ask question".uppercased())
                .font(.system(.largeTitle, design: .monospaced))
                .bold()
                .foregroundStyle(.white)
                .padding(.top)
            
            TextField(text: $viewModel.prompt, prompt: 
                        Text("Enter your question.")
                .foregroundStyle(.black.opacity(0.5))
                .font(.system(.subheadline, design: .monospaced))) {
                
            }
            .overlay(alignment: .trailing) {
                Button {
                    viewModel.prompt = ""
                } label: {
                    Image(systemName: "x.circle")
                }
                .disabled(viewModel.prompt.isEmpty || viewModel.isPrompt)
            }
            .disabled(viewModel.isPrompt)
            .tint(.white)
            .foregroundStyle(.white)
            .padding()
            .background(.white.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .padding([.horizontal, .bottom])
            .focused($isFocused)
            .onSubmit {
                guard viewModel.prompt.isEmpty == false else { return }
                viewModel.submit()
            }
            .onChange(of: isFocused) { oldValue, newValue in
                if newValue && viewModel.prompt.isEmpty == false {
                    viewModel.answer = ""
                }
            }
            .scrollContentBackground(.hidden)
            
            ScrollView {
                Text(viewModel.answer)
                    .foregroundStyle(.white)
                    .padding()
                    .font(.system(.callout, design: .monospaced))
                    .background(.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .frame(maxHeight: .infinity, alignment: .leading)
                    .padding(.horizontal, 5)
            }
            if viewModel.errorMessage.isEmpty == false {
                Text(viewModel.errorMessage)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.opacity(0.6))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            viewModel.errorMessage = ""
                            viewModel.submit()
                        })
                    }
            }
            Button(action: {
                viewModel.submit()
            }, label: {
                Label("Submit", systemImage: "paperplane.circle.fill")
                    .font(.system(.title, design: .monospaced))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
            })
            .disabled(viewModel.prompt.isEmpty || viewModel.isPrompt)
            .padding([.horizontal, .bottom])
            
            Text("Token counts: \(TokenCounter.shared.counts)")
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white.opacity(0.7))
                .font(.system(.footnote, design: .monospaced))
        }
        .background(
            LinearGradient(colors: [Color(hex: "1D976C"), Color(hex: "93F9B9")], startPoint: .topLeading, endPoint: .bottomTrailing)
                .opacity(0.8)
                .ignoresSafeArea()
        )
        .scrollDismissesKeyboard(.immediately)
        .ignoresSafeArea(.keyboard)
        .overlay {
            Image(systemName: "rainbow")
                .resizable()
                .symbolEffect(.variableColor.iterative, options: .repeating,  value: viewModel.isPrompt)
                .scaledToFit()
                .foregroundColor(.white.opacity(0.9))
                .frame(width: 64)
                .opacity(viewModel.isPrompt ? 1.0 : 0.0)
                .allowsHitTesting(false)
        }
    }
}

#Preview {
    QuestionView()
        .environmentObject(QuestionViewModel())
}
