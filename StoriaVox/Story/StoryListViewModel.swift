//
//  StoryListViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation

class StoryListViewModel: ObservableObject {
    @Published var authors: [Author] = []
    @Published var categories: [Category] = []
    @Published var filterConfig: StoryFilterConfig = .init()
    @Published private var storyList: [StoryListItem] = []
    func filteredStoryList() -> [StoryListItem] {
        if filterConfig.searchText.isEmpty {
            return storyList
        } else {
            return storyList.filter({ $0.title.lowercased().contains(self.filterConfig.searchText.lowercased())})
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
                self.getAuthors()
            case .failure(let error):
                BannerHandler.shared.showErrorBanner(title: "Error", message: error.localizedDescription, isAutoHide: true)
            }
        }
    }
    
    private func getAuthors() {
        UserService.shared.getStoryTellers { response in
            switch response {
            case .success(let authorData):
                self.authors = authorData.authors
                self.getCategories()
            case .failure(let error):
                BannerHandler.shared.showErrorBanner(title: "Error", message: error.localizedDescription, isAutoHide: true)
            }
        }
    }
    
    private func getCategories() {
        CategoryService.shared.getCategories { response in
            switch response {
            case .success(let categoryData):
                self.categories = categoryData.categories.map({ $0.category })
                BannerHandler.shared.showSuccessBanner(title: "Success", message: "Story list fetched successfully.", isAutoHide: true)
            case .failure(let error):
                BannerHandler.shared.showErrorBanner(title: "Error", message: error.localizedDescription, isAutoHide: true)
            }
        }
    }
}
