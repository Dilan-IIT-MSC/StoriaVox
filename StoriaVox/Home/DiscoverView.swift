//
//  DiscoverView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading) {
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
                                            .foregroundColor(Color.random())
                                            .background(.red)
                                            .cornerRadius(10)
                                            .offset(x: 30)
                                            
                                        Image(systemName: "microbe.circle.fill")
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(Color.random())
                                            .background(.green)
                                            .cornerRadius(10)
                                            .offset(x: 0)
                                        
                                        Image(systemName: "square.and.arrow.down.badge.clock.fill")
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(Color.random())
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
                                .background(Color.random(randomOpacity: true, opacity: 0.3))
                                .cornerRadius(10)
                                .padding(.vertical, 10)
                            }

                        }
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    DiscoverView()
}
