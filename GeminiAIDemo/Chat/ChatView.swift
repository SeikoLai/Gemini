//
//  ChatView.swift
//  GeminiAIDemo
//
//  Created by Sam on 2024/4/18.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: ChatViewModel
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            VStack {
                Text("chat".uppercased())
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.top)
                
                ScrollView(.vertical) {
                    ForEach(viewModel.history) { content in
                        if let role = content.role {
                            Text(content.parts.reduce("", { $0 + ($1.text ?? "") }))
                                .foregroundStyle(.white)
                                .padding()
                                .background(.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .frame(maxWidth: .infinity, alignment: role == "user" ? .trailing : .leading)
                                .padding()
                        }
                    }
                }
                .defaultScrollAnchor(isFocused ? .bottom : nil)
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(.immediately)
                
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
                                Task {
                                    await viewModel.send(viewModel.message)
                                }
                            })
                        }
                }
                
                if viewModel.isWaiting {
                    HStack {
                        AnimatableDotsView()
                            .foregroundStyle(.white.opacity(0.5))
                        Spacer()
                    }
                    .padding(.leading)
                }
                
                VStack {
                    HStack {
                        TextField(text: $viewModel.message, prompt: Text("What's news").foregroundStyle(.black.opacity(0.6))) {
                            
                        }
                        .keyboardType(.twitter)
                        .tint(.black.opacity(0.6))
                        .focused($isFocused)
                        .onChange(of: isFocused, { oldValue, newValue in
                            if newValue {
                                viewModel.message = ""
                            }
                        })
                        .foregroundStyle(.black)
                        .padding()
                        .background(.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        
                        Button(action: {
                            guard viewModel.message.isEmpty == false else { return }
                            
                            Task {
                                await viewModel.send(viewModel.message)
                            }
                        }, label: {
                            Image(systemName: "paperplane.circle.fill")
                                .resizable()
                                .scaledToFit()
                        })
                        .opacity(viewModel.message.isEmpty ? 0.3 : 0.9)
                        .frame(width: 44)
                        .tint(.white)
                    }
                    .padding([.horizontal, .bottom])
                    
                    Text("Token counts: \(TokenCounter.shared.counts)")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white.opacity(0.7))
                        .font(.caption)
                }
            }
        }
        .background(
            LinearGradient(colors: [Color(hex: "FFE259"), Color(hex: "FFA751")], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    ChatView()
        .environmentObject(ChatViewModel())
}
