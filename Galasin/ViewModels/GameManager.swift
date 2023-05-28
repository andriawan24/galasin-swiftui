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
import AVFoundation

class GameManager: NSObject, ObservableObject {
    @Published var inGame: Bool = false
    @Published var gameType: GameType = .singlePlayer
    @Published var score: Int = 0
    @Published var enemyScore: Int = 0
    @Published var attackersLeft: Int = 5
    @Published var gameFinished = false
    @Published var authStatus: PlayerAuthState = .authenticating
    @Published var currentTeam: TeamType?
    @Published var isAttacking: Bool = false
    @Published var chosenPlayer: AttackerNode? = nil
    @Published var chosenDefender: DefenderNode? = nil
    
    var localPlayer = GKLocalPlayer.local
    var otherPlayer: GKPlayer?
    var defenders = [DefenderNode]()
    var attackers = [AttackerNode]()
    var scene: GameScene?
    
    private var audioPlayer: AVAudioPlayer?
    private var audioOneTimePlayer: AVAudioPlayer?
    private var currentMatch: GKMatch?
    private var playerUUIDKey = UUID().uuidString
    private var roundToEnd = 1
    
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
        playSound(sound: "background_music", type: "wav")
    }
    
    func choosePlayer(player: AttackerNode) {
        chosenDefender = nil
        chosenPlayer = player
    }
    
    func chooseDefender(defender: DefenderNode) {
        chosenPlayer = nil
        chosenDefender = defender
    }
    
    func movePlayer(direction: GamePadDirection) {
        if chosenPlayer != nil {
            chosenPlayer?.move(direction: direction)
            send("movePlayer:attacker/\(chosenPlayer?.name ?? "")/\(direction.rawValue)")
        } else {
            chosenDefender?.move(direction: direction)
            send("movePlayer:defender/\(chosenDefender?.name ?? "")/\(direction.rawValue)")
        }
    }
    
    func increaseScore() {
        if gameType == .singlePlayer {
            score += 1
            reducePlayer(isExplode: false)
        } else {
            if isAttacking {
                score += 1
                reducePlayer(isExplode: false)
                send("updateScore:\(score)")
            }
        }
    }
    
    func reducePlayer(isExplode: Bool) {
        attackersLeft -= 1
        if gameType == .multiPlayer {
            send("updateAttackersLeft:\(attackersLeft)")
        }
        
        if attackersLeft == 0 {
            if gameType == .multiPlayer {
                if roundToEnd > 0 {
                    roundToEnd -= 1
                    chosenPlayer = nil
                    chosenDefender = nil
                    isAttacking.toggle()
                    attackersLeft = 5
                    attackers.removeAll()
                    defenders.removeAll()
                    scene?.removeAllPlayers()
                    scene?.setupAttackers()
                    scene?.setupDefenders()
                    send("changeRound:_")
                } else {
                    gameFinished = true
                    send("finishGame:_")
                }
            } else {
                gameFinished = true
            }
        }
        
        if isExplode {
            playSoundOneTime(sound: "explode_music", type: "wav")
        }
    }
    
    func resetGame() {
        score = 0
        enemyScore = 0
        chosenPlayer = nil
        attackersLeft = 5
        inGame = false
        attackers.removeAll()
        defenders.removeAll()
        currentMatch?.disconnect()
        currentMatch?.delegate = nil
        currentMatch = nil
        stopSound()
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
            
            isAttacking = playerUUIDKey < parameter
            if isAttacking {
                currentTeam = .blue
            } else {
                currentTeam = .red
            }
            
            attackers.removeAll()
            defenders.removeAll()
            scene?.removeAllPlayers()
            scene?.setupAttackers()
            scene?.setupDefenders()
        case "movePlayer":
            let type = parameter.split(separator: "/").first ?? ""
            let name = parameter.split(separator: "/")[1]
            let direction = parameter.split(separator: "/").last ?? ""
            print("Type: \(type), name: \(name), direction: \(direction)")
            if type == "attacker" {
                let attacker = attackers.filter { attacker in
                    (attacker.name ?? "").lowercased() == name.lowercased()
                }.first
                attacker?.move(direction: GamePadDirection.init(rawValue: String(direction)) ?? .down)
            } else if type == "defender" {
                let defender = defenders.filter { defender in
                    (defender.name ?? "").lowercased() == name.lowercased()
                }.first
                defender?.move(direction: GamePadDirection.init(rawValue: String(direction)) ?? .down)
            }
        case "updateScore":
            let score = Int(parameter) ?? 0
            enemyScore = score
        case "changeRound":
            roundToEnd -= 1
            chosenPlayer = nil
            chosenDefender = nil
            isAttacking.toggle()
            attackersLeft = 5
            attackers.removeAll()
            defenders.removeAll()
            scene?.removeAllPlayers()
            scene?.setupAttackers()
            scene?.setupDefenders()
        case "finishGame":
            gameFinished = true
        default:
            break
        }
    }
}

extension GameManager {
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func playSoundOneTime(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioOneTimePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioOneTimePlayer?.numberOfLoops = 0
                audioOneTimePlayer?.play()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
        audioOneTimePlayer?.stop()
        audioOneTimePlayer = nil
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
            handleMessage(message)
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
