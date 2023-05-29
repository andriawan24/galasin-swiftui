//
//  GamePadController.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 22/05/23.
//

import SwiftUI

// TODO: Change Design of the controller using common like playstation gamepad or analog
struct GamePadController: View {
    
    var onPadTouched: (GamePadDirection) -> Void
    var directionAvailables: [GamePadDirection] = [.left, .up, .right, .down]
    
    init(
        directionAvailables: [GamePadDirection] = [.left, .up, .right, .down],
        onPadTouched: @escaping (GamePadDirection) -> Void
    ) {
        self.onPadTouched = onPadTouched
        self.directionAvailables = directionAvailables
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if directionAvailables.contains(.left) {
                Button {
                    playHaptic()
                    onPadTouched(.left)
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(8)
                }
                .buttonStyle(.bordered)
            }
            
            if directionAvailables.contains(.down) {
                Button {
                    playHaptic()
                    onPadTouched(.down)
                } label: {
                    Image(systemName: "arrow.down")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(8)
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
            
            if directionAvailables.contains(.up) {
                Button {
                    playHaptic()
                    onPadTouched(.up)
                } label: {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(8)
                }
                .buttonStyle(.bordered)
            }
            
            if directionAvailables.contains(.right) {
                Button {
                    playHaptic()
                    onPadTouched(.right)
                } label: {
                    Image(systemName: "arrow.right")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                        .padding(8)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding([.horizontal, .bottom])
    }
}

enum GamePadDirection: String {
    case up = "up"
    case down = "down"
    case left = "left"
    case right = "right"
}

struct GamePadController_Previews: PreviewProvider {
    static var previews: some View {
        GamePadController { direction in
            // No-ops
        }
    }
}
