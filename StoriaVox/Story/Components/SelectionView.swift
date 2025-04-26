//
//  SelectionView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation
import SwiftUI

struct SelectionView<T: SelectableItem>: View {
    @Binding var selectedItem: T?
    var items: [T]
    var maxHeight: CGFloat = 200
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    Button(action: {
                        selectedItem = item
                    }) {
                        HStack(spacing: 12) {
                            if let image = item.displayImage {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.displayTitle)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                
                                if let description = item.displayDescription {
                                    Text(description)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                }
                            }
                            
                            Spacer()
                            
                            if let selected = selectedItem, selected.id == item.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if index < items.count - 1 {
                        Divider()
                    }
                }
            }
            .navigationTitle("Select")
        }
        .frame(maxHeight: maxHeight)
        .padding(.vertical, 4)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
