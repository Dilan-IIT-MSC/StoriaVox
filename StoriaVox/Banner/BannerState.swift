//
//  BannerState.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-04.
//

import Foundation
import Combine
import Network

class BannerState: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let networkMonitor = NWPathMonitor()
    private var hasNetworkConnection: Bool = true
    @Published var bannerData: BannerData?
    @Published var isShowBanner: Bool = false
    
    static let shared = BannerState()
    
    init(bannerWrapper: BannerData? = nil) {
        self.bannerData = bannerWrapper
        
        networkMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.hasNetworkConnection = true
            } else {
                self?.hasNetworkConnection = false
            }
        }
        networkMonitor.start(queue: .global())
        
        NotificationCenter.default
            .publisher(for: .showBottomBanner)
            .sink(receiveValue: { [weak self] (notification) in
                if let userInfo = notification.userInfo {
                    if let bannerData: BannerData = userInfo.valueForKey("bannerData") {
                        self?.bannerData = bannerData
                        self?.isShowBanner = true
                    } else if let bannerType: Int = userInfo.valueForKey("bannerType"),
                              bannerType == BannerType.noConnection.rawValue
                                || bannerType == BannerType.noConnectionInfo.rawValue {
                        self?.checkConnection()
                    }
                }
            })
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: .hideBottomBanner)
            .sink { [weak self] _ in
                self?.isShowBanner = false
            }
            .store(in: &cancellables)
        
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func checkConnection() {
        print("checkConnection")
        if !hasNetworkConnection {
           bannerData = BannerData(
            title: nil,
            detail: "No internet connection",
            type: .noConnection,
            isAutoHide: true,
            dismissAction: {
               self.checkConnection()
            })
            isShowBanner = true
        } else {
            if bannerData?.type == .noConnection {
                isShowBanner = false
            }
        }
    }
}
