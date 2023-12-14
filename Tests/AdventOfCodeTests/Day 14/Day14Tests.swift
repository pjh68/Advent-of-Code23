import XCTest
@testable import AdventOfCode

final class Day14Tests: XCTestCase, SolutionTest {
    typealias SUT = Day14
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 136)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 64)
    }
}
