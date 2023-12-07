import XCTest
@testable import AdventOfCode

final class Day7Tests: XCTestCase, SolutionTest {
    typealias SUT = Day7
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 6440)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 5905)
    }
    
    func testBestHand() {
        let b1 = Hand.bestHand("22J89")
        XCTAssertEqual(b1, "22289")
    }
    
}
