import XCTest
@testable import AdventOfCode

protocol SolutionTest {
    associatedtype SUT: Solution
}

extension SolutionTest {
    var sut: SUT {
        get throws {
            try SUT(input: getTestData())
        }
    }
//    var sut2: SUT {
//        get throws {
//            try SUT(input: getTestDataP2())
//        }
//    }
    
    func getTestData(filename: String? = nil) throws -> String {
        let input = try XCTUnwrap(Bundle.module
            .url(forResource: filename ?? "Day\(SUT.day)", withExtension: "input"))
        return try String(contentsOf: input)
    }
  
///did't get this working becuase resource not in the bundle... would need to modify Package.swift... looks like a lot of faff, can just put test data in string literal
//    func getTestDataP2(filename: String? = nil) throws -> String {
//        var url = "Day\(SUT.day)p2"
//        let input = try XCTUnwrap(Bundle.module
//            .url(forResource: filename ?? "Day\(SUT.day)p2", withExtension: "input"))
//        return try String(contentsOf: input)
//    }
}
