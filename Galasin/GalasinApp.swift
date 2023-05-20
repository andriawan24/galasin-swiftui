//
//  GalasinApp.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SwiftUI

@main
struct GalasinApp: App {
    
    @StateObject private var gameManager = GameManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(gameManager: gameManager)
        }
    }
}
