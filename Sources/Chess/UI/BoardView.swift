//
//  BoardView.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/24/20.
//

import SwiftUI
import Combine

public struct BoardView: View {
	
	public var pieceMaker : (Int)->AnyView = { position in
		AnyView(DraggablePiece(position: position))
	}
	
    @State public var store: ChessStore
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
                        .onTapGesture {
                            store.gameAction(.userTappedSquare(position: idx))
                        }
                    }
                }
            }
            /*.frame(width: geometry.size.minimumLength,
                   height: geometry.size.minimumLength,
                   alignment: .center)*/
            .drawingGroup()
        }
    }
	public init() {
		let white = Chess.HumanPlayer(side: .white)
		let black = Chess.HumanPlayer(side: . black)
		let game = Chess.Game(white, against: black)
		let store = ChessStore(game: game)
		self.store = store
	}
	public init(store: ChessStore, pieceMaker: @escaping (Int)->AnyView) {
		self.store = store
		self.pieceMaker = pieceMaker
	}
}

struct BoardViewPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
			HStack {
				Spacer()
				BoardView()
					.environmentObject(previewChessStore)
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
