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
        let expandedMap = expandMap(skymap)
        let galaxies = galaxyPositions(in: expandedMap)
        let galaxyPairs = galaxies.combinations(ofCount: 2)
        let sumpath = galaxyPairs.reduce(0, {$0 + manhatanDistance(from: $1[0], to: $1[1])})
        
        return sumpath
    }
    
    func calculatePartTwo() -> Int {
        0
    }
    
    func expandMap(_ input: TwoDMap) -> TwoDMap {
        //TODO: Expand the map
        //Expand out rows without galaxies
        //Expand out columns without galaxies
        return input
    }
    
    func galaxyPositions(in: TwoDMap) -> [Position] {
        //TODO: find the positions of all the galaxies
        return []
    }
    
    func manhatanDistance(from: Position, to: Position) -> Int {
        return (abs(from.0 - to.0) + abs(from.1 - to.1))
    }
    
    
}
