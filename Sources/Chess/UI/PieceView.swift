//
//  ChessPiece.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/19/20.
//

import Foundation
import SwiftUI

public struct DraggablePiece: View {
    @StateObject var store: ChessStore
    let position: Chess.Position
    public var body: some View {
        guard let piece = store.game.board.squares[position].piece else {
            return AnyView(EmptyView())
        }
        return AnyView(PieceView(piece: piece)
            .onDrag {
                store.gameAction(.userDragged(position: position))
                return NSItemProvider(object: self.position.FEN as NSString)
            }
        )
    }
}

/// PieceView
///
/// This is the view used for the chess pieces.
/// The artwork controls which piece you see
/// The style has the colors.
public struct PieceView: View {
    let piece: Chess.Piece
    let addDetails: Bool
    let lineWidth: CGFloat
	var pieceStyle: PieceStyle
	
	@ViewBuilder
    func details(piece: Chess.Piece) -> some View {
		if addDetails {
			PieceShape.Details(artwork: piece.artwork)
				.stroke(pieceStyle.highlight, lineWidth: lineWidth * 1.5)
		}
		else {
			EmptyView()
		}
    }
    public var body: some View {
        ZStack {
            // Paint the piece
            PieceShape(artwork: piece.artwork)
                .foregroundColor(pieceStyle.fill)
            // Then outline it
            PieceShape(artwork: piece.artwork)
                .stroke(pieceStyle.outline,
                        lineWidth: lineWidth)
            details(piece: piece)
        }
    }
    public init(piece: Chess.Piece,
                addDetails: Bool = true,
                lineWidth: CGFloat = 1,
				overrideStyle: PieceStyle? = nil) {
        self.piece = piece
        self.addDetails = addDetails
        self.lineWidth = lineWidth
		self.pieceStyle = overrideStyle ?? piece.style
    }
}

// False positives disabled.
struct PieceViewPreview: PreviewProvider {
    static var previews: some View {
        ZStack {
            PieceView(piece: .init(side: .black,
                                   pieceType: .queen),
                      lineWidth: 2)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: -50)
            PieceView(piece: .init(side: .white,
                                   pieceType: .bishop),
                      lineWidth: 2)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: -50)
            PieceView(piece: .init(side: .white,
                                   pieceType: .king),
                      lineWidth: 2)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: 50)
            PieceView(piece: .init(side: .black,
                                   pieceType: .knight),
                      lineWidth: 2)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: 50)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}
