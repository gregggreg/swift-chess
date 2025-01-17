//
//  MontyCarlo.swift
//  
//
//  Created by Douglas Pedley on 12/21/20.
//

import Foundation
import GameplayKit

public extension Chess.Robot {
    /// A monty carlo strategist using GKGameModel
    class MontyCarloBot: Chess.Player {
        var board = Chess.BoardVariant(originalFEN: Chess.Board.startingFEN)
        let strategist: GKMonteCarloStrategist
        /// A few overrides from Chess.Player
        public override func isBot() -> Bool { return true }
        public override func prepareForGame() { }
        public override func timerRanOut() {}
        public override func iconName() -> String {
            switch side {
            case .black:
                return "flame.fill"
            case .white:
                return "flame"
            }
        }
        /// The main override from Chess.Player
        ///
        /// This is called by the game engine when this Robot Player should make a move.
        /// After a delay it evaulates the board that it was given.
        /// The move from the evaluation is sent to the ChessStore
        ///
        /// - Parameter game: The game that is being played. This is immutable. The ChessStore is used for updates.
        public override func turnUpdate(game: inout Chess.Game) {
            guard game.board.playingSide == side else {
                Chess.log.debug("Tried to turnUpdate when not my turn: \(side)")
                return
            }
            guard let delegate = game.delegate else {
                Chess.log.critical("Cannot run a game turn without a game delegate.")
                return
            }
            board = Chess.BoardVariant(originalFEN: game.board.FEN)
            strategist.gameModel = board
            strategist.randomSource = GKARC4RandomSource()
			guard let strategy = self.strategist.bestMoveForActivePlayer() else {
				let square = game.board.squareForActiveKing
				guard square.piece?.side == self.side else {
					Chess.log.critical("Misconfigured board, bot cannot find it's own king.")
					return
				}
				let move = self.side.resigns(king: square.position)
				ChessStore.makeMove(move, game: &game)
				return
			}
			guard let variant = (strategy as? Chess.GameModelUpdate)?.variant,
				  let move = variant.changes.last else {
				Chess.log.critical("Misconfigured strategist, model update not validz.")
				return
			}
			ChessStore.makeMove(move, game: &game)
        }
        public init(side: Chess.Side, budget: Int = 2, explore: Int = 2) {
            let monty = GKMonteCarloStrategist()
            monty.budget = budget
            monty.explorationParameter = explore
            self.strategist = monty
            super.init(side: side, matchLength: nil)
        }
		
		enum CodingKeys: CodingKey {
			case budget
			case explore
		}
		
		required public init(from decoder: Decoder) throws {
			let mixmax = GKMonteCarloStrategist()
			self.strategist = mixmax
			try super.init(from: decoder)
			let container = try decoder.container(keyedBy: CodingKeys.self)
			let budget = try container.decode(Int.self, forKey: .budget)
			let explore = try container.decode(Int.self, forKey: .explore)
			self.strategist.budget = budget
			self.strategist.explorationParameter = explore
		}
		
		public override func encode(to encoder: Encoder) throws {
			try super.encode(to: encoder)
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(self.strategist.budget, forKey: .budget)
			try container.encode(self.strategist.explorationParameter, forKey: .explore)
		}
		
		public override func subType() -> Chess.Player.Type {
			return Self.self
		}
	}
}
