//
//  StoryFilterView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation
import SwiftUI

struct StoryFilterView: View {
    @State private var path: [String] = []
    @Binding var filterConfig: StoryFilterConfig
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.background
                
                VStack(alignment: .leading, spacing: 16) {
                    FilterDropdownView<Author>(title: "Author", placeholder: "Select Author", value: $filterConfig.selectedAuthor) {
                        path.append("Author")
                    }
                    
                    FilterDropdownView<Author>(title: "Category", placeholder: "Select Category", value: $filterConfig.selectedAuthor) {
                        path.append("Category")
                    }

                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            
                        }
                    }) {
                        Text("Apply Filters")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
                .padding(16)
                .navigationTitle("Select Filters")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) { item in
                    switch item {
                    case "Author":
                        SelectionView<Author>(selectedItem: $filterConfig.selectedAuthor, items: [])
                    case "Category":
                        SelectionView<Category>(selectedItem: $filterConfig.selectedCategory, items: [])
                    default: Text("Unknown")
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
