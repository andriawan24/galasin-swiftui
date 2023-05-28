//
//  Helper.swift
//  Galasin
//
//  Created by Naufal Fawwaz Andriawan on 25/05/23.
//

import Foundation
import CoreHaptics
import UIKit

func playHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
//    do {
//        let slice = CHHapticEvent(
//            eventType: .hapticContinuous,
//            parameters: [
//                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.60),
//                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.40)
//            ],
//            relativeTime: 0,
//            duration: 0.45
//        )
//
//        let snip = CHHapticEvent(
//            eventType: .hapticTransient,
//            parameters: [
//                CHHapticEventParameter(parameterID: .hapticIntensity, value: 3.0),
//                CHHapticEventParameter(parameterID: .hapticSharpness, value: 4.0)
//            ],
//            relativeTime: 0.08
//        )
//
//        let pattern = try CHHapticPattern(events: [slice, snip], parameters: [])
//        let engine = try CHHapticEngine()
//        try engine.start()
//        let player = try engine.makePlayer(with: pattern)
//        try player.start(atTime: CHHapticTimeImmediate)
//        engine.notifyWhenPlayersFinished { _ in
//            return .stopEngine
//        }
//    } catch {
//        print(error.localizedDescription)
//    }
}
