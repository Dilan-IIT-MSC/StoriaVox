//
//  StoryFilterConfig.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation

protocol Filterable {
    var uuid: UUID { get }
    var searchText: String { get set }
    var isFiltered: Bool { get }
    mutating func clearFilter()
}
struct StoryFilterConfig: Filterable {
    var uuid: UUID = UUID()
    var searchText: String = ""
    var isFiltered: Bool = false 
    var selectedAuthor: Author?
    var selectedCategory: Category?
    var sortOrder: SortOrder = .newest
    
    mutating func clearFilter() {
        self.isFiltered = false
        self.searchText = ""
        self.selectedAuthor = nil
        self.selectedCategory = nil
        self.sortOrder = .newest
    }
}
