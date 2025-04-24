//
//  BannerModifier.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import Foundation
import SwiftUI

struct BannerModifier: ViewModifier {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var bannerState: BannerState
    @Binding var isPresent: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let bannerWrapper = bannerState.bannerData, bannerWrapper.type != .none && isPresent {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                    
                    HStack(alignment: .top, spacing: 16) {
                        icon(for: bannerWrapper.type)
                            .frame(width: 16, height: 16, alignment: .center)
                        
                        HStack(alignment: .center, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                if let title = bannerWrapper.title {
                                    Text(title)
                                        .font(.system(size: 14, weight: .semibold))
                                        .lineLimit(1)
                                }
                                
                                if !bannerWrapper.detail.isEmpty {
                                    Text(bannerWrapper.detail)
                                        .font(.system(size: 14))
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            
                            Spacer()
                        }
                        
                        if !(bannerWrapper.isAutoHide ?? true) {
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    self.isPresent = false
                                    bannerWrapper.dismissAction?()
                                }
                            }, label: {
                                buttonView(for: bannerWrapper.type)
                            })
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, safeAreaInsets.bottom > 0 ? safeAreaInsets.bottom + 8 : 16)
                    .background(bannerWrapper.type.backgroundColor)
                    .cornerRadius(4, corners: [.topLeft, .topRight])
                }
                .foregroundStyle(Color.white)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.isPresent = false
                    }
                }.onChange(of: bannerState.bannerData, perform: { bannerState in
                    if bannerState?.isAutoHide ?? true {
                        self.hide()
                    }
                })
                .onAppear(perform: {
                    if bannerWrapper.isAutoHide ?? true {
                        self.hide()
                    }
                })
            }
        }
    }
    
    @ViewBuilder
    private func icon(for type: BannerType) -> some View {
        switch type {
        case .error, .infoError, .noConnectionInfo:
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 16, weight: .medium))
        case .success:
            Image(systemName: "checkmark")
                .font(.system(size: 16, weight: .medium))
        case .progress:
            CircularProgress()
        case .noConnection, .none, .info:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func buttonView(for type: BannerType) -> some View {
        if let text = type.buttonText {
            Text(text)
                .font(.system(size: 14, weight: .medium))
        } else {
            Image(systemName: "xmark")
                .font(.system(size: 18, weight: .medium))
        }
    }
    
    private func hide() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut) {
                self.isPresent = false
            }
        }
    }
}

extension View {
    func banner(isPresent: Binding<Bool>) -> some View {
        self.modifier(BannerModifier(isPresent: isPresent))
    }
}
