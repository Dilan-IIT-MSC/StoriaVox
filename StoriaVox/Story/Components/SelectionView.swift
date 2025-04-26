//
//  SelectionView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation
import SwiftUI

struct SelectionView<T: SelectableItem>: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedItem: T?
    var items: [T]
    
    var body: some View {
        ZStack {
            Color.background
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        Button(action: {
                            selectedItem = item
                            dismiss()
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
                                            .lineLimit(2)
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
                        .modifier(CardView())
                    }
                    
                    Spacer()
                }
                .navigationTitle("Select")
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 36)
            }
            .padding(.vertical, 4)
        }
    }
}
