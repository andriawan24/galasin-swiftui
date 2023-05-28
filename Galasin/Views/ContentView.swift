//
//  ContentView.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var gameManager: GameManager
    @State private var showDialog = false
    
    var body: some View {
        ZStack {
            if gameManager.inGame {
                GameView(gameManager: gameManager)
            } else {
                HomePage(gameManager: gameManager)
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            gameManager.authenticateUser()
        }
    }
}

struct ContentViewIPhone_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameManager: GameManager())
    }
}

struct ContentViewIPhoneDark_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameManager: GameManager())
            .preferredColorScheme(.dark)
    }
}

struct ContentViewIPad_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(gameManager: GameManager())
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}
