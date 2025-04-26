//
//  SortMenuButton.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import SwiftUI

struct SortMenuButton: View {
    @State private var showSortOptions: Bool = false
    @Binding var selectedSort: SortOrder
    var onDismiss: (() -> Void)?
    
    var body: some View {
        Menu {
            ForEach(SortOrder.allCases) { option in
                Button(action: {
                    selectedSort = option
                    onDismiss?()
                }) {
                    Label(option.rawValue, systemImage: option.systemImage)
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: selectedSort.systemImage)
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.accent.opacity(0.1))
            .foregroundColor(.accent)
            .cornerRadius(8)
        }
    }
}

enum SortOrder: String, CaseIterable, Identifiable {
    case newest = "Newest"
    case oldest = "Oldest"
    
    var id: String { self.rawValue }
    
    var systemImage: String {
        switch self {
        case .newest: return "arrow.down"
        case .oldest: return "arrow.up"
        }
    }
    
    var order: String {
        switch self {
        case .newest: return "ascending"
        case .oldest: return "descending"
        }
    }
}

#Preview {
    SortMenuButton(selectedSort: .constant(.newest))
}
