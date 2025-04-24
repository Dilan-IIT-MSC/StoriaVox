//
//  LoadingState.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import Foundation
import SwiftUI

class LoadingState: ObservableObject {
    @Published var isLoading: Bool = false
    
    func startLoading() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}

