import Foundation
import Collections
import Algorithms

///Day 8 thoughts
///Need to cycle through stuff.... there is a cycle method in algorithms that looks interesting
///It feels slightly straightfoward... just follow the path, no decision making
///The input looks large... part 2 likely to uncover some performance issues?
///Unclear how can shortcut performance issues... in previous years there's been an obvious way of calculing a cycle length to save multiple traverses... but we don't have to complete a cycle here, so I can't see that possibility
///


struct Day8: Solution {
    static let day = 8
    let instructions : [Character]
    let network : [String:Node]
    
    init(input: String) {
        let chunks = input.split(separator: "\n\n")
        instructions = Array(chunks[0])
        var tmpnetwork : [String:Node] = [:]
        chunks[1].enumerateLines { line, stop in
       //FJT = (XDJ, LQV)
            let key = line.substring(with: 0..<3)
            let left = line.substring(with: 7..<10)
            let right = line.substring(with: 12..<15)
            tmpnetwork[key] = Node(key: key, left: left, right: right)
        }
        self.network = tmpnetwork
        //print("\(network)")
        
    }
    
    func calculatePartOne() -> Int {
        var cycleCount = 0
        var currentNode : Node = network["AAA"]!
        for i in instructions.cycled() {
            print("At node \(currentNode) with instruction \(i)")
            cycleCount += 1
            if i == "L" {
                currentNode = network[currentNode.left]!
            } else {
                currentNode = network[currentNode.right]!
            }
            if currentNode.key == "ZZZ" {
                break
            }
        }
        return cycleCount
    }
    
    func calculatePartTwo() -> Int {
        0
    }
}

struct Node {
    let key : String
    let left : String
    let right : String
    
    init(key: String, left: String, right: String) {
        self.key = key
        self.left = left
        self.right = right
    }
}

//Simple substrings for known simple strings
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
