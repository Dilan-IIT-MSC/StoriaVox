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
    case storyDetail(Int)
    case storyMetadata
    case storyUpload
    
    public init() {
        self = .unspecified
    }
    
    var id: UUID {
        return UUID()
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

enum AuthRoute : Equatable, Hashable {
    case verifyCode
    case resetPassword
    case forgotPassword
    case completeSignUp
}

enum ProfileRoute : Equatable, Hashable {
    case editProfile
}

