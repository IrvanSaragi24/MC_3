//
//  ConnectionManager.swift
//  MC_3
//
//  Created by Sayed Zulfikar on 17/07/23.
//

import Foundation
import MultipeerConnectivity

class ConnectionManager: NSObject, ObservableObject {
    typealias LobbyReceivedHandler = (Lobby) -> Void

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
            serviceType: ConnectionManager.service)
    }
    
    private func configureServiceBrowser() {
        nearbyServiceBrowser = MCNearbyServiceBrowser(
            peer: myPeerId,
            serviceType: ConnectionManager.service)
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
    
    
}

extension ConnectionManager: MCNearbyServiceAdvertiserDelegate {
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

extension ConnectionManager: MCNearbyServiceBrowserDelegate {
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
