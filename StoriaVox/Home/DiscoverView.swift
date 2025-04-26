//
//  DiscoverView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-20.
//

import SwiftUI

struct DiscoverView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var appSettings: AppSettings
    @StateObject var viewModel = DiscoverViewModel()
    
    var body: some View {
        NavigationStack(path: $appSettings.homePaths) {
            ZStack(alignment: .top) {
                Color.background
                
                VStack(alignment: .leading) {
                    headerView()
                    
                    ScrollView(showsIndicators: false) {
                        trendingSection()
                        
                        Divider()
                        
                        if viewModel.dashboardData?.recentlyListened.count ?? 0 > 0 {
                            recentlyListenedSection()
                            
                            Divider()
                        }

                        categoriesSection()
                        
                    }
                    .refreshable {
                        viewModel.getDashboardData()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, safeAreaInsets.top)

            }
            .ignoresSafeArea(edges: .top)
            .onAppear {
                viewModel.getDashboardData()
            }
        }
    }
}

#Preview {
    DiscoverView().environmentObject(AppSettings())
}
