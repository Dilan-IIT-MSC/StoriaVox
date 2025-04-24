//
//  LoadingViewModifier.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import Foundation
import SwiftUI

struct LoadingViewModifier: ViewModifier {
    @ObservedObject var loadingState: LoadingState
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if loadingState.isLoading {
                LoadingView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: loadingState.isLoading)
    }
}

extension View {
    func withLoading(loadingState: LoadingState) -> some View {
        self.modifier(LoadingViewModifier(loadingState: loadingState))
    }
}
