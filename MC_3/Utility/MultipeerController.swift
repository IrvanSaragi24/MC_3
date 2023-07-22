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
    private var myPeerId: MCPeerID!
    private let serviceType = MCConstants.service
    
    private var session: MCSession
    private var browser: MCNearbyServiceBrowser
    private var advertiser: MCNearbyServiceAdvertiser
    private var hostPeerID: MCPeerID? //I want to save the peerID of host
    
    @Published var availableGuest: [MCPeerID] = [] // Do not use this var
    @Published var connectedGuest: [MCPeerID] = [] // Do not use this var
    @Published var allGuest: [Guest] = []
    
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
    private func sendMessage(_ message: String, to peers: [MCPeerID]) {
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
                print("from discover: ")
                print(self?.allGuest.count)
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
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
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

//handle invitation
extension MultipeerController: MCNearbyServiceAdvertiserDelegate {
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
            title: "Decline",
            style: .cancel
        ) { _ in
            // 2
            invitationHandler(false, nil)
        })
        alertController.addAction(UIAlertAction(
            title: "Accept",
            style: .default
        ) { _ in
            // 3
            invitationHandler(true, self.session)
        })
        window.rootViewController?.present(alertController, animated: true)
        
    }
}
