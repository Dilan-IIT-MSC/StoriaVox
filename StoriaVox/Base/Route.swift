//
//  Route.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-13.
//
import Foundation

enum Route: Equatable, Hashable {
    case unspecified
    case home
    case login
    case profile
    case signUp
    case recording
    case listening
    case allCategories
    case storyListing
    case storyMetadata
    case storyUpload
    
    public init() {
        self = .unspecified
    }
}

enum MainRoute: Equatable, Hashable {
    case unspecified
    case home
    case login
    case signUp
    
    public init() {
        self = .unspecified
    }
}


