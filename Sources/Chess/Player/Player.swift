//
//  Player.swift
//
//  Created by Douglas Pedley on 1/6/19.
//

import Foundation

public typealias ChessTurnCallback = (Chess.Move) -> Void

extension Chess {
	open class Player : Codable {
        public var side: Side
        public var timeLeft: TimeInterval?
        public var currentMoveStartTime: Date?
        public var firstName: String?
        public var lastName: String?
        var pgnName: String {
            guard let firstName = firstName, let lastName = lastName else {
                return "??"
            }
            return "\(lastName), \(firstName)"
        }
        public init(side: Side, matchLength: TimeInterval? = nil) {
            self.side = side
            self.timeLeft = matchLength
        }
		
		enum CodingKeys: CodingKey {
			case side
			case timeLeft
			case currentMoveStartTime
			case firstName
			case lastName
		}
		
		required public init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			side = try container.decode(Side.self, forKey: .side)
			timeLeft = try? container.decodeIfPresent(TimeInterval.self, forKey: .timeLeft)
			currentMoveStartTime = try? container.decodeIfPresent(Date.self, forKey: .currentMoveStartTime)
			firstName = try? container.decodeIfPresent(String.self, forKey: .firstName)
			lastName = try? container.decodeIfPresent(String.self, forKey: .lastName)
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(side, forKey: .side)
			try container.encodeIfPresent(timeLeft, forKey: .timeLeft)
			try container.encodeIfPresent(currentMoveStartTime, forKey: .currentMoveStartTime)
			try container.encodeIfPresent(firstName, forKey: .firstName)
			try container.encodeIfPresent(lastName, forKey: .lastName)
		}
		
		public func subType() -> Chess.Player.Type {
			return Self.self
		}
		
        public func prepareForGame() {
            fatalError("This method is meant to be overriden by subclasses")
        }
        public func isBot() -> Bool {
            fatalError("This method is meant to be overriden by subclasses")
        }
        public func timerRanOut() {
            fatalError("This method is meant to be overriden by subclasses")
        }
        public func turnUpdate(game: inout Chess.Game) {
            fatalError("This method is meant to be overriden by subclasses")
        }
        public func iconName() -> String {
            switch side {
            case .black:
                return "crown.fill"
            case .white:
                return "crown"
            }
        }
        open func menuName() -> String {
            if self is Chess.Robot.CautiousBot {
                return "CautiousBot"
            }
            if self is Chess.Robot.GreedyBot {
                return "GreedyBot"
            }
            if self is Chess.Robot.MindyMaxBot {
                return "MindyMax"
            }
            if self is Chess.Robot.MontyCarloBot {
                return "MontyCarlo"
            }
            if self is Chess.Robot {
                return "RandomBot"
            }
            return firstName ?? lastName ?? "You"
        }
    }
}
