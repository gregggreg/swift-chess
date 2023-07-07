//
//  BoardView.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/24/20.
//

import SwiftUI
import Combine

public struct DraggableBoardView : View {
	
	@State public var store: ChessStore
	
	public var body: some View {
		BoardView(pieceMaker: { position in
			DraggablePiece(position: position)
				.onTapGesture {
					store.gameAction(.userTappedSquare(position: position))
				}
		})
	}
	
}

public struct BoardView<Content>: View where Content: View {
	
    @State public var store: ChessStore
	public var pieceMaker : (Int)->Content
    public let columns: [GridItem] = .init(repeating: .chessFile, count: 8)
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(0..<64) { idx in
                        ZStack {
							SquareBackground(idx, store: store)
                            SquareMoveHighlight(idx, store: store)
                            SquareSelected(idx, store: store)
                            SquareTargeted(idx, store: store)
							pieceMaker(idx)
                        }
                    }
                }
            }
            .drawingGroup()
        }
    }
	public init(@ViewBuilder pieceMaker: @escaping (Int)->Content) {
		let white = Chess.HumanPlayer(side: .white)
		let black = Chess.HumanPlayer(side: . black)
		let game = Chess.Game(white, against: black)
		let store = ChessStore(game: game)
		self.pieceMaker = pieceMaker
		self.store = store
	}
	public init(store: ChessStore, @ViewBuilder pieceMaker: @escaping (Int)->Content) {
		self.store = store
		self.pieceMaker = pieceMaker
	}
	public static func offset(for position: Int, squareSize: CGFloat) -> CGSize {
		let row = CGFloat(position / 8)
		let y : CGFloat = (4 - row) * squareSize
		let column = position % 8
		let x : CGFloat = (4 - CGFloat(column)) * squareSize
		return CGSize(width: -x + squareSize/2, height: -y + squareSize/2)
	}
}

struct BoardViewPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
			HStack {
				Spacer()
				DraggableBoardView(store: previewChessStore)
				Spacer()
			}
            // See ChessStore+Preview.swift for ^^ this
            HStack {
                Button {
                    previewChessStore.environmentChange(.boardColor(newColor: .brown))
                } label: {
                    BoardIconView(.brown)
                }
                Button {
                    previewChessStore.environmentChange(.boardColor(newColor: .blue))
                } label: {
                    BoardIconView(.blue)
                }
                Button {
                    previewChessStore.environmentChange(.boardColor(newColor: .green))
                } label: {
                    BoardIconView(.green)
                }
                Button {
                    previewChessStore.environmentChange(.boardColor(newColor: .purple))
                } label: {
                    BoardIconView(.purple)
                }
            }
        }
    }
}
