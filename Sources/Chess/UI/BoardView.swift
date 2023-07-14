//
//  BoardView.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/24/20.
//

import SwiftUI
import Combine

public struct DraggableBoardView : View {
	
	@StateObject public var store: ChessStore
	
	public var body: some View {
		BoardView(store: store, pieceMaker: { position, squareSize in
			DraggablePiece(store: store, position: position)
				.onTapGesture {
					store.gameAction(.userTappedSquare(position: position))
				}
		})
	}
	
}

public struct BoardView<Content>: View where Content: View {
	
    var store: ChessStore
	var pieceMaker : (Int, CGFloat)->Content
	let columns: [GridItem] = .init(repeating: .chessFile, count: 8)
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(0..<64) { idx in
                        ZStack {
							SquareBackground(store: store, position: idx)
							SquareMoveHighlight(store: store, position: idx)
							SquareSelected(store: store, position: idx)
							SquareTargeted(store: store, position: idx)
                        }
                    }
                }
				ForEach(0..<64) { idx in
					let squareSize = geometry.size.width/8
					pieceMaker(idx, squareSize)
						.offset(BoardView.offset(for: idx, squareSize: squareSize))
						.frame(width: squareSize, height: squareSize)
				}
            }
            .drawingGroup()
        }
    }
	public init(store: ChessStore, @ViewBuilder pieceMaker: @escaping (Int, CGFloat)->Content) {
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
