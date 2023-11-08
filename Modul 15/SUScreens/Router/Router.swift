//
//  Router.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 08.11.2023.
//

import SwiftUI

// MARK: - Router

final class Router: ObservableObject {
    @Published var listPath: NavigationPath = .init()
    @Published var selectedTab: Int = 1
}
