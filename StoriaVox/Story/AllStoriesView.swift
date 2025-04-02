//
//  AllStoriesView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-02.
//

import SwiftUI

struct AllStoriesView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var searchText: String = ""
    @State private var showFilters: Bool = false
    @State private var selectedFilter: StoryFilter = .all
    
    enum StoryFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case trending = "Trending"
        case new = "New"
        case popular = "Popular"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
            ZStack {
                Color.background
                
                VStack(alignment: .leading, spacing: 0) {
                    // Search and filter bar
                    searchAndFilterBar()
                    
                    if showFilters {
                        filterOptionsView()
                    }
                    
                    // Stories list
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 16) {
                            ForEach(0..<15) { index in
                                StoryListItemView()
                            }
                        }
                        .padding(.top, 16)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, safeAreaInsets.top + 36)
            }
            .ignoresSafeArea()
            .navigationTitle("All Stories")
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension AllStoriesView {
    @ViewBuilder
    func searchAndFilterBar() -> some View {
        HStack(spacing: 12) {
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search stories", text: $searchText)
                    .font(.system(size: 16))
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Filter button
            Button(action: {
                withAnimation {
                    showFilters.toggle()
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 14))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Color.accent.opacity(0.1))
                .foregroundColor(.accent)
                .cornerRadius(10)
            }
        }
        .padding(.top, 16)
    }
    
    @ViewBuilder
    func filterOptionsView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Filter by:")
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(StoryFilter.allCases) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter.rawValue)
                                .font(.system(size: 14, weight: selectedFilter == filter ? .semibold : .regular))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedFilter == filter ? Color.accent : Color.gray.opacity(0.1))
                                .foregroundColor(selectedFilter == filter ? .white : .primary)
                                .cornerRadius(16)
                        }
                    }
                }
            }
            .padding(.bottom, 8)
            
            Divider()
        }
    }
}

struct StoryListItemView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 90, height: 90)
                    .cornerRadius(8)
                
                AsyncImage(url: URL(string: "https://picsum.photos/230/128")) { image in
                    image.resizable()
                } placeholder: {
                    Color.backgroundColors.randomElement() ?? .gray
                }
                .frame(width: 90, height: 90)
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("The Great Adventure of Thor")
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(2)
                
                Text("By Jane Smith")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    // Category pill
                    Text("Fantasy")
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(12)
                    
                    // Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                        
                        Text("12 min")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.secondary)
                    
                    // Listens
                    HStack(spacing: 4) {
                        Image(systemName: "ear.fill")
                            .font(.system(size: 12))
                        
                        Text("3.2k")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.top, 4)
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
        .modifier(CardView())
    }
}


#Preview {
    AllStoriesView().environmentObject(AppSettings())
}
