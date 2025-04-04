//
//  BannerHandler.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import Foundation

class BannerHandler: NSObject {
    
    static let shared = BannerHandler()
    private override init() { }
    
    private func show(bannerData: BannerData) {
        NotificationCenter.default.post(name: .showBottomBanner, object: nil, userInfo: ["bannerData": bannerData])
    }
    
    func hide() {
        NotificationCenter.default.post(name: .hideBottomBanner, object: nil)
    }
    
    func showSuccessBanner(title: String?, message: String, isAutoHide: Bool, onDismiss: (() -> Void)? = nil) {
        self.show(bannerData: BannerData(
                title: title,
                detail: message,
                type: .success,
                isAutoHide: isAutoHide,
                dismissAction: onDismiss))
    }
    
    func showErrorBanner(title: String?, message: String, isAutoHide: Bool, onDismiss: (() -> Void)? = nil) {
        self.show(bannerData: BannerData(
            title: title,
            detail: message,
            type: .error,
            isAutoHide: isAutoHide,
            dismissAction: onDismiss))
    }
    
    func showInfoErrorBanner(
        title: String?,
        message: String,
        isAutoHide: Bool,
        onDismiss: (() -> Void)? = nil
    ) {
        self.show(bannerData: BannerData(
            title: title,
            detail: message,
            type: .infoError,
            isAutoHide: isAutoHide,
            dismissAction: onDismiss))
    }
}
