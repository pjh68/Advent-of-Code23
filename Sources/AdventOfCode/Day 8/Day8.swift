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
        var stepCount = 0
        var currentNode : Node = network["AAA"]!
        for i in instructions.cycled() {
            //print("At node \(currentNode) with instruction \(i)")
            stepCount += 1
            if i == "L" {
                currentNode = network[currentNode.left]!
            } else {
                currentNode = network[currentNode.right]!
            }
            if currentNode.key == "ZZZ" {
                break
            }
        }
        return stepCount
    }
    
    func calculatePartTwo() -> Int {
        var stepCount = 0
        print("Instruction cycle has \(self.instructions.count) steps")
        var currentNodes : [String] = network.values.filter({$0.ghostAnode}).map({$0.key})
        
        var firstZ : [String: Int] = [:]
        
        print("Start with \(currentNodes.count) ghost A nodes")
        for i in instructions.cycled() {
            stepCount += 1
            if i == "L" {
                currentNodes = currentNodes.map({network[$0]!.left})
            } else {
                currentNodes = currentNodes.map({network[$0]!.right})
            }
            
            //if we've ended on a "??Z" node then remove it from the pool -- INCORRECT
            //This might be where the cyclic complexity comes in?

            //Only stop when everyone is on a Z ghost node
//            if currentNodes.filter({$0.hasSuffix("Z")}).count == currentNodes.count {
//                break
//            }

            //This will take far too long...
            //Alt approach: work out shortest step count for each ghost
            // and maybe when it repeats?
            // Does the intial sequence repeat at all? Assume not
            var ghostZ = currentNodes.filter({$0.hasSuffix("Z")})
            if ghostZ.count > 0 {
                let cycle = stepCount / instructions.count
                let stepsInCycle = stepCount % instructions.count
                
                print("\(cycle) / \(stepsInCycle): \(ghostZ)")
                
                for g in ghostZ {
                    if firstZ[g] == nil{
                        firstZ[g] = stepCount
                    }
                }
                
                
            }
            
            if firstZ.count == currentNodes.count {
                break
            }
            
            //FUCK IT... let's try brute force
//            if ghostZ.count == currentNodes.count {
//                break
//            }
            //Clearly no
            
            //Could just try LCM of the first Z of each... and the cycle length(?)
            //I don't like this, because it makes a bunch of assumptions...liek it's possible... maybe that's a fair assumption.
            
            
            
            
        }
        
        //TODO: Lowest common multiple of first Z
        print("First z: \(firstZ)")
  
        return Array(firstZ.values).lcm()
    }
}

struct Node {
    let key : String
    let left : String
    let right : String
    
    var ghostAnode : Bool {
        return key.last == "A"
    }
    
    var ghostZnode : Bool {
        return key.last == "Z"
    }
    
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


//https://gist.github.com/aniltv06/6f3e9c6208e27a89259919eeb3c3d703
/*
 Returns the Greatest Common Divisor of two numbers.
 */
func gcd(_ x: Int, _ y: Int) -> Int {
    var a = 0
    var b = max(x, y)
    var r = min(x, y)
    
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}

/*
 Returns the least common multiple of two numbers.
 */
func lcm(_ x: Int, _ y: Int) -> Int {
    return x / gcd(x, y) * y
}

extension Array where Element == Int {
    ///Lowest common multiple
    func lcm() -> Int {
        return self.reduce(1) { AdventOfCode.lcm($0, $1) }
    }
}
