//
//  File.swift
//  
//
//  Created by Hempsall, Peter on 12/12/2023.
//

import Foundation

//Remember: ROW, COLUMN addressing
enum Direction : CaseIterable {
    case Up
    case Down
    case Left
    case Right
    
    var value : (Int, Int) {
        switch self {
        case .Up:
            return (-1, 0)
        case .Down:
            return (1, 0)
        case .Left:
            return (0, -1)
        case .Right:
            return (0, 1)
        }
    }
}


struct Position : Equatable, Hashable {

    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
}




struct TwoDMap : CustomStringConvertible, Hashable {
    var description: String {
        var output = ""
        map.forEach { e in
            output.append("\(String(e))\n")
        }
        return output
    }
    
    var map : [[Character]]
    
    init(map: [[Character]]) {
        self.map = map
    }
    
    func value(_ pos:Position)->Character {
        return map[pos.x][pos.y]
    }
    
    mutating func setvalue(pos: Position, val: Character) {
        map[pos.x][pos.y] = val
    }
    
    var rows : Int {
        return map.count
    }
    
    var columns : Int {
        return map[0].count
    }
    
}
