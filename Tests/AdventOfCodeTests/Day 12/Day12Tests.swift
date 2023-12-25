import XCTest
@testable import AdventOfCode

final class Day12Tests: XCTestCase, SolutionTest {
    typealias SUT = Day12
    
    //MARK: - small units
    func testSingle() throws {
        let testdata = "?###???????? 3,2,1"
        let cr = ConditionRecord(input: testdata)

        try XCTAssertEqual(sut.calcPossibleArranagements(cr: cr), 10)
    }
    
    
    func testTinyEdgeCase() throws {
        let testdata = "#.#?. 1,1"
        let cr = ConditionRecord(input: testdata)
        try XCTAssertEqual(sut.calcPossibleArranagements(cr: cr), 1)
    }
    
    func testTinyCase2() throws {
        let testdata = "#.??#?.??## 1,3,4"
        let cr = ConditionRecord(input: testdata)
        try XCTAssertEqual(sut.calcPossibleArranagements(cr: cr), 2)
    }
    
    func testBlowUp() throws {
        let testdata = "???.????????#? 1,1,1,3"
        let cr = ConditionRecord(input: testdata)
        try XCTAssertEqual(sut.calcPossibleArranagements(cr: cr), 64) //86 is from my own testing
    }
    
    
    //MARK: - big units
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 21)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 0)
    }
}
