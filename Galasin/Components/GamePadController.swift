//
//  GamePadController.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 22/05/23.
//

import SwiftUI

struct GamePadController: View {
    
    var onPadTouched: (GamePadDirection) -> Void
    
    init(onPadTouched: @escaping (GamePadDirection) -> Void) {
        self.onPadTouched = onPadTouched
    }
    
    var body: some View {
        HStack(spacing: 48) {
            Button {
                onPadTouched(.left)
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Button {
                onPadTouched(.up)
            } label: {
                Image(systemName: "arrow.up")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Button {
                onPadTouched(.right)
            } label: {
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Button {
                onPadTouched(.down)
            } label: {
                Image(systemName: "arrow.down")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
}

enum GamePadDirection {
    case up, down, left, right
}

struct GamePadController_Previews: PreviewProvider {
    static var previews: some View {
        GamePadController { direction in
            // No-ops
        }
    }
}
