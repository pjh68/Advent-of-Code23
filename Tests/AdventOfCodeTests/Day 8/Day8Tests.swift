import XCTest
@testable import AdventOfCode

final class Day8Tests: XCTestCase, SolutionTest {
    typealias SUT = Day8
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 6)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 6)
    }
    
    func testGhostNodes() {
        let n = Node(key: "BCA",left: "CCC",right: "DDD")
        XCTAssertTrue(n.ghostAnode)
        let n2 = Node(key: "BCV",left: "CCC",right: "DDD")
        XCTAssertTrue(!n2.ghostAnode)
    }

}
