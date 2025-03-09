//
//  ContentView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-02-15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.accentColor
            
            VStack {
                HStack {
                    Spacer()
                    
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Hello, world!")
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
            }
            .background(Color.white)
            .padding(.top, 100)
            .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
