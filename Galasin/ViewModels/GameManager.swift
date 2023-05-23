//
//  GameManager.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SpriteKit
import SwiftUI

class GameManager: NSObject, ObservableObject {
    
    @Published var inGame: Bool = false
    @Published var gameType: GameType = .singlePlayer
    @Published var score: Int = 0
    @Published var enemyScore: Int = 0
    @Published var playersLeft: Int = 5
    @Published var gameFinished = false
    
    var chosenPlayer: AttackerNode? = nil
    
    func startGame(type: GameType) {
        gameType = type
        inGame = true
    }
    
    func choosePlayer(player: AttackerNode) {
        self.chosenPlayer = player
    }
    
    func moveAttacker(direction: GamePadDirection) {
        chosenPlayer?.move(direction: direction)
    }
    
    func increaseScore() {
        score += 1
        reducePlayer()
    }
    
    func reducePlayer() {
        playersLeft -= 1
        if playersLeft == 0 {
            gameFinished = true
        }
    }
    
    func resetGame() {
        score = 0
        playersLeft = 5
        inGame = false
    }
}

enum GameType {
    case singlePlayer, multiPlayer
}
