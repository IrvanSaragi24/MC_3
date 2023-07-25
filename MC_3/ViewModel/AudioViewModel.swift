//
//  AudioViewModel.swift
//  RecordAndClassify
//
//  Created by Hanifah BN on 18/07/23.
//


import Foundation
import AVFoundation
import SoundAnalysis

class AudioViewModel: NSObject, ObservableObject {
    @Published var audio = Audio()
    private var engine = AVAudioEngine()
    private var audioInputNode: AVAudioInputNode!
    private var audioAnalyzer: SNAudioStreamAnalyzer!
    private var request: SNClassifySoundRequest!
    private var audioFilename: URL!
    private let detector: VoiceActivityDetector = VoiceActivityDetector()
    private var timer: Timer?
    private var isTimerRunning: Bool = false
    var silentPeriod: Int?
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func startVoiceActivityDetection() {
        do {
            audio.isRecording = true
            // Set up AVAudioEngine and audio input node
            audioInputNode = engine.inputNode
            
            // var inputBus = AVAudioNodeBus(0)
            let inputFormat = engine.inputNode.inputFormat(forBus: AVAudioNodeBus(0)) // 0 = inputBus.
            
            engine.prepare()
            try engine.start()

            // Create the speech classification request using the built-in model
            request = try SNClassifySoundRequest(classifierIdentifier: .version1)

            // Create the analyzer and add the request
            audioAnalyzer = SNAudioStreamAnalyzer(format: inputFormat)
            try audioAnalyzer.add(request, withObserver: detector)
            
            // Start the audio engine
            try engine.start()
            
            audioInputNode.installTap(onBus: 0, bufferSize: 8192, format: inputFormat, block: analyzeAudio(buffer:at:))
            
            print("starting...")
        } catch {
            print("Error setting up audio engine: \(error.localizedDescription)")
        }
    }

    func analyzeAudio(buffer: AVAudioBuffer, at time: AVAudioTime)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            self.audioAnalyzer!.analyze(buffer, atAudioFramePosition: time.sampleTime)
            
            // Update the @Published properties on the main thread
            DispatchQueue.main.async {
                self.audio.isSpeechDetected = self.detector.isSpeechDetected
                self.audio.speechConfidence = self.detector.speechConfidence
                
                if self.detector.isSpeechDetected == "No" {
//                    print("timer...")
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                        self?.handleTimer()
                    }
                    self.isTimerRunning = true
                }
            }
        }
    }
    
    private func handleTimer() {
        // Check if the timer has been running for 30 seconds
        if isTimerRunning, let lastSpeechDetectedTimestamp = detector.lastSpeechDetectedTimestamp {
            let currentTime = Date()
            let timeDifference = currentTime.timeIntervalSince(lastSpeechDetectedTimestamp)
            
            if timeDifference >= TimeInterval(silentPeriod ?? Int(30.0)) {
                print("stopping....")
                stopVoiceActivityDetection() // Stop the voice activity detection process
                return // Exit the function early to avoid multiple invalidations
            }
        }
    }
    
    func stopVoiceActivityDetection() {
        engine.stop()
        audioAnalyzer.remove(request)
        audioInputNode.removeTap(onBus: 0)
        audio.isRecording = false
        
        // Stop the timer
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
}



/// VIEW MODEL VERSI AUDIORECORDER.

//import Foundation
//import AVFoundation
//import SoundAnalysis
//
//class AudioViewModel: NSObject, ObservableObject, AVAudioRecorderDelegate {
//    @Published var audio = Audio()
//    private var audioRecorder: AVAudioRecorder?
//    private var audioFilename: URL!
//    private var audioAnalyzer: SNAudioFileAnalyzer?
//    private let detector: VoiceActivityDetector = VoiceActivityDetector()
//    private var meteringTimer: Timer?
//
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//
//    func startRecording() {
//        // Append = buat baru.
//        audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
//
//        let settings: [String: Any] = [
//            AVFormatIDKey: Int(kAudioFormatLinearPCM),
//            AVSampleRateKey: 44100.0,
//            AVNumberOfChannelsKey: 2,
//            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//        ]
//
//        do {
//            // Record = biar app lain gak bisa play audio.
//            let session = AVAudioSession.sharedInstance()
//            try session.setCategory(.playAndRecord, mode: .default, options: [.mixWithOthers])
//            try session.setActive(true)
//
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            audioRecorder?.delegate = self
//            audioRecorder?.isMeteringEnabled = true
//            audioRecorder?.record()
//            audio.isRecording = true
//
//            meteringTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
//                self?.updateDecibelLevel()
//            }
//
//            print("starting")
//        } catch {
//            // Handle
//            print("Recording error: \(error.localizedDescription)")
//        }
//    }
//
//    func stopRecording() {
//        audioRecorder?.stop()
//        audioRecorder = nil
//        audio.isRecording = false
//
//        meteringTimer?.invalidate()
//
//        print("stopping")
//
//        guard let audioFilename = audioFilename else { return }
//
//        // Create a request with the Sound Analysis model.
//        guard let request = try? SNClassifySoundRequest(classifierIdentifier: SNClassifierIdentifier.version1) else {
//            print("Unable to create sound classification request.")
//            return
//        }
//
//        // Configure the sound analysis task
//        do {
//            audioAnalyzer = try SNAudioFileAnalyzer(url: audioFilename)
//        } catch {
//            print("Failed to create audio file analyzer: \(error.localizedDescription)")
//            return
//        }
//
//        try? audioAnalyzer?.add(request, withObserver: self.detector)
//
//        // Kick off detection
//        audioAnalyzer?.analyze()
//
//        // Begin Combine observing and await comments
//        // For how I should use AsyncSequence 😉
////        self.detector.$lastestTimeStamp
////        .sink { [weak self] time in
////            guard let self = self else { return }
////            let seconds = CMTimeGetSeconds(time)
////            print("Found speech at \(seconds) seconds")
////        }
//    }
//
//    func updateDecibelLevel() {
//        audioRecorder?.updateMeters()
//        let decibelLevel = audioRecorder?.averagePower(forChannel: 0) ?? 0.0 // Channel 0 tuh berarti left one on Stereo Audio.
//        // Use the decibel level to update your UI or perform any necessary actions
//        // For example, you can pass the decibel level to the audio model or use it to update a decibel level meter view
//        audio.currentDecibelLevel = decibelLevel
//    }
//
//}
//
//
//
