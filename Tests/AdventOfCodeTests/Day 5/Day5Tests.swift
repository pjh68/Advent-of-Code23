import XCTest
@testable import AdventOfCode

final class Day5Tests: XCTestCase, SolutionTest {
    typealias SUT = Day5
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 35)
    }
    
    func testRangeSplit() {
        let bigRange = SeedRange(startIndex: 5, length: 15)
        let sliceRange = SeedRange(startIndex: 10, length: 5)
        let (prev, within, after) = bigRange.split(by: sliceRange)
        XCTAssertEqual(prev!.startIndex, 5)
        XCTAssertEqual(prev!.endIndex, 9)
        XCTAssertEqual(within!.startIndex, 10)
        XCTAssertEqual(within!.endIndex, 14)
        XCTAssertEqual(after!.startIndex, 15)
        XCTAssertEqual(after!.endIndex, 19)
    }
    
    func testRangeSplit2() {
        let bigRange = SeedRange(startIndex: 10, length: 15)
        let sliceRange = SeedRange(startIndex: 10, length: 5)
        let (prev, within, after) = bigRange.split(by: sliceRange)
        XCTAssertNil(prev)
        XCTAssertEqual(within!.startIndex, 10)
        XCTAssertEqual(within!.endIndex, 14)
        XCTAssertEqual(after!.startIndex, 15)
        XCTAssertEqual(after!.endIndex, 24)
    }
    
    func testRangeSplit3() {
        let bigRange = SeedRange(startIndex: 17, length: 15)
        let sliceRange = SeedRange(startIndex: 10, length: 5)
        let (prev, within, after) = bigRange.split(by: sliceRange)
        XCTAssertNil(prev)
        XCTAssertNil(within)
        XCTAssertEqual(after!.startIndex, 17)
        XCTAssertEqual(after!.endIndex, 31)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 46)
    }
}
