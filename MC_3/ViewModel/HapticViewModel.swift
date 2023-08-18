//
//  HapticViewModel.swift
//  RecordAndClassify
//
//  Created by Hanifah BN on 20/07/23.
//

import Foundation
import CoreHaptics

class HapticViewModel: ObservableObject {
    private var engine: CHHapticEngine?

    // Check device compatibility
    lazy var supportHaptics: Bool = {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }()

    init() {
        do {
            // print("engine kebuat")
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error starting haptic engine: \(error)")
        }
    }

    func prepareHaptics() {
        guard supportHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func triggerThrillingHaptic() {
        // Check if the haptic engine is available
        guard let engine = engine else { return }

        // Create a haptic pattern
        var events: [CHHapticEvent] = []

        // Gentle tap event to start the pattern
        let gentleIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let gentleSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
        let gentleEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [gentleIntensity, gentleSharpness], relativeTime: 0, duration: 0.3)
        events.append(gentleEvent)

        // Build anticipation with a rhythmic pattern
        let rhythmicIntensity: Float = 0.8
        let rhythmicSharpness: Float = 0.8
        let interval: TimeInterval = 0.15
        let duration: TimeInterval = 0.1
        for itr in 1...5 {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: rhythmicIntensity)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: rhythmicSharpness)
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: Double(itr) * interval,
                duration: duration)
            events.append(event)
        }

        // Add a final intense and long buzz event for the surprise
        let surpriseIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let surpriseSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let surpriseEvent = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [surpriseIntensity, surpriseSharpness],
            relativeTime: 0.5,
            duration: 2.5)
        events.append(surpriseEvent)

        // Create the haptic pattern
        do {
            print("nyampe do")
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Error playing haptic pattern: \(error)")
        }
    }
}
