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
    
    @Published var availableGuest: [MCPeerID] = [] // Do not use this var
    @Published var connectedGuest: [MCPeerID] = [] // Do not use this var
    @Published var allGuest: [Guest] = []
    @Published var gameState: GameState = .waitingForInvitation
    @Published var receivedQuestion: String = "QuestionDefault"
    var isPlayer: Bool = false
    var isHost : Bool = false
    var isChoosingView: Bool = false
    
    @Published var votes: [Vote] = []
    
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
                session.disconnect()
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
        print(peerID.displayName)
        if !availableGuest.contains(peerID) {
            availableGuest.append(peerID)
        }
        
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
        guard let index = availableGuest.firstIndex(of: peerID) else { return }
        
        availableGuest.remove(at: index)
        
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
//            if let index = connectedGuest.firstIndex(of: peerID) {
//                DispatchQueue.main.async { [weak self] in
//                    self?.connectedGuest.remove(at: index)
//                }
//            }
//
//            if let index = allGuest.firstIndex(where: { $0.id == peerID && $0.status == .discovered }) {
//                // Remove the guest at the found index
//                allGuest.remove(at: index)
//            }
            
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
                // Split the received string using the delimiter (":")
                let components = receivedString.components(separatedBy: ":")
                if components.count == 1 {
                    let message = components[0]

                    // Check if the message is a command or other type of data
                    if message == MsgCommandConstant.startListen {
                        DispatchQueue.main.async { [weak self] in
                            // Handle the "Start Listen" command
                            self?.gameState = .listening
                        }
                    } else if message == MsgCommandConstant.startQuiz {
                        DispatchQueue.main.async { [weak self] in
                            // Handle the "Start Quiz" command
                            self?.isChoosingView = true
                        }
                    } else if message == MsgCommandConstant.disconnect {
                        DispatchQueue.main.async { [weak self] in
                            // Handle disconnect
                            self?.session.disconnect()
                            self?.gameState = .waitingForInvitation
                            self?.isAdvertising = true
                            
                        }
                    } else if message == MsgCommandConstant.updatePlayerTrue {
                        DispatchQueue.main.async { [weak self] in
                            self?.isPlayer = true
                        }
                    } else if message == MsgCommandConstant.updatePlayerFalse {
                        DispatchQueue.main.async { [weak self] in
                            self?.isPlayer = false
                        }
                    }
                    else {
                        // Handle other types of commands or messages if needed
                    }
                } else if components.count == 2 {
                    let question = components[0]
                    let typeData = components[1]

                    if typeData == "question" {
                        DispatchQueue.main.async { [weak self] in
                            // Handle the received question
                            self!.receivedQuestion = question
                        }
                    } else if typeData == "VoteStatus" {
                        // Handle other types of data if needed
                        let voteStatus = VoteStatus(rawValue: components[0])
                        let vote = Vote(voterID: peerID, status: voteStatus ?? .null)
                        updateVotes(vote: vote)

                        // Update UI with live vote count
//                        let yesVotes = countYesVotes()
//                        let noVotes = countNoVotes()
//                        let nullVotes = countNullVotes()
//                        let guestsVoted = countGuestsVoted()
//                        let connectedGuests = countConnectedGuests()

                        // Now you can use the above vote counts to update your UI and show live updates to the user.
                        // For example, you can update labels to display the vote count.
                    } else {
                        
                    }
                } else {
                    // Invalid message format
                    print("Invalid message format: \(receivedString)")
                }
            } else {
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
        })
        window.rootViewController?.present(alertController, animated: true)
        
    }
}

extension MultipeerController {

    // Function to update votes when a vote is received from a guest
    func updateVotes(vote: Vote) {
        DispatchQueue.main.async {
            if let index = self.votes.firstIndex(where: { $0.voterID == vote.voterID }) {
                // Remove the existing vote for the same voterID
                self.votes[index].status = vote.status
            } else {
                // Add the vote to the votes array
                self.votes.append(vote)
            }
        }
    }

    // Function to calculate the total count of "Yes" votes
    func countYesVotes() -> Int {
        return votes.filter({ $0.status == .yes }).count
    }

    // Function to calculate the total count of "No" votes
    func countNoVotes() -> Int {
        return votes.filter({ $0.status == .no }).count
    }

    // Function to calculate the total count of "Null" votes (guests who haven't voted)
    func countNullVotes() -> Int {
        return votes.filter({ $0.status == .null }).count
    }

    // Function to calculate the total number of connected guests (excluding referees)
    func countConnectedGuests() -> Int {
        return session.connectedPeers.filter({ $0 != hostPeerID }).count
    }

    // Function to calculate the total number of connected guests who have voted
    func countGuestsVoted() -> Int {
        return votes.count
    }
    
    func countNonNullVotes() -> Int {
        return votes.filter({ $0.status != .null }).count
    }
}

