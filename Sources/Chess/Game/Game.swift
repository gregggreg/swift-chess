//
//  Game.swift
//
//  Created by Douglas Pedley on 1/5/19.
//

import Foundation
import Combine

public protocol ChessGameDelegate: AnyObject, Codable {
    func gameAction(_ action: Chess.GameAction)
}

public extension Chess {
	struct Game : Codable {
        private var botPausedMove: Chess.Move?
		public weak var delegate: ChessGameDelegate?
        public var userPaused = true
        public var blackDungeon: [Chess.Piece] = [] // Captured white pieces
        public var whiteDungeon: [Chess.Piece] = []
        public var board = Chess.Board(populateExpensiveVisuals: true)
        public var black: Player
        public var white: Player
		public var blackType: String
		public var whiteType: String
        public var round: Int = 1
        public var pgn: Chess.Game.PortableNotation
        public var info: GameUpdate?
        public var kingFlash = false
        public var activePlayer: Player {
            switch board.playingSide {
            case .white:
                return white
            case .black:
                return black
            }
        }
        public var playerFactory = PlayerFactorySettings()
        public init(gameDelegate: ChessGameDelegate? = nil) {
            self.init(.init(side: .white), against: .init(side: .black), gameDelegate: gameDelegate)
        }
        public init(_ player: Player, against challenger: Player, gameDelegate: ChessGameDelegate? = nil) {
            self.delegate = gameDelegate
            guard player.side == challenger.side.opposingSide else {
                fatalError("Can't play with two \(player.side)s")
            }
            let white: Player
            let black: Player
            if player.side == .white {
                white = player
                black = challenger
            } else {
                black = player
                white = challenger
            }
            self.pgn = Self.freshPGN(black, white)
            self.white = white
			self.whiteType = String(describing: white.subType())
            self.black = black
			self.blackType = String(describing: black.subType())
            self.board.resetBoard()
        }
        static func freshPGN(_ blackPlayer: Chess.Player, _ whitePlayer: Chess.Player) -> Chess.Game.PortableNotation {
            Chess.Game.PortableNotation(eventName: "Game \(Date())",
                                              site: PortableNotation.deviceSite(),
                                              date: Date(),
                                              round: 1,
                                              black: blackPlayer.pgnName,
                                              white: whitePlayer.pgnName,
                                              result: .other,
                                              tags: [:],
                                              moves: [])
        }
		public mutating func reset() {
			botPausedMove = nil
			round = 1
			pgn = Self.freshPGN(black, white)
			clearDungeons()
			clearActivePlayerSelections()
			board.resetBoard()
			kingFlash = false
			info = nil
		}
		public mutating func update(from other: Chess.Game) {
			botPausedMove = other.botPausedMove
			round = other.round
			pgn = other.pgn
			whiteDungeon = other.whiteDungeon
			blackDungeon = other.blackDungeon
			clearActivePlayerSelections()
			board.update(from: other.board)
			kingFlash = other.kingFlash
			info = other.info
		}
        public mutating func start() {
            userPaused = false
            nextTurn()
        }
        public mutating func pause() {
            userPaused = true
        }
        public mutating func clearDungeons() {
            blackDungeon.removeAll()
            whiteDungeon.removeAll()
        }
        public mutating func nextTurn() {
            activePlayer.turnUpdate(game: &self)
        }
        public mutating func changeSides(_ side: Chess.Side) {
            board.playingSide = side
            if board.populateExpensiveVisuals {
                board.isInCheck = board.square(board.squareForActiveKing.position,
                                               canBeAttackedBy: side.opposingSide)
            } else {
                board.isInCheck = nil
            }
        }
        public mutating func execute(move: Chess.Move) {
            guard move.continuesGameplay else {
                if move.isResign || move.isTimeout {
                    appendLedger(move, pieceType: .king, captureType: nil)
                    return
                }
                Chess.log.critical("Need to diagnose this scenario, shouldn't come here.")
                return
            }
            // Create a mutable copy, moving may add side effects.
            var moveAttempt = move
            let moveTry = board.attemptMove(&moveAttempt)
            switch moveTry {
            case .success(let capturedPiece):
                executeSuccess(move: moveAttempt, capturedPiece: capturedPiece)
            case .failure(let limitation):
                Chess.log.critical("Move failed: \(move.description) \(limitation)")
                if let human = activePlayer as? Chess.HumanPlayer {
                    executeFailed(human: human, failed: moveAttempt, with: limitation)
                } else {
                    // a bot failed to move, for some this means resign
                    let winningSide = board.playingSide.opposingSide
                    pgn.result = winningSide == .black ? .blackWon : .whiteWon
                    Chess.log.debug("\nUnknown: \n\(pgn.formattedString)")
                }
            }
        }
        public mutating func setRobotPlaybackSpeed(_ responseDelay: TimeInterval) {
            if let white = white as? Chess.Robot {
                white.responseDelay = responseDelay
            }
            if let black = black as? Chess.Robot {
                black.responseDelay = responseDelay
            }
        }
        public func robotPlaybackSpeed() -> TimeInterval {
            if let white = white as? Chess.Robot {
                return white.responseDelay
            }
            if let black = black as? Chess.Robot {
                return black.responseDelay
            }
            return 1
        }
        mutating private func executeSuccess(move: Chess.Move, capturedPiece: Chess.Piece?) {
            if let piece = capturedPiece {
                // The captured piece is thrown in the dungeon
                switch piece.side {
                case .black:
                    whiteDungeon.append(piece)
                case .white:
                    blackDungeon.append(piece)
                }
                Chess.Sounds().capture()
            } else {
                Chess.Sounds().move()
            }
            let annotatedMove = Chess.Game.AnnotatedMove(side: move.side,
                                                         move: move.PGN ?? "??",
                                                         fenAfterMove: board.FEN,
                                                         annotation: nil)
            pgn.moves.append(annotatedMove)
            let player: Chess.Player? = black.isBot() ? ( white.isBot() ? nil : white) : black
            if let human = player, human.side == move.side {
                clearActivePlayerSelections()
            }
            // Note piece is at `move.end` now as the move is complete.
            if let moved = board.squares[move.end].piece {
                // Lastly add this move to our ledger
                appendLedger(move, pieceType: moved.pieceType, captureType: capturedPiece?.pieceType)
            }
        }
        mutating public func appendLedger(_ move: Chess.Move,
                                          pieceType: Chess.PieceType,
                                          captureType: Chess.PieceType?) {
            if board.playingSide == .black {
                if board.turns.count == 0 {
                    // This should only happen in board variants.
                    board.turns.append(Chess.Turn(0, white: move, black: nil))
                } else {
                    // This is the usual black move follows white, so the turn exists in the stack.
                    board.turns[board.turns.count - 1].black = move
                }
                board.fullMoves += 1
            } else {
                let index = board.turns.count
                board.turns.append(Chess.Turn(index, white: move, black: nil))
            }
            if captureType != nil || pieceType == .pawn {
                board.fiftyMovesCount = 0
            } else {
                board.fiftyMovesCount += 1
            }
            let boardKey = board.squares.reduce("") { key, square -> String in
                guard let fen = square.piece?.FEN else {
                    return key + "-"
                }
                return key + fen
            }
            if let repCount = board.repetitionMap[boardKey] {
                board.repetitionMap[boardKey] = repCount + 1
            } else {
                board.repetitionMap[boardKey] = 1
            }
        }
        mutating public func clearActivePlayerSelections() {
            for idx in 0..<64 {
                board.squares[idx].selected = false
                board.squares[idx].targetedBySelected = false
            }
            if let human = black as? HumanPlayer {
                human.initialPositionTapped = nil
            }
            if let human = white as? HumanPlayer {
                human.initialPositionTapped = nil
            }
        }
        mutating public func executeFailed(human: Chess.HumanPlayer,
                                           failed move: Chess.Move,
                                           with reason: Chess.Move.Limitation) {
            clearActivePlayerSelections()
            switch reason {
            case .invalidAttackForPiece, .invalidMoveForPiece, .noPieceToMove,
                 .notYourTurn, .sameSideAlreadyOccupiesDestination:
                // Nothing to see here, just humans
                break
            case .kingWouldBeUnderAttackAfterMove:
                delegate?.gameAction(.kingFlash(active: true))
                Chess.Sounds().check()
            case .unknown:
                Chess.log.info("Human's move had unknown limitation.")
            }
        }
		
		enum CodingKeys: CodingKey {
			case botPausedMove
			case userPaused
			case blackDungeon
			case whiteDungeon
			case board
			case black
			case blackType
			case white
			case whiteType
			case round
			case pgn
			case info
			case kingFlash
		}
		
		public init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			botPausedMove = try? container.decodeIfPresent(Chess.Move.self, forKey: .botPausedMove)
			userPaused = try container.decode(Bool.self, forKey: .userPaused)
			blackDungeon = try container.decode([Chess.Piece].self, forKey: .blackDungeon)
			whiteDungeon = try container.decode([Chess.Piece].self, forKey: .whiteDungeon)
			board = try container.decode(Chess.Board.self, forKey: .board)
			whiteType = try container.decode(String.self, forKey: .whiteType)
			white = try Chess.Game.decodePlayer(whiteType, key: .white, container: container)
			blackType = try container.decode(String.self, forKey: .blackType)
			black = try Chess.Game.decodePlayer(blackType, key: .black, container: container)
			round = try container.decode(Int.self, forKey: .round)
			pgn = try container.decode(Chess.Game.PortableNotation.self, forKey: .pgn)
			info = try? container.decodeIfPresent(GameUpdate.self, forKey: .info)
			kingFlash = try container.decode(Bool.self, forKey: .kingFlash)
		}
		
		private static func decodePlayer(_ type: String, key: Chess.Game.CodingKeys, container: KeyedDecodingContainer<Chess.Game.CodingKeys>) throws -> Player {
			if type == String(describing: Chess.HumanPlayer.self) {
				return try container.decode(HumanPlayer.self, forKey: key)
			}
			if type == String(describing: Chess.Robot.MindyMaxBot.self) {
				return try container.decode(Robot.MindyMaxBot.self, forKey: key)
			}
			if type == String(describing: Chess.Robot.MontyCarloBot.self) {
				return try container.decode(Robot.MontyCarloBot.self, forKey: key)
			}
			if type == String(describing: Chess.Robot.PlaybackBot.self) {
				return try container.decode(Robot.PlaybackBot.self, forKey: key)
			}
			if type == String(describing: Chess.Robot.CautiousBot.self) {
				return try container.decode(Robot.CautiousBot.self, forKey: key)
			}
			if type == String(describing: Chess.Robot.GreedyBot.self) {
				return try container.decode(Robot.GreedyBot.self, forKey: key)
			}
			if type == String(describing: Chess.Robot.self) {
				return try container.decode(Robot.self, forKey: key)
			}
			return try container.decode(Player.self, forKey: key)
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encodeIfPresent(botPausedMove, forKey: .botPausedMove)
			try container.encode(userPaused, forKey: .userPaused)
			try container.encode(blackDungeon, forKey: .blackDungeon)
			try container.encode(whiteDungeon, forKey: .whiteDungeon)
			try container.encode(board, forKey: .board)
			try container.encode(black, forKey: .black)
			try container.encode(white, forKey: .white)
			try container.encode(String(describing: black.subType()), forKey: .blackType)
			try container.encode(String(describing: white.subType()), forKey: .whiteType)
			try container.encode(round, forKey: .round)
			try container.encode(pgn, forKey: .pgn)
			try container.encodeIfPresent(info, forKey: .info)
			try container.encode(kingFlash, forKey: .kingFlash)
		}
    }
}
