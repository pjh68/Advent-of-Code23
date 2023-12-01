import XCTest
@testable import AdventOfCode

final class Day1Tests: XCTestCase, SolutionTest {
    typealias SUT = Day1
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 142)
    }
    
    func testPartTwo() throws {
        var input = """
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"""
        let sut2 = SUT(input: input)
        
        try XCTAssertEqual(sut2.calculatePartTwo(), 281)
    }
}
