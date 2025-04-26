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
    @StateObject var viewModel: StoryListViewModel = .init()
    @State private var showFilters: Bool = false
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack(alignment: .leading, spacing: 0) {
                Section {
                    HStack(spacing: 8) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Search stories", text: $viewModel.filterConfig.searchText)
                                .font(.system(size: 16))
                            
                            if !viewModel.filterConfig.searchText.isEmpty {
                                Button(action: {
                                    viewModel.filterConfig.searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        
                        Button(action: {
                            withAnimation {
                                showFilters.toggle()
                            }
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 14))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(Color.accent.opacity(showFilters ? 0.3 : 0.1))
                            .foregroundColor(.accent)
                            .cornerRadius(8)
                        }
                        
                        SortMenuButton(selectedSort: $viewModel.filterConfig.sortOrder) {
                            viewModel.getStoryList()
                        }
                    }
                    .padding(.top, 16)
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredStoryList(), id: \.id) { story in
                            StoryListItemView(story: story)
                                .id(story.id)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
                .refreshable {
                    viewModel.getStoryList()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, safeAreaInsets.top + 36)
        }
        .ignoresSafeArea()
        .navigationTitle("All Stories")
        .navigationBarTitleDisplayMode(.inline)
        .popover(isPresented: $showFilters) {
            StoryFilterView(filterConfig: $viewModel.filterConfig, authors: viewModel.authors, categories: viewModel.categories) {
                viewModel.getStoryList()
            }
        }
        .onAppear {
            viewModel.getStoryList()
        }
    }
}

#Preview {
    AllStoriesView().environmentObject(AppSettings())
}
