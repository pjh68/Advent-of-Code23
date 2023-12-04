import XCTest
@testable import AdventOfCode

final class Day3Tests: XCTestCase, SolutionTest {
    typealias SUT = Day3
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 4361)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 467835)
    }
}
