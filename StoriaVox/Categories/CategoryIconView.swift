//
//  CategoryIconView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-31.
//

import SwiftUI

struct CategoryIconView: View {
    var icon: Image
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.lightGreen50)
                .stroke(.border, lineWidth: 1)
                .frame(width: 30, height: 30, alignment: .center)
                .shadow(radius: 1)
            
            icon
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24, alignment: .center)
            
        }
    }
}

#Preview {
    CategoryIconView(icon: .init(.love))
}
