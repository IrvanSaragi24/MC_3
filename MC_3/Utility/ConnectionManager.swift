//
//  ConnectionManager.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 17/07/23.
//

import MultipeerConnectivity

//protocol ControllerMultipeerHandlerDelegate: AnyObject {
//    func connected(peerID: MCPeerID)
//    func disconnected(peerID: MCPeerID)
//    func didReceive(data: Data, from peerID: MCPeerID)
//}

class ConnManager: NSObject, ObservableObject {
    typealias LobbyReceivedHandler = (Lobby) -> Void
    
//    weak var delegate: ControllerMultipeerHandlerDelegate?

    private let displayName: String
    private var myPeerId: MCPeerID!
    private var session: MCSession!
    private var nearbyServiceBrowser: MCNearbyServiceBrowser!
    private var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    
    private let lobbyReceivedHandler: LobbyReceivedHandler?
    private static let service = "Dra9on"
    private var lobbyToSend: Lobby?
    
    var isReceivingHangout: Bool = false {
        didSet {
            if isReceivingHangout {
                nearbyServiceAdvertiser.startAdvertisingPeer()
                print("Started advertising")
            } else {
                nearbyServiceAdvertiser.stopAdvertisingPeer()
                print("Stopped advertising")
            }
        }
    }
    
    @Published var guests: [MCPeerID] = []
    @Published var connGuests: [MCPeerID] = []
    
    
    init(_ displayName: String, lobbyReceivedHandler: LobbyReceivedHandler? = nil) {
        self.displayName = displayName
        self.lobbyReceivedHandler = lobbyReceivedHandler

        super.init()
                
        configurePeerId()
        configureSession()
        configureServiceAdvertiser()
        configureServiceBrowser()
        
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
//        session.delegate = self
    }
    
    private func configurePeerId() {
        myPeerId = MCPeerID(displayName: displayName)
    }
    
    private func configureSession() {
            session = MCSession(
                peer: myPeerId,
                securityIdentity: nil,
                encryptionPreference: .none)
        }
    private func configureServiceAdvertiser() {
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(
            peer: myPeerId,
            discoveryInfo: nil,
            serviceType: ConnManager.service)
    }
    
    private func configureServiceBrowser() {
        nearbyServiceBrowser = MCNearbyServiceBrowser(
            peer: myPeerId,
            serviceType: ConnManager.service)
    }
    
    func startBrowsing() {
        nearbyServiceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        nearbyServiceBrowser.stopBrowsingForPeers()
    }
    
    func invitePeer(_ peerID: MCPeerID, to lobby: Lobby) {
        // 1
        lobbyToSend = lobby
        // 2
        let context = lobby.name.data(using: .utf8)
        // 3
        nearbyServiceBrowser.invitePeer(
            peerID,
            to: session,
            withContext: context,
            timeout: TimeInterval(120))
    }
    
    private func send(_ message: String, to peers: [MCPeerID]) {
        guard
          let session = session,
          let data = message.data(using: .utf8),
          !peers.isEmpty
        else { return }
        
      do {
        try session.send(data, toPeers: peers, with: .reliable)
      } catch {
        print(error.localizedDescription)
      }
    }

}

extension ConnManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        guard
            let window = UIApplication.shared.windows.first,
            // 1
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
            title: "No",
            style: .cancel
        ) { _ in
            // 2
            invitationHandler(false, nil)
        })
        alertController.addAction(UIAlertAction(
            title: "Yes",
            style: .default
        ) { _ in
            // 3
            invitationHandler(true, self.session)
        })
        window.rootViewController?.present(alertController, animated: true)
        
    }
}

extension ConnManager: MCNearbyServiceBrowserDelegate {
    func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer peerID: MCPeerID,
        withDiscoveryInfo info: [String: String]?
    ) {
        // 1
        if !guests.contains(peerID) {
            guests.append(peerID)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = guests.firstIndex(of: peerID) else { return }
        // 2
        guests.remove(at: index)
    }
}
/*
extension ConnManager: MCSessionDelegate {
  func session(
    _ session: MCSession,
    peer peerID: MCPeerID,
    didChange state: MCSessionState
  ) {
    switch state {
    case .connected:
        if !connGuests.contains(peerID) {
            DispatchQueue.main.async { [weak self] in
                self?.connGuests.append(peerID)
            }
        }
      
    case .notConnected:
        if let index = connGuests.firstIndex(of: peerID) {
            DispatchQueue.main.async { [weak self] in
                self?.connGuests.remove(at: index)
            }
        }
    case .connecting:
      print("Connecting to: \(peerID.displayName)")
    @unknown default:
      print("Unknown state: \(state)")
    }
  }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = String(data: data, encoding: .utf8) else { return }
        DispatchQueue.main.async {
            self.jobReceivedHandler?(message)
        }
    }
  
  func session(
    _ session: MCSession,
    didReceive data: Data,
    fromPeer peerID: MCPeerID
  ) {
    guard let job = try? JSONDecoder()
      .decode(JobModel.self, from: data) else { return }
    DispatchQueue.main.async {
      self.jobReceivedHandler?(job)
    }
  }

  
  func session(
    _ session: MCSession,
    didReceive stream: InputStream,
    withName streamName: String,
    fromPeer peerID: MCPeerID
  ) {}
  
  func session(
    _ session: MCSession,
    didStartReceivingResourceWithName resourceName: String,
    fromPeer peerID: MCPeerID,
    with progress: Progress
  ) {}
  
  func session(
    _ session: MCSession,
    didFinishReceivingResourceWithName resourceName: String,
    fromPeer peerID: MCPeerID,
    at localURL: URL?,
    withError error: Error?
  ) {}
}
*/
