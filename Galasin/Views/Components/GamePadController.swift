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
        HStack(spacing: 12) {
            Button {
                onPadTouched(.left)
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .padding(8)
            }
            .buttonStyle(.bordered)
            
            Button {
                onPadTouched(.right)
            } label: {
                Image(systemName: "arrow.right")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .padding(8)
            }
            .buttonStyle(.bordered)
            
            Spacer()
            
            Button {
                onPadTouched(.up)
            } label: {
                Image(systemName: "arrow.up")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .padding(8)
            }
            .buttonStyle(.bordered)
            
            Button {
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
        .padding([.horizontal, .bottom])
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
