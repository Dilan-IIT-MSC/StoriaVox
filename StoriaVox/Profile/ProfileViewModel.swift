//
//  ProfileViewModel.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-15.
//

import Foundation
import MSAL

class ProfileViewModel: ObservableObject {
    @Published var user: User?
}

extension ProfileViewModel {
    func signOut() {
        let msalClient = AuthenticationManager.shared.msalClient
        if let user = msalClient.getNativeAuthUserAccount() {
            let parameters: MSALSignoutParameters = .init()
            parameters.signoutFromBrowser = true
            msalClient.signout(with: user.account, signoutParameters: parameters) { isSignOut ,error in
                
            }
        }
    }
}
