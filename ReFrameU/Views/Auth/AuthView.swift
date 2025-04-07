//
//  AuthView.swift
//  ReFrameU
//
//  Created by Vaishnavi Mahajan on 4/3/25.
//


import SwiftUI

struct AuthView: View {
    @AppStorage("isAuthenticated") private var isAuthenticated = false

    var body: some View {
        if isAuthenticated {
            MainTabView()
        } else {
            AuthContainerView(isAuthenticated: $isAuthenticated)
        }
    }
}
