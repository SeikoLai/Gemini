//
//  AnimatableDotsView.swift
//  DotsAnimatingDemo
//
//  Created by Sam on 2024/4/22.
//

import SwiftUI

struct AnimatableDotsView: View {
    @State private var current: Int = -1
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3) { index in
                Text("●")
                    .offset(y: current == index ? -5 : 0)
            }
        }
        .onReceive(Timer.publish(every: 0.2, on: .main, in: .common).autoconnect(), perform: { _ in
            current += 1
            current = current > 3 ? 0 : current
        })
    }
}

#Preview {
    AnimatableDotsView()
}
