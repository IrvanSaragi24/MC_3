//
//  MultipeerController+HandleCommands.swift
//  MC_3
//
//  Created by Hanifah BN on 20/08/23.
//

import Foundation
import MultipeerConnectivity

extension MultipeerController {
    // Handle data received
    func handleChoosingViewCommands(_ message: String) {
        if message == MsgCommandConstant.updateIsChoosingViewTrue {
            DispatchQueue.main.async { [weak self] in
                self?.isChoosingView = true
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.isChoosingView = false
            }
        }
    }

    func handleEndViewCommands(_ message: String) {
        if message == MsgCommandConstant.updateIsEndViewTrue {
            DispatchQueue.main.async { [weak self] in
                self?.isEndView = true
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.isEndView = false
            }
        }
    }

    func handleUpdatePlayerCommands(_ message: String) {
        if message == MsgCommandConstant.updatePlayerTrue {
            DispatchQueue.main.async { [weak self] in
                self?.isPlayer = true
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.isPlayer = false
            }
        }
    }

    func handleWinLoseCommands(_ message: String) {
        if message == MsgCommandConstant.updateIsWinTrue {
            DispatchQueue.main.async { [weak self] in
                self?.isWin = true
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.isWin = false
            }
        }
    }

    func handleResets(_ message: String) {
        if message == MsgCommandConstant.resetAllVarToDefault {
            DispatchQueue.main.async { [weak self] in
                self?.resetVarToDefault()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.resetGame()
            }
        }
    }

    func handleCommandMessage(_ message: String) {
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
        } else if message == MsgCommandConstant.startListen {
            DispatchQueue.main.async { [weak self] in
                // Handle the "Start Listen" command
                self?.gameState = .listening
            }
        } else if message == MsgCommandConstant.updateIsChoosingViewTrue ||
            message == MsgCommandConstant.updateIsChoosingViewFalse {
            handleChoosingViewCommands(message)
        } else if message == MsgCommandConstant.updatePlayerTrue ||
            message == MsgCommandConstant.updatePlayerFalse {
            handleUpdatePlayerCommands(message)
        } else if message == MsgCommandConstant.updateIsResultViewTrue {
            DispatchQueue.main.async { [weak self] in
                self?.isResultView = true
                self?.gameState = .result
            }
        } else if message == MsgCommandConstant.updateIsWinTrue ||
            message == MsgCommandConstant.updateIsWinFalse {
            handleWinLoseCommands(message)
        } else if message == MsgCommandConstant.updateIsEndViewTrue ||
            message == MsgCommandConstant.updateIsEndViewFalse {
            handleEndViewCommands(message)
        } else if message == MsgCommandConstant.resetAllVarToDefault ||
            message == MsgCommandConstant.resetGame {
            handleResets(message)
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let receivedString = String(data: data, encoding: .utf8) {
            if !handleReceivedCommand(receivedString) {
                let components = receivedString.components(separatedBy: ":")
                if components.count == 1 {
                    let message = components[0]
                    handleCommandMessage(message)
                } else if components.count == 2 {
                    let typeData = components[1]
                    if typeData == "question" {
                        DispatchQueue.main.async { [weak self] in
                            self!.receivedQuestion = components[0]
                        }
                    } else if typeData == "vote" {
                        if components[0] == MsgCommandConstant.voteYes {
                            DispatchQueue.main.async { [weak self] in
                                self?.yesVote += 1
                                self?.totalVote += 1
                            }
                        } else {
                            DispatchQueue.main.async { [weak self] in
                                self?.noVote += 1
                                self?.totalVote += 1
                            }
                        }
                    } else {
                        print("UNKNOWN COMMAND")
                    }
                } else {
                    print("Invalid message format: \(receivedString)")
                }
            }
        } else {
            print("Failed to convert data to a string.")
        }
        delegate?.didReceive(data: data, from: peerID)
    }
}
