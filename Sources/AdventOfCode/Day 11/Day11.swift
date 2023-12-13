///Thoughts on Day 11
///Classic string to 2D array
///Need to find "empty" rows - easy, and column, harder???
///Padding rows... easy. Padding column... only a little bit harder
///Shortest path is just delta rows + delta columns - easy
///Pairs of all galaxies... combinations from algorithms

import Foundation
import Algorithms
import Collections


struct Day11: Solution {
    static let day = 11
    var skymap : TwoDMap
    var rows : Int = 0
    var columns : Int = 0
    
    init(input: String) {
        var map : [[Character]] = []
        for l in input.split(separator: "\n").enumerated() {
            var la = Array(l.element)
            map.append(la)
            //Custom logic...
            
            columns = la.count
            rows = l.offset //bit wasteful
        }
        
        skymap = TwoDMap(map: map)
        print("Skymap loaded. Rows=\(rows) Columns=\(columns)")
    }
    
    func calculatePartOne() -> Int {
        return tuneableExpansion(expansionFactor: 2)
   
        //part 1 first pass, before refactoring to support part 2
//        print("Expanding galaxy")
//        let expandedMap = expandMap(skymap)
//        print(expandedMap)
//        let galaxies = galaxyPositions(map: expandedMap)
//        let galaxyPairs = galaxies.combinations(ofCount: 2)
//        print("\(galaxyPairs.count) galaxy pairs")
//        let sumpath = galaxyPairs.reduce(0, {$0 + manhatanDistance(from: $1[0], to: $1[1])})
//        
//        return sumpath
    }
    //Part One: 9543156
    
    fileprivate func tuneableExpansion(expansionFactor:Int = 1) -> Int {
        //need to extract galaxy positions first, then run expansion routine numerically
        
        var galaxies = galaxyPositions(map: skymap)
        var rexp = expandRows(skymap)
        var cexp = expandCols(skymap)
        
        //move the galaxies about
        for r in 0..<rexp.count {
            for i in 0..<galaxies.count {
                let pos = galaxies[i]
                if pos.x > rexp[r] {
                    galaxies[i] = Position(pos.x + expansionFactor - 1, pos.y)
                }
            }
            //expand out the position of the empty rows
            for rx in r..<rexp.count {
                rexp[rx] = rexp[rx] + expansionFactor - 1
            }
        }
        
        for c in 0..<cexp.count {
            for i in 0..<galaxies.count {
                let pos = galaxies[i]
                if pos.y > cexp[c] {
                    galaxies[i] = Position(pos.x, pos.y + expansionFactor - 1)
                }
            }
            //expand out the position of the empty rows
            for cx in c..<cexp.count {
                cexp[cx] = cexp[cx] + expansionFactor - 1
            }
        }
        
        let galaxyPairs = galaxies.combinations(ofCount: 2)
        print("\(galaxyPairs.count) galaxy pairs")
        let sumpath = galaxyPairs.reduce(0, {$0 + manhatanDistance(from: $1[0], to: $1[1])})
        
        return sumpath
    }
    
    func calculatePartTwo() -> Int {
        return tuneableExpansion(expansionFactor: 1000000)
        
    }
    //Part Two: 625243292686
    
    func testForPartTwo() -> Int {
        //test data has different expansion factor, hence needing this stub to test
        return tuneableExpansion(expansionFactor: 100)
    }
    
    func expandMap(_ input: TwoDMap) -> TwoDMap {
        //TODO: Expand the map
        var output = input
        var rowOffset = 0
        for r in 0..<input.rows {
            if !input.map[r].contains("#") {
                output.map.insert(input.map[r], at: r+rowOffset)
                rowOffset += 1
            }
        }
        
        //Expand out columns without galaxies
        var colOffset = 0
        for c in 0..<input.columns {
            let column = input.map.compactMap({$0[c]})
            if !column.contains("#") {
                //expand
                print("Empty column found at \(c)")
                for r in 0..<output.rows {
                    output.map[r].insert(".", at: c+colOffset)
                }
                colOffset += 1
            }
        }
        
        return output
    }
    
    func expandRows(_ input: TwoDMap) -> [Int] {
        //return the rows that need expanding
        var output : [Int] = []
        for r in 0..<input.rows {
            if !input.map[r].contains("#") {
                output.append(r)
            }
        }
        return output
    }
    
    func expandCols(_ input: TwoDMap) -> [Int] {
        var output : [Int] = []
        for c in 0..<input.columns {
            let column = input.map.compactMap({$0[c]})
            if !column.contains("#") {
                output.append(c)
            }
        }
        return output
    }
    
    
    func galaxyPositions(map: TwoDMap) -> [Position] {
        //TODO: find the positions of all the galaxies
        var output : [Position] = []
        for r in 0..<map.rows {
            for c in 0..<map.columns {
                let pos = Position(r, c)
                if map.value(pos) == "#" {
                    output.append(pos)
                }
            }
        }
        
        return output
    }
    
    func manhatanDistance(from: Position, to: Position) -> Int {
        return (abs(from.x - to.x) + abs(from.y - to.y))
    }
    
    
}
