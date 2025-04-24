//
//  BindingExtensions.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-01.
//

import Foundation
import SwiftUI

public extension Binding where Value == String {
    func charcterLimit(_ upto: Int, _ completion: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(get: { wrappedValue },
                set: { newValue in
            if newValue.count > upto {
                self.wrappedValue = String(newValue.prefix(upto))
                completion(self.wrappedValue)
            } else {
                self.wrappedValue = newValue
                completion(self.wrappedValue)
            }
        })
    }
}
