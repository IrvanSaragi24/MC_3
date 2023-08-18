//
//  ListenView.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 19/07/23.
//

import SwiftUI

struct ListenView: View {
    @EnvironmentObject private var lobbyViewModel: LobbyViewModel
    @EnvironmentObject private var multipeerController: MultipeerController

    @StateObject var audioViewModel = AudioViewModel()

    @State private var shouldStartQuizTime = false
    @State private var currentColorIndex = 0

    private let colors: [Color] = [.blue, .black, .indigo, .red]

    var body: some View {
        ZStack {
            BubbleView()
            VStack(spacing: 16) {
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color("Main"), lineWidth: 10)
                            .frame(width: 234)
                            .overlay {
                                Circle()
                                    .foregroundColor(colors[currentColorIndex])
                                    .opacity(0.8)
                                Image("Music")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 225)
                            }
                            .padding(.top, 50)
                            .onAppear {
                                startColorChangeTimer()
                            }
                    }
                    Text("Listening..")
                        .font(.system(size: 36, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Second"))
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Second"), lineWidth: 4)
                            .frame(width: 234, height: 56)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Color("Second"))
                                    .opacity(0.2)
                            }
                        Text(lobbyViewModel.formattedElapsedTime)
                            .font(.system(size: 32))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Second"))
                            .onAppear(perform: lobbyViewModel.startTimer)
                            .onDisappear(perform: lobbyViewModel.pauseTimer)
                    }
                    Text("If We Detect Silence,\nThe Game Starts!")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(Color("Second"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                }
                Spacer()
                Button {
                    if multipeerController.isHost {
                        audioViewModel.stopVoiceActivityDetection()
                        quizTime()
                    }
                } label: {
                    Text("Quiz Time!")
                }
                .buttonStyle(MultipeerButtonStyle())
                .opacity(multipeerController.isHost ? 100 : 0)
                .background(
                    NavigationLink(
                        destination: ChoosingView()
                            .environmentObject(lobbyViewModel)
                            .environmentObject(multipeerController),
                        isActive: $multipeerController.navigateToChoosingPlayer
                    ) {
                        EmptyView()
                    }
                )
                Button {
                    if multipeerController.isHost {
                        audioViewModel.stopVoiceActivityDetection()

                        let connectedGuest = multipeerController.getConnectedPeers()
                        multipeerController.sendMessage(NavigateCommandConstant.navigateToChooseRole, to: connectedGuest)
                        multipeerController.navigateToChooseRole = true
                    }
                } label: {
                    Text("End Session")
                }
                .buttonStyle(SecondButtonStyle())
                .padding(.bottom, 50)
                .opacity(multipeerController.isHost ? 100 : 0)
                .background(
                    NavigationLink(
                        destination: ChooseRoleView()
                            .environmentObject(multipeerController),
                        isActive: $multipeerController.navigateToChooseRole
                    ) {
                        EmptyView()
                    }
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            multipeerController.resetNavigateVar()
            if multipeerController.isHost {
                if audioViewModel.audio.isRecording == false && multipeerController.hostPeerID == nil {
                    audioViewModel.startVoiceActivityDetection()
                    lobbyViewModel.startTimer()
                    audioViewModel.silentPeriod = lobbyViewModel.lobby.silentDuration
                }
            }
        }
        .onChange(of: audioViewModel.audio.isRecording) { newValue in
            if multipeerController.isHost && newValue == false {
                sendQuizTimeNotification()
                // checkNotificationFlag()
                // if shouldStartQuizTime {
                    quizTime()
                // }
            }
        }
    }

    func startColorChangeTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
            withAnimation {
                // Increment the currentColorIndex or reset to 0 if it reaches the last color
                currentColorIndex = (currentColorIndex + 1) % colors.count
            }
        }
    }

    private func sendQuizTimeNotification() {
        let content = UNMutableNotificationContent()
        content.title = "It's play time!"
        content.body = "Pick up your phone!!!"
        content.sound = UNNotificationSound.default
        // Schedule the notification to be delivered immediately
        let request = UNNotificationRequest(identifier: "ChoosingViewNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Local notification scheduled successfully")
            }
        }
    }

    private func checkNotificationFlag() {
        if UserDefaults.standard.bool(forKey: "QuizTimeFromNotification") {
            UserDefaults.standard.removeObject(forKey: "QuizTimeFromNotification")
            shouldStartQuizTime = true // Activate the NavigationLink to open ChoosingView
            print("click")
        }
    }

    func quizTime() {
        if multipeerController.isHost {
            let connectedGuest = multipeerController.getConnectedPeers()
            var candidates = connectedGuest.map { $0.displayName }

            // Add host
            candidates.append(multipeerController.myPeerId.displayName)

            lobbyViewModel.pauseTimer()

            let objekIndex = lobbyViewModel.getQuestion(candidates: candidates)

            if objekIndex == candidates.count - 1 {
                // host yg kepilih jadi object
                // Todo: sayed figure this things out
            }

            // Di sisi pengirim
            let typeData = "question"
            let message = "\(lobbyViewModel.lobby.question ?? ""):\(typeData)"

            // Kirim pesan ke semua peer yang terhubung
            multipeerController.sendMessage(message, to: connectedGuest)
            multipeerController.receivedQuestion = lobbyViewModel.lobby.question!

            // Pindah halaman
            multipeerController.sendMessage(NavigateCommandConstant.navigateToChoosingPlayer, to: connectedGuest)
            multipeerController.navigateToChoosingPlayer = true
        }
    }
}

struct ListenView_Previews: PreviewProvider {
    static var previews: some View {
        ListenView()
            .environmentObject(MultipeerController("YourDisplayName"))
            .environmentObject(LobbyViewModel())
    }
}
