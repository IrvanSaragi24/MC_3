//
//  MultipeerController.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 20/07/23.
//

import MultipeerConnectivity

protocol MultipeerControllerDelegate: AnyObject {
    func connected(peerID: MCPeerID)
    func disconnected(peerID: MCPeerID)
    func didReceive(data: Data, from peerID: MCPeerID)
}

struct Guest: Identifiable, Hashable {
    let id: MCPeerID
    var status: ConnectionStatus
}

class MultipeerController: NSObject, ObservableObject {
    weak var delegate: MultipeerControllerDelegate?
    
//    private let myPeerId = MCPeerID(displayName: String("\(UIDevice.current.name) \(UUID())".prefix(10)))
    var myPeerId: MCPeerID!
    private let serviceType = MCConstants.service
    
    private var session: MCSession
    private var browser: MCNearbyServiceBrowser
    private var advertiser: MCNearbyServiceAdvertiser
    var hostPeerID: MCPeerID? //I want to save the peerID of host
    
//    @Published var availableGuest: [MCPeerID] = [] // Do not use this var
//    @Published var connectedGuest: [MCPeerID] = [] // Do not use this var
    @Published var allGuest: [Guest] = []
    @Published var gameState: GameState = .waitingForInvitation
    @Published var receivedQuestion: String = "Default Question"
    @Published var nonNullVotes: Int = 0
    @Published var currentQuestionIndex: Int = 0
    
    @Published var lobby = Lobby(name: "Player") // Please don't use this, All lobby related stuff should be in separated View Model which is LobbyViewModel
    
    
    var isChoosingView: Bool = false
    var isResultView: Bool = false
    @Published var isEndView: Bool = false
    var isWin: Bool = true
    
    //new published var - sayed
    @Published var navigateToLobby = false
    @Published var navigateToWaitingInvitation = false
    @Published var navigateToWaitingStart = false
    @Published var navigateToListen = false
    @Published var navigateToChoosingPlayer = false
    @Published var navigateToPlayer = false
    @Published var navigateToReferee = false
    @Published var navigateToResult = false
    @Published var navigateToEnd = false
    @Published var navigateToChooseRole = false
    @Published var navigateToHangoutMode = false
    
    //to handle question index
    var totalQuestion = 1
    var currentQuestion = 1
    var isInitialRound = true
    
    @Published var yesVote: Int = 0
    @Published var noVote: Int = 0
    @Published var totalVote: Int = 0
    
    var isPlayer: Bool = false
    var currentPlayer: String = "Player"
    var isHost : Bool = false
    
    
    init(_ displayName: String) {
        myPeerId = MCPeerID(displayName: displayName)
        
        self.session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        self.browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        self.advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        super.init()
        
        self.session.delegate = self
        self.advertiser.delegate = self
        self.browser.delegate = self
    }
    
    // handle advertising by using a bool variable
    var isAdvertising: Bool = false {
        didSet {
            if isAdvertising {
                advertiser.startAdvertisingPeer()
                print("Start advertising")
            } else {
                advertiser.stopAdvertisingPeer()
//                session.disconnect()
                print("Stop advertising")
            }
        }
    }
    
    
    /*
    func startAdvertising() {
        advertiser.startAdvertisingPeer()
        print("Start Advertising")
    }
    
    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
        session.disconnect()
        print("Stop Advertising")
    }
    */
    //Sending Data
    
    func handleReceivedCommand(_ command: String) -> Bool {
        var result = true
        switch command {
            
        case NavigateCommandConstant.navigateToLobby:
            DispatchQueue.main.async {
                self.navigateToLobby = true
            }
            
        case NavigateCommandConstant.navigateToWaitingInvitation:
            DispatchQueue.main.async {
                self.navigateToWaitingInvitation = true
            }
            
        case NavigateCommandConstant.navigateToWaitingStart:
            DispatchQueue.main.async {
                self.navigateToWaitingStart = true
            }
            
        case NavigateCommandConstant.navigateToListen:
            DispatchQueue.main.async {
                self.navigateToListen = true
                self.resetParameters(page: NavigateCommandConstant.navigateToListen)
            }
            
        case NavigateCommandConstant.navigateToChoosingPlayer:
            DispatchQueue.main.async {
                self.navigateToChoosingPlayer = true
                self.resetParameters(page: NavigateCommandConstant.navigateToChoosingPlayer)
            }
            
        case NavigateCommandConstant.navigateToPlayer:
            DispatchQueue.main.async {
                self.navigateToPlayer = true
            }
            
        case NavigateCommandConstant.navigateToReferee:
            DispatchQueue.main.async {
                self.navigateToReferee = true
            }
            
        case NavigateCommandConstant.navigateToResult:
            DispatchQueue.main.async {
                self.navigateToResult = true
            }
            
        case NavigateCommandConstant.navigateToEnd:
            DispatchQueue.main.async {
                self.navigateToEnd = true
            }
            
        case NavigateCommandConstant.navigateToChooseRole:
            DispatchQueue.main.async {
                self.navigateToChooseRole = true
                self.resetParameters(page: NavigateCommandConstant.navigateToChooseRole)
            }
        case NavigateCommandConstant.navigateToHangoutMode:
            DispatchQueue.main.async {
                self.navigateToHangoutMode = true
            }
        default:
            result = false
            break
        }
        
        return result
    }
    
    func resetParameters(page: String) {
        //to be called when NavigateCommandConstant.navigateToChooseRole
        
        yesVote = 0
        noVote = 0
        totalVote = 0
        isPlayer = false
        
        if page == NavigateCommandConstant.navigateToChoosingPlayer {
            if !isInitialRound {
                currentQuestion += 1
            }
            else {
                isInitialRound = false
            }
        }
        
        else if page == NavigateCommandConstant.navigateToListen {
            currentQuestion = 1
            isInitialRound = true
        }
        
        else if page == NavigateCommandConstant.navigateToChooseRole {
            isInitialRound = true
            currentQuestion = 0
            totalQuestion = 1
            isHost = false
            hostPeerID = nil
            allGuest = []
            lobby = Lobby(name: "", silentDuration: 10, numberOfQuestion: 1)
            session.disconnect()
        }
    }
    
    func resetNavigateVar() {
        //to be called in every onAppear page
        navigateToLobby = false
        navigateToWaitingInvitation = false
        navigateToWaitingStart = false
        navigateToListen = false
        navigateToChoosingPlayer = false
        navigateToPlayer = false
        navigateToReferee = false
        navigateToResult = false
        navigateToEnd = false
        navigateToChooseRole = false
        navigateToHangoutMode = false
        
//        allGuest = []
//        lobby = Lobby(name: "", silentDuration: 10, numberOfQuestion: 1)
//        yesVote = 0
//        noVote = 0
//        totalVote = 0
//        isPlayer = false
//        isHost = false
//        hostPeerID = nil
//        session.disconnect()
        
    }
    
    func resetVarToDefault(){
        isPlayer = false
        currentPlayer = "Player"
        isResultView = false
        isEndView = false
        isWin = true
        
        yesVote = 0
        noVote = 0
        totalVote = 0
        lobby.currentQuestionIndex += 1
    }
    
    func resetGame() {
        allGuest = []
        gameState = .reset
        receivedQuestion = "Default Question"
        
        lobby = Lobby(name: "", silentDuration: 10, numberOfQuestion: 1)
        
        yesVote = 0
        noVote = 0
        totalVote = 0
        
        isPlayer = false // is this okay?
        currentPlayer = "Player"
        isHost = false
        isChoosingView = false
        isResultView = false
        isEndView = false
        isWin = true
    }
    
    func sendMessage(_ message: String, to peers: [MCPeerID]) {
        guard
            let data = message.data(using: .utf8),
            !peers.isEmpty
        else { return }
        
        do {
            try session.send(data, toPeers: peers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func invitePeer(_ peerID: MCPeerID, to lobby: Lobby) {

        let context = lobby.name.data(using: .utf8)
        browser.invitePeer(
            peerID,
            to: session,
            withContext: context,
            timeout: TimeInterval(120))
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
        print("Start browsing")
    }
    
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
        print("Stop browsing")
    }
    
    func getConnectedPeers() -> [MCPeerID] {
        return session.connectedPeers
    }
    
    func resetAllGuest() {
        let connectedPeers = getConnectedPeers()
        allGuest = []
        for peer in connectedPeers {
            let guest = Guest(id: peer, status: .connected)
            allGuest.append(guest)
        }
    }
    
    
    
    
    
    func disconnectPeer(peerToRemove: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            let connectedGuest: [MCPeerID] = [peerToRemove]
            self?.sendMessage(MsgCommandConstant.disconnect, to: connectedGuest)
            
            if let index = self?.allGuest.firstIndex(where: { $0.id == peerToRemove }) {
                self?.allGuest[index].status = .discovered
            }
        }
    }
    
}

// Handle guest candidate - browsing nearby service
extension MultipeerController: MCNearbyServiceBrowserDelegate {
    func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer peerID: MCPeerID,
        withDiscoveryInfo info: [String: String]?
    ) {
        
        if var matchingGuest = allGuest.first(where: { $0.id == peerID }) {
            // Access the status of the matching guest
            let status = matchingGuest.status
            
            // handle device that has connected?
            
        } else {
            let guest = Guest(id: peerID, status: .discovered)
            DispatchQueue.main.async { [weak self] in
                self?.allGuest.append(guest)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        if let index = allGuest.firstIndex(where: { $0.id == peerID && $0.status == .discovered }) {
            // Remove the guest at the found index
            DispatchQueue.main.async { [weak self] in
                self?.allGuest.remove(at: index)
            }
        }
        
    }
}

extension MultipeerController: MCSessionDelegate {
    // Handle session state changes - connected / disconnect, etc
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connecting:
            print("\(peerID) state: connecting")
        case .connected:
            print("\(peerID) state: connected")

            if (peerID.displayName.contains("Host:")){ //TODO : Sayed to investigate if this is necessary or not
                hostPeerID = peerID
            }
            
            DispatchQueue.main.async { [weak self] in
                if let index = self?.allGuest.firstIndex(where: { $0.id == peerID }) {
                    self?.allGuest[index].status = .connected
                } else {
                    let guest = Guest(id: peerID, status: .connected)
                    self?.allGuest.append(guest)
                }
            }
            
            delegate?.connected(peerID: peerID)
            
        case .notConnected:
            print("\(peerID) state: not connected")
            
            delegate?.disconnected(peerID: peerID)
        @unknown default:
            print("\(peerID) state: unknown")
        }
    }
    /*
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
      guard let job = try? JSONDecoder().decode(JobModel.self, from: data) else { return }
      DispatchQueue.main.async {
        self.jobReceivedHandler?(job)
      }
    }
    */
    
    //handle data received
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let receivedString = String(data: data, encoding: .utf8) {
            
            if !handleReceivedCommand(receivedString) {
                // Split the received string using the delimiter (":")
                let components = receivedString.components(separatedBy: ":")
                if components.count == 1 {
                    let message = components[0]
                    
                    // Check if the message is a command or other type of data
                    if message.contains(MsgCommandConstant.updateTotalQuestion) {
                        DispatchQueue.main.async { [weak self] in
                            let originalString = message
                            let substringToRemove = MsgCommandConstant.updateTotalQuestion
                            
                            let updatedString = originalString.replacingOccurrences(of: substringToRemove, with: "")
                            
                            self?.totalQuestion = Int(updatedString) ?? 1
                        }
                    } else if message.contains(MsgCommandConstant.updateCurrentPlayer) {
                        DispatchQueue.main.async { [weak self] in
                            let originalString = message
                            let substringToRemove = MsgCommandConstant.updateCurrentPlayer
                            
                            let updatedString = originalString.replacingOccurrences(of: substringToRemove, with: "")
                            
                            self?.currentPlayer = updatedString
                        }
                    } else if message == MsgCommandConstant.disconnect {
                        DispatchQueue.main.async { [weak self] in
                            // Handle disconnect
                            self?.gameState = .waitingForInvitation
                            
                            self?.session.disconnect()
                            self?.navigateToWaitingInvitation = true
                        }
                    }
                        
                        
                    else if message == MsgCommandConstant.startListen {
                        DispatchQueue.main.async { [weak self] in
                            // Handle the "Start Listen" command
                            self?.gameState = .listening
                        }
                    } else if message == MsgCommandConstant.updateIsChoosingViewTrue {
                        DispatchQueue.main.async { [weak self] in
                            // Handle the "Start Quiz" command
                            self?.isChoosingView = true
                        }
                    } else if message == MsgCommandConstant.updateIsChoosingViewFalse {
                        DispatchQueue.main.async { [weak self] in
                            // Handle the "Start Quiz" command
                            self?.isChoosingView = false
                        }
                    }  else if message == MsgCommandConstant.updatePlayerTrue {
                        DispatchQueue.main.async { [weak self] in
                            self?.isPlayer = true
                        }
                    } else if message == MsgCommandConstant.updatePlayerFalse {
                        DispatchQueue.main.async { [weak self] in
                            self?.isPlayer = false
                        }
                    } else if message == MsgCommandConstant.voteYes {
                        DispatchQueue.main.async { [weak self] in
                            self?.yesVote += 1
                            self?.totalVote += 1
                        }
                    } else if message == MsgCommandConstant.voteNo {
                        DispatchQueue.main.async { [weak self] in
                            self?.noVote += 1
                            self?.totalVote += 1
                        }
                    } else if message == MsgCommandConstant.updateIsResultViewTrue {
                        DispatchQueue.main.async { [weak self] in
                            self?.isResultView = true
                            self?.gameState = .result
                        }
                    }else if message == MsgCommandConstant.updateIsWinTrue {
                        DispatchQueue.main.async { [weak self] in
                            self?.isWin = true
                        }
                    } else if message == MsgCommandConstant.updateIsWinFalse {
                        DispatchQueue.main.async { [weak self] in
                            self?.isWin = false
                        }
                    } else if message == MsgCommandConstant.updateIsEndViewTrue {
                        DispatchQueue.main.async { [weak self] in
                            self?.isEndView = true
                        }
                    } else if message == MsgCommandConstant.updateIsEndViewFalse {
                        DispatchQueue.main.async { [weak self] in
                            self?.isEndView = false
                        }
                    } else if message == MsgCommandConstant.resetAllVarToDefault {
                        DispatchQueue.main.async { [weak self] in
                            self?.resetVarToDefault()
                        }
                    } else if message == MsgCommandConstant.resetGame {
                        DispatchQueue.main.async { [weak self] in
                            self?.resetGame()
                        }
                    }
                    
                    else {
                        print("UNKNOWN COMMAND")
                    }
                } else if components.count == 2 {
                    let typeData = components[1]
                    
                    if typeData == "question" {
                        DispatchQueue.main.async { [weak self] in
                            // Handle the received question
                            self!.receivedQuestion = components[0]
                        }
                    } else {
                        print("UNKNOWN COMMAND")
                    }
                } else {
                    // Invalid message format
                    print("Invalid message format: \(receivedString)")
                }
            }
        }
        else {
            // Failed to convert data to a string
            print("Failed to convert data to a string.")
        }
        
        delegate?.didReceive(data: data, from: peerID)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
/*
 //this is auto accept
extension MultipeerController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}
*/

//handle invitation yo join a session with confirmation
extension MultipeerController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        guard
            let window = UIApplication.shared.windows.first,
            let context = context,
            let lobbyName = String(data: context, encoding: .utf8)
        else {
            return
        }
        let title = "Accept \(peerID.displayName) Lobby Invitation"
        let message = "Would you like to accept: \(lobbyName)"
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: "Decline",
            style: .cancel
        ) { _ in
            invitationHandler(false, nil)
        })
        alertController.addAction(UIAlertAction(
            title: "Accept",
            style: .default
        ) { _ in
            // 3
            invitationHandler(true, self.session)
            //save the host PeerID
            self.hostPeerID = peerID
            self.gameState = .waitingToStart
            self.navigateToWaitingStart = true
        })
        window.rootViewController?.present(alertController, animated: true)
        
    }
}

