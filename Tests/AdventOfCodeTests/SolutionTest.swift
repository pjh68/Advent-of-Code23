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
                    
//    func getTestDataP2(filename: String? = nil) throws -> String {
//        var url = "Day\(SUT.day)p2"
//        let input = try XCTUnwrap(Bundle.module
//            .url(forResource: filename ?? "Day\(SUT.day)p2", withExtension: "input"))
//        return try String(contentsOf: input)
//    }
}
