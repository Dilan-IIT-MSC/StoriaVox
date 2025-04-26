//
//  StoryListViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation

class StoryListViewModel: ObservableObject {
    @Published var filterConfig: StoryFilterConfig = .init()
    @Published private var storyList: [StoryListItem] = []
    var filteredStoryList: [StoryListItem] {
        if filterConfig.searchText.isEmpty {
            return storyList
        } else {
            return storyList.filter({ $0.title.lowercased().contains(filterConfig.searchText)})
        }
    }
    
    internal func getStoryList() {
        StoryService.shared.getStories(
            authorId: filterConfig.selectedAuthor?.id,
            categoryId: filterConfig.selectedCategory?.id,
            order: filterConfig.sortOrder.order
        ) { response in
            switch response {
            case .success(let storyData):
                self.storyList = storyData.stories
            case .failure(let error):
                BannerHandler.shared.showErrorBanner(title: "Error", message: error.localizedDescription, isAutoHide: true)
            }
        }
    }
}
