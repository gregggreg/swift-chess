//
//  File.swift
//  
//
//  Created by Douglas Pedley on 12/1/20.
//

import Foundation

public extension Chess {
    class HumanPlayer: Player {
		
		public override init(side: Chess.Side, matchLength: TimeInterval? = nil) {
			super.init(side: side, matchLength: matchLength)
		}
		
        static let minimalHumanTimeinterval: TimeInterval = 0.1
        @Published public var chessBestMoveCallback: ChessTurnCallback?
		@Published public var initialPositionTapped: Chess.Position?
		@Published public var moveAttempt: Chess.Move? /*{
            didSet {
                if let move = moveAttempt, let callback = chessBestMoveCallback {
                    callback(move)
                    moveAttempt = nil
                    initialPositionTapped = nil
                }
            }
        }*/
		
		public override func subType() -> Chess.Player.Type {
			return Self.self
		}
		
        public override func isBot() -> Bool { return false }
        public override func turnUpdate(game: inout Chess.Game) {
            if let move = moveAttempt {
                // Premove baby!
                moveAttempt = nil
                game.delegate?.gameAction(.makeMove(move: move))
            } else {
                weak var weakDelegate = game.delegate
                chessBestMoveCallback = { move in
                    guard let delegate = weakDelegate else { return }
                    delegate.gameAction(.makeMove(move: move))
                }
            }
        }
        public override func prepareForGame() {
            // Washes hands
        }
        public override func timerRanOut() {
            // This is where we will message the human that the game is over.
        }
        public func canTap(in game: Chess.Game) -> Bool {
            let status = game.computeGameStatus()
            switch status {
            case .active, .paused, .notYetStarted:
                return true
            case .drawBecauseOfInsufficientMatingMaterial, .drawByMoves, .drawByRepetition,
                 .mate, .unknown, .resign, .timeout, .stalemate:
                return false
            }
        }
		
		enum CodingKeys: CodingKey {
			case initialPositionTapped
			case moveAttempt
		}
		
		required public init(from decoder: Decoder) throws {
			try super.init(from: decoder)
			let container = try decoder.container(keyedBy: CodingKeys.self)
			initialPositionTapped = try? container.decodeIfPresent(Chess.Position.self, forKey: .initialPositionTapped)
			moveAttempt = try? container.decodeIfPresent(Chess.Move.self, forKey: .moveAttempt)
		}
		
		public override func encode(to encoder: Encoder) throws {
			try super.encode(to: encoder)
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encodeIfPresent(self.initialPositionTapped, forKey: .initialPositionTapped)
			try container.encodeIfPresent(self.moveAttempt, forKey: .moveAttempt)
		}
    }
}
