//
//  StringExtensions.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-05.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func formattedTime() -> String {
        return "\(self) min"
    }
}
