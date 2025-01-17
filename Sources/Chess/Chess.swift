//
//  Chess.swift
//
//  Created by Douglas Pedley on 1/5/19.
//

import Foundation
import SwiftUI
import Combine
import Logging

// Our namespace
public enum Chess {
    public static var log: Logger = {
        var log = Logger(label: "com.dpedley.swift-chess")
        log.logLevel = Logger.Level.critical
        return log
    }()
}

struct SwiftChessPreview: PreviewProvider {
    static var sampleStore: ChessStore = {
        let store = ChessStore(game: Chess.Game.sampleGame())
        store.game.userPaused = true
        store.game.setRobotPlaybackSpeed(0.5)
        return store
    }()
    static var previews: some View {
        HStack {
			DraggableBoardView(store: sampleStore)
            VStack {
                Button("Play") {
                    sampleStore.gameAction(.startGame)
                }
                Button("Pause") {
                    sampleStore.gameAction(.pauseGame)
                }
            }
        }
    }
}
