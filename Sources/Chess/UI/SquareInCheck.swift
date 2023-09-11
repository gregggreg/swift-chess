//
//  SquareInCheck.swift
//
//
//  Created by Greg Gardner on 9/11/23.
//

import SwiftUI

public struct SquareInCheck: View {
	@ObservedObject public var store: ChessStore
	let position: Chess.Position
	public var body: some View {
		let board = store.game.board
		guard board.isInCheck ?? false,
			  board.squareForActiveKing.position == position else {
			return AnyView(EmptyView())
		}
		let highlight = Rectangle()
			.fill(Self.inCheckHighlight)
			.aspectRatio(1, contentMode: .fill)
		return AnyView(highlight)
	}
	static let inCheckHighlight = Color(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: 0.3)
}
