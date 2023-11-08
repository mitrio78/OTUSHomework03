//
//  MainTabView.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 08.11.2023.
//

import SwiftUI

// MARK: - MainTabView

struct MainTabView: View {

    // MARK: - Properties

    @EnvironmentObject var router: Router

    // MARK: - Body

    var body: some View {
        TabView(selection: $router.selectedTab) {
            SearchView(interactor: SearchInteractor())
                .tag(1)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            FavouritesView()
                .tag(2)
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
        } //: TabView
        .tabViewStyle(.automatic)
        .tint(.brandStandard)
        .onAppear() {
            UITabBar.appearance().barTintColor = .brandStandard
            UITabBar.appearance().unselectedItemTintColor = .brandInactive
        }
    }
}

// MARK: - Previews

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
