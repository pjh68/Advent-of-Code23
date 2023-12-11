import XCTest
@testable import AdventOfCode

final class Day10Tests: XCTestCase, SolutionTest {
    typealias SUT = Day10
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 8)
    }
    
    func testPartTwo1() throws {
        var input = """
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
"""
        let sut2 = SUT(input: input)
        
        try XCTAssertEqual(sut2.calculatePartTwo(), 4)
    }
    
       
    
    
    
    func testPartTwo2() throws {
        var input = """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"""
        let sut2 = SUT(input: input)
        
        try XCTAssertEqual(sut2.calculatePartTwo(), 10)
    }
    
    
}
