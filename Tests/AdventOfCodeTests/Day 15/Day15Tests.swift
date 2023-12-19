import XCTest
@testable import AdventOfCode

final class Day15Tests: XCTestCase, SolutionTest {
    typealias SUT = Day15
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 1320)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 145)
    }
}
