//
//  MotionViewModel.swift
//  MC_3
//
//  Created by Hanifah BN on 28/07/23.
//

import Foundation
import CoreMotion

class MotionViewModel: ObservableObject {
    @Published var motionManager = CMMotionManager()
    @Published var timer: Timer?
    @Published var nodCount = 0
    @Published var isNodding = false
    @Published var isNoddingDetected = false
    @Published var shakeCount = 0
    @Published var isShaking = false
    @Published var isShakingDetected = false
    
    func startNoddingDetection() {
        motionManager.startDeviceMotionUpdates()

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let deviceMotion = self.motionManager.deviceMotion {
                let gravity = deviceMotion.gravity
                let rotationRate = deviceMotion.rotationRate

                // Implement your nodding detection logic here
                self.detectNoddingMotion(rotationRate)
            }
        }
    }

    func stopNoddingDetection() {
        motionManager.stopDeviceMotionUpdates()
        timer?.invalidate()
        timer = nil
    }

    func detectNoddingMotion(_ rotationRate: CMRotationRate) {
        let threshold = 2.0 // Adjust this threshold as needed

        if rotationRate.x > threshold {
            if !isNodding {
                // Start of nodding motion
                isNodding = true
            }
        } else if rotationRate.x < -threshold {
            if isNodding {
                // End of nodding motion
                isNodding = false
                nodCount += 1

                if nodCount >= 2 {
                    // Nodding motion detected
                    self.isNoddingDetected = true
                    print("Nodding motion detected")
                }
            }
        }
    }
    
    func startShakingDetection() {
        motionManager.startDeviceMotionUpdates()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let deviceMotion = self.motionManager.deviceMotion {
                let gravity = deviceMotion.gravity
                let rotationRate = deviceMotion.rotationRate
                
                // Implement your head shaking detection logic here
                self.detectHeadShaking(rotationRate)
            }
        }
    }
    
    func stopShakingDetection() {
        motionManager.stopDeviceMotionUpdates()
        timer?.invalidate()
        timer = nil
    }
    
    func detectHeadShaking(_ rotationRate: CMRotationRate) {
        let threshold = 2.0 // Adjust this threshold as needed
        
        if rotationRate.y > threshold {
            if !isShaking {
                // Start of head shaking motion
                isShaking = true
            }
        } else if rotationRate.y < -threshold {
            if isShaking {
                // End of head shaking motion
                isShaking = false
                shakeCount += 1
                
                if shakeCount >= 2 {
                    self.isShakingDetected = true
                    // Head shaking motion detected
                    print("Head shaking motion detected")
                }
            }
        }
    }
}
