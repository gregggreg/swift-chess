//
//  SideEffect.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/10/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Move {
    // TECH DEBT: Might be better to move the current king in attack stuff, and create a side effect of a move that is kingAttacked
    enum SideEffect {
        case notKnown
        case castling(rook: Int, destination: Int)
        case enPassantInvade(territory: Int, invader: Int)
        case enPassantCapture(attack: Int, trespasser: Int)
        case promotion(piece: Chess.Piece)
        case noneish // Don't make this none until we're done
        var isUnknown: Bool {
            switch self {
            case .notKnown, .noneish:
                return true
            default:
                return false
            }
        }
    }
        
    func setVerified() {
        switch sideEffect {
        case .notKnown:
            sideEffect = .noneish
        default:
            break
        }
    }
}
