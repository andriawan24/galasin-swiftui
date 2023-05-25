//
//  GameManager.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 20/05/23.
//

import SpriteKit
import SwiftUI
import GameKit
import Foundation

class GameManager: NSObject, ObservableObject {
    @Published var inGame: Bool = false
    @Published var gameType: GameType = .singlePlayer
    @Published var score: Int = 0
    @Published var enemyscore: Int = 0
    @Published var playersLeft: Int = 5
    @Published var gameFinished = false
    @Published var authStatus: PlayerAuthState = .authenticating
    
    var chosenPlayer: AttackerNode? = nil
    var localPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    var currentMatch: GKMatch?
    var currentTeam: TeamType?
    var playerUUIDKey = UUID().uuidString
    
    // For Showing GameKit Page
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { [self] viewController, error in
            if let viewController = viewController {
                rootViewController?.present(viewController, animated: true)
                return
            }
            
            if let error = error {
                authStatus = .error
                print("Error is \(error)")
                return
            }
            
            if localPlayer.isAuthenticated {
                if localPlayer.isMultiplayerGamingRestricted {
                    authStatus = .restricted
                } else {
                    authStatus = .authenticated
                }
            } else {
                authStatus = .unauthenticated
            }
        }
    }
    
    func startGame(type: GameType) {
        gameType = type
        if gameType == .multiPlayer {
            let request = GKMatchRequest()
            request.minPlayers = 2
            request.maxPlayers = 2
            
            let matchMakingViewController = GKMatchmakerViewController(matchRequest: request)
            matchMakingViewController?.matchmakerDelegate = self
            rootViewController?.present(matchMakingViewController!, animated: true)
        } else {
            enterMatch()
        }
    }
    
    private func enterMatch(match: GKMatch? = nil) {
        inGame = true
        if let match = match {
            currentMatch = match
            currentMatch?.delegate = self
            otherPlayer = match.players.first
            send("began:\(playerUUIDKey)")
        }
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
        enemyscore = 0
        chosenPlayer = nil
        playersLeft = 5
        inGame = false
        currentMatch?.disconnect()
        currentMatch?.delegate = nil
        currentMatch = nil
    }
    
    private func handleMessage(_ message: String) {
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        
        let parameter = String(messageSplit.last ?? "")
        
        switch messagePrefix {
        case "began":
            if playerUUIDKey == parameter {
                playerUUIDKey = UUID().uuidString
                send("began:\(playerUUIDKey)")
                break
            }
            
            print("Currently turn: \(playerUUIDKey)")
        default:
            break
        }
    }
}

extension GameManager: GKMatchmakerViewControllerDelegate {
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true)
        enterMatch(match: match)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
}

extension GameManager : GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        let content = String(decoding: data, as: UTF8.self)
        
        if content.starts(with: "strData:") {
            let message = content.replacing("strData:", with: "")
            print("Message \(message) from \(player.displayName)")
        } else {
            print("Data is \(data)")
        }
    }
    
    func send(_ message: String) {
        guard let encode = "strData:\(message)".data(using: .utf8) else { return }
        send(encode, mode: .reliable)
    }
    
    private func send(_ data: Data, mode: GKMatch.SendDataMode) {
        do {
            try currentMatch?.sendData(toAllPlayers: data, with: mode)
        } catch {
            print("Error \(error)")
        }
    }
}

enum GameType {
    case singlePlayer, multiPlayer
}

enum TeamType {
    case blue, red
}

enum PlayerAuthState: String {
    case authenticating = "Logging into the game center, please wait..."
    case unauthenticated = "Please sign in to the game center to start playing."
    case authenticated = ""
    case error = "There is an error while sign in to the game center."
    case restricted = "You are not allowed multiplayer games."
}
