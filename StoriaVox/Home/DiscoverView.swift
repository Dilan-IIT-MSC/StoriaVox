//
//  DiscoverView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                headerView()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Browse by Category")
                        
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<10) { index in
                            Button {
                                
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    ZStack(alignment: .top) {
                                        Image(systemName: "microwave")
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(Color.backgroundColors.randomElement())
                                            .background(.red)
                                            .cornerRadius(10)
                                            .offset(x: 30)
                                            
                                        Image(systemName: "microbe.circle.fill")
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(Color.backgroundColors.randomElement())
                                            .background(.green)
                                            .cornerRadius(10)
                                            .offset(x: 0)
                                        
                                        Image(systemName: "square.and.arrow.down.badge.clock.fill")
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(Color.backgroundColors.randomElement())
                                            .background(.brown)
                                            .cornerRadius(10)
                                            .offset(x: -30)
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    Text("Category Name")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundStyle(.black)
                                        .fontDesign(.rounded)
                                    
                                    
                                    
                                }
                                .frame(width: 200, height: 180)
                                .background(Color.backgroundColors.randomElement())
                                .cornerRadius(10)
                                .padding(.vertical, 10)
                            }

                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

extension DiscoverView {
    @ViewBuilder
    func headerView() -> some View {
        HStack(alignment: .center, spacing: 8) {
            ZStack {
                Circle()
                    .fill(.brown50)
                    .frame(width: 50, height: 50)
                    .shadow(radius: 1)
                
                Image(systemName: "person.fill")
                    .foregroundColor(.brown)
                    .font(.system(size: 32, weight: .bold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Dilan Anuruddha")
                    .font(.system(size: 17, weight: .medium))
                
                Text("Tell your life story")
                    .font(.system(size: 13, weight: .light))
            }
            
            Spacer()
            
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "ear.badge.waveform")
                    .resizable()
                    .foregroundStyle(.accent)
                    .frame(width: 16, height: 18)
                
                Text("32k")
                    .font(.system(size: 14, weight: .light))
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

#Preview {
    DiscoverView()
}
