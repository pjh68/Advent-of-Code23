import XCTest
@testable import AdventOfCode

final class Day11Tests: XCTestCase, SolutionTest {
    typealias SUT = Day11
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 374)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.testForPartTwo(), 8410)
    }
}
