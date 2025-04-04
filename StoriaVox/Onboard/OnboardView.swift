//
//  OnboardView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-12.
//

import SwiftUI

struct OnboardView: View {
    @EnvironmentObject internal var appSettings: AppSettings
    @EnvironmentObject private var bannerState: BannerState
    @EnvironmentObject var loadingState: LoadingState
    @State private var selectedIndex: Int = 0

    var body: some View {
        ZStack {
            Color.accentColor.opacity(0.1)
            
            TabView(selection: $selectedIndex) {
                ForEach(0..<intros.count, id: \.self) { index in
                    VStack {
                        intros[index].image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.top, 50)
                        
                        Text(intros[index].title)
                            .font(.title)
                            .fontDesign(.rounded)
                            .fontWeight(.medium)
                            .padding(.top, 24)
                            
                        Text(intros[index].description)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .fontDesign(.rounded)
                            .kerning(0.2)
                            .padding(.top, 24)
                        
                        Spacer()
                            
                        Button {
                            withAnimation {
                                if selectedIndex == intros.count - 1 {
                                    UserDefaultsManager.shared.isOnboardTourDone = true
                                    appSettings.mainRoute = .signUp
                                } else {
                                    selectedIndex += 1
                                }
                            }
                        } label: {
                            HStack  {
                                if selectedIndex == intros.count - 1 {
                                    Text("Let's Start!")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .fontDesign(.rounded)
                                } else {
                                    Image(systemName: "chevron.right")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .fontDesign(.rounded)
                                }
                                
                                
                            }
                            .padding()
                            .frame(width: selectedIndex == intros.count - 1 ? 200: 60, height: 60)
                            .background(Color.accentColor)
                            .cornerRadius(30)
                            
                        }
                        
                        navBar()
                    }
                    .padding()
                    .ignoresSafeArea(edges: .top)
                }
            }
            .tabViewStyle(.page)
            
            NavigationLink {
                
            } label: {
                
            }

        }
        .ignoresSafeArea()
        .banner(isPresent: $bannerState.isShowBanner)
    }
    
    @ViewBuilder
    func navBar() -> some View {
        HStack {
            if selectedIndex > 0 {
                Button {
                    selectedIndex -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.secondary)
                        .font(.body)
                }
            }
            
            Spacer()
            
            if selectedIndex < intros.count - 1 {
                Button {
                    selectedIndex = intros.count - 1
                } label: {
                    Text("Skip")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }

        }
    }
}

#Preview {
    OnboardView()
}
