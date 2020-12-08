import XCTest
@testable import Chess

final class PositionTests: XCTestCase {
    
    func testFENIndex() {
        XCTAssertEqual(Chess.Position(0), Chess.Position.a8)
        XCTAssertEqual(Chess.Position(1), Chess.Position.b8)
        XCTAssertEqual(Chess.Position(2), Chess.Position.c8)
        XCTAssertEqual(Chess.Position(3), Chess.Position.d8)
        XCTAssertEqual(Chess.Position(4), Chess.Position.e8)
        XCTAssertEqual(Chess.Position(5), Chess.Position.f8)
        XCTAssertEqual(Chess.Position(6), Chess.Position.g8)
        XCTAssertEqual(Chess.Position(7), Chess.Position.h8)
        
        XCTAssertEqual(Chess.Position(8), Chess.Position.a7)
        XCTAssertEqual(Chess.Position(9), Chess.Position.b7)
        XCTAssertEqual(Chess.Position(10), Chess.Position.c7)
        XCTAssertEqual(Chess.Position(11), Chess.Position.d7)
        XCTAssertEqual(Chess.Position(12), Chess.Position.e7)
        XCTAssertEqual(Chess.Position(13), Chess.Position.f7)
        XCTAssertEqual(Chess.Position(14), Chess.Position.g7)
        XCTAssertEqual(Chess.Position(15), Chess.Position.h7)
        
        XCTAssertEqual(Chess.Position(16), Chess.Position.a6)
        XCTAssertEqual(Chess.Position(17), Chess.Position.b6)
        XCTAssertEqual(Chess.Position(18), Chess.Position.c6)
        XCTAssertEqual(Chess.Position(19), Chess.Position.d6)
        XCTAssertEqual(Chess.Position(20), Chess.Position.e6)
        XCTAssertEqual(Chess.Position(21), Chess.Position.f6)
        XCTAssertEqual(Chess.Position(22), Chess.Position.g6)
        XCTAssertEqual(Chess.Position(23), Chess.Position.h6)
        
        XCTAssertEqual(Chess.Position(24), Chess.Position.a5)
        XCTAssertEqual(Chess.Position(25), Chess.Position.b5)
        XCTAssertEqual(Chess.Position(26), Chess.Position.c5)
        XCTAssertEqual(Chess.Position(27), Chess.Position.d5)
        XCTAssertEqual(Chess.Position(28), Chess.Position.e5)
        XCTAssertEqual(Chess.Position(29), Chess.Position.f5)
        XCTAssertEqual(Chess.Position(30), Chess.Position.g5)
        XCTAssertEqual(Chess.Position(31), Chess.Position.h5)
        
        XCTAssertEqual(Chess.Position(32), Chess.Position.a4)
        XCTAssertEqual(Chess.Position(33), Chess.Position.b4)
        XCTAssertEqual(Chess.Position(34), Chess.Position.c4)
        XCTAssertEqual(Chess.Position(35), Chess.Position.d4)
        XCTAssertEqual(Chess.Position(36), Chess.Position.e4)
        XCTAssertEqual(Chess.Position(37), Chess.Position.f4)
        XCTAssertEqual(Chess.Position(38), Chess.Position.g4)
        XCTAssertEqual(Chess.Position(39), Chess.Position.h4)
        
        XCTAssertEqual(Chess.Position(40), Chess.Position.a3)
        XCTAssertEqual(Chess.Position(41), Chess.Position.b3)
        XCTAssertEqual(Chess.Position(42), Chess.Position.c3)
        XCTAssertEqual(Chess.Position(43), Chess.Position.d3)
        XCTAssertEqual(Chess.Position(44), Chess.Position.e3)
        XCTAssertEqual(Chess.Position(45), Chess.Position.f3)
        XCTAssertEqual(Chess.Position(46), Chess.Position.g3)
        XCTAssertEqual(Chess.Position(47), Chess.Position.h3)
    
        XCTAssertEqual(Chess.Position(48), Chess.Position.a2)
        XCTAssertEqual(Chess.Position(49), Chess.Position.b2)
        XCTAssertEqual(Chess.Position(50), Chess.Position.c2)
        XCTAssertEqual(Chess.Position(51), Chess.Position.d2)
        XCTAssertEqual(Chess.Position(52), Chess.Position.e2)
        XCTAssertEqual(Chess.Position(53), Chess.Position.f2)
        XCTAssertEqual(Chess.Position(54), Chess.Position.g2)
        XCTAssertEqual(Chess.Position(55), Chess.Position.h2)
        
        XCTAssertEqual(Chess.Position(56), Chess.Position.a1)
        XCTAssertEqual(Chess.Position(57), Chess.Position.b1)
        XCTAssertEqual(Chess.Position(58), Chess.Position.c1)
        XCTAssertEqual(Chess.Position(59), Chess.Position.d1)
        XCTAssertEqual(Chess.Position(60), Chess.Position.e1)
        XCTAssertEqual(Chess.Position(61), Chess.Position.f1)
        XCTAssertEqual(Chess.Position(62), Chess.Position.g1)
        XCTAssertEqual(Chess.Position(63), Chess.Position.h1)
    }
    
    func testNamedPositions() {
        XCTAssertEqual(Chess.Position.a1, Chess.Position.from(rankAndFile: "a1"))
        XCTAssertEqual(Chess.Position.a2, Chess.Position.from(rankAndFile: "a2"))
        XCTAssertEqual(Chess.Position.a3, Chess.Position.from(rankAndFile: "a3"))
        XCTAssertEqual(Chess.Position.a4, Chess.Position.from(rankAndFile: "a4"))
        XCTAssertEqual(Chess.Position.a5, Chess.Position.from(rankAndFile: "a5"))
        XCTAssertEqual(Chess.Position.a6, Chess.Position.from(rankAndFile: "a6"))
        XCTAssertEqual(Chess.Position.a7, Chess.Position.from(rankAndFile: "a7"))
        XCTAssertEqual(Chess.Position.a8, Chess.Position.from(rankAndFile: "a8"))
        
        XCTAssertEqual(Chess.Position.b1, Chess.Position.from(rankAndFile: "b1"))
        XCTAssertEqual(Chess.Position.b2, Chess.Position.from(rankAndFile: "b2"))
        XCTAssertEqual(Chess.Position.b3, Chess.Position.from(rankAndFile: "b3"))
        XCTAssertEqual(Chess.Position.b4, Chess.Position.from(rankAndFile: "b4"))
        XCTAssertEqual(Chess.Position.b5, Chess.Position.from(rankAndFile: "b5"))
        XCTAssertEqual(Chess.Position.b6, Chess.Position.from(rankAndFile: "b6"))
        XCTAssertEqual(Chess.Position.b7, Chess.Position.from(rankAndFile: "b7"))
        XCTAssertEqual(Chess.Position.b8, Chess.Position.from(rankAndFile: "b8"))
        
        XCTAssertEqual(Chess.Position.c1, Chess.Position.from(rankAndFile: "c1"))
        XCTAssertEqual(Chess.Position.c2, Chess.Position.from(rankAndFile: "c2"))
        XCTAssertEqual(Chess.Position.c3, Chess.Position.from(rankAndFile: "c3"))
        XCTAssertEqual(Chess.Position.c4, Chess.Position.from(rankAndFile: "c4"))
        XCTAssertEqual(Chess.Position.c5, Chess.Position.from(rankAndFile: "c5"))
        XCTAssertEqual(Chess.Position.c6, Chess.Position.from(rankAndFile: "c6"))
        XCTAssertEqual(Chess.Position.c7, Chess.Position.from(rankAndFile: "c7"))
        XCTAssertEqual(Chess.Position.c8, Chess.Position.from(rankAndFile: "c8"))
        
        XCTAssertEqual(Chess.Position.d1, Chess.Position.from(rankAndFile: "d1"))
        XCTAssertEqual(Chess.Position.d2, Chess.Position.from(rankAndFile: "d2"))
        XCTAssertEqual(Chess.Position.d3, Chess.Position.from(rankAndFile: "d3"))
        XCTAssertEqual(Chess.Position.d4, Chess.Position.from(rankAndFile: "d4"))
        XCTAssertEqual(Chess.Position.d5, Chess.Position.from(rankAndFile: "d5"))
        XCTAssertEqual(Chess.Position.d6, Chess.Position.from(rankAndFile: "d6"))
        XCTAssertEqual(Chess.Position.d7, Chess.Position.from(rankAndFile: "d7"))
        XCTAssertEqual(Chess.Position.d8, Chess.Position.from(rankAndFile: "d8"))
        
        XCTAssertEqual(Chess.Position.e1, Chess.Position.from(rankAndFile: "e1"))
        XCTAssertEqual(Chess.Position.e2, Chess.Position.from(rankAndFile: "e2"))
        XCTAssertEqual(Chess.Position.e3, Chess.Position.from(rankAndFile: "e3"))
        XCTAssertEqual(Chess.Position.e4, Chess.Position.from(rankAndFile: "e4"))
        XCTAssertEqual(Chess.Position.e5, Chess.Position.from(rankAndFile: "e5"))
        XCTAssertEqual(Chess.Position.e6, Chess.Position.from(rankAndFile: "e6"))
        XCTAssertEqual(Chess.Position.e7, Chess.Position.from(rankAndFile: "e7"))
        XCTAssertEqual(Chess.Position.e8, Chess.Position.from(rankAndFile: "e8"))
        
        XCTAssertEqual(Chess.Position.f1, Chess.Position.from(rankAndFile: "f1"))
        XCTAssertEqual(Chess.Position.f2, Chess.Position.from(rankAndFile: "f2"))
        XCTAssertEqual(Chess.Position.f3, Chess.Position.from(rankAndFile: "f3"))
        XCTAssertEqual(Chess.Position.f4, Chess.Position.from(rankAndFile: "f4"))
        XCTAssertEqual(Chess.Position.f5, Chess.Position.from(rankAndFile: "f5"))
        XCTAssertEqual(Chess.Position.f6, Chess.Position.from(rankAndFile: "f6"))
        XCTAssertEqual(Chess.Position.f7, Chess.Position.from(rankAndFile: "f7"))
        XCTAssertEqual(Chess.Position.f8, Chess.Position.from(rankAndFile: "f8"))
        
        XCTAssertEqual(Chess.Position.g1, Chess.Position.from(rankAndFile: "g1"))
        XCTAssertEqual(Chess.Position.g2, Chess.Position.from(rankAndFile: "g2"))
        XCTAssertEqual(Chess.Position.g3, Chess.Position.from(rankAndFile: "g3"))
        XCTAssertEqual(Chess.Position.g4, Chess.Position.from(rankAndFile: "g4"))
        XCTAssertEqual(Chess.Position.g5, Chess.Position.from(rankAndFile: "g5"))
        XCTAssertEqual(Chess.Position.g6, Chess.Position.from(rankAndFile: "g6"))
        XCTAssertEqual(Chess.Position.g7, Chess.Position.from(rankAndFile: "g7"))
        XCTAssertEqual(Chess.Position.g8, Chess.Position.from(rankAndFile: "g8"))
        
        XCTAssertEqual(Chess.Position.h1, Chess.Position.from(rankAndFile: "h1"))
        XCTAssertEqual(Chess.Position.h2, Chess.Position.from(rankAndFile: "h2"))
        XCTAssertEqual(Chess.Position.h3, Chess.Position.from(rankAndFile: "h3"))
        XCTAssertEqual(Chess.Position.h4, Chess.Position.from(rankAndFile: "h4"))
        XCTAssertEqual(Chess.Position.h5, Chess.Position.from(rankAndFile: "h5"))
        XCTAssertEqual(Chess.Position.h6, Chess.Position.from(rankAndFile: "h6"))
        XCTAssertEqual(Chess.Position.h7, Chess.Position.from(rankAndFile: "h7"))
        XCTAssertEqual(Chess.Position.h8, Chess.Position.from(rankAndFile: "h8"))
    }

    static var allTests = [
        ("testFENIndex", testFENIndex),
        ("testNamedPositions", testNamedPositions)
    ]
}
