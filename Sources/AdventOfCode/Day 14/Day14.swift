struct Day14: Solution {
    static let day = 14
    
    var boulderMap : TwoDMap
    
    init(input: String) {
        var map : [[Character]] = []
        for l in input.split(separator: "\n").enumerated() {
            map.append(Array(l.element))
        }
        boulderMap = TwoDMap(map: map)
        print("Boulder map loaded. Rows=\(boulderMap.rows) Columns=\(boulderMap.columns)")

    }
    
    func tiltBoulders(fieldmap: inout TwoDMap, direction: Direction) {
        //Approach: Loop through map from top, find each boulder, see how far it can roll (looking up element by element in it's path), move it.
        switch direction {
        case .Up:
            //Roll up
            for r in 0..<fieldmap.rows {
                for c in 0..<fieldmap.columns {
                    let val = fieldmap.value(Position(r, c))
                    if val == "O" {
                        //search along the path the boulder could roll
                        for d in stride(from: r-1, through: 0, by: -1){
                            let dpos = Position(d,c)
                            if fieldmap.value(dpos) == "." {
                                //we can roll the boulder
                                let sourcepos = Position(d+1,c)
                                fieldmap.setvalue(pos: sourcepos, val: ".")
                                fieldmap.setvalue(pos: dpos, val: "O")
                            } else {
                                //we can't roll the boulder, so stop moving this boulder
                                break
                            }
                        }
                    }
                }
            }
        case .Down:
            //Roll down
            for r in stride(from: fieldmap.rows-1, through: 0, by: -1) {
                for c in 0..<fieldmap.columns {
                    let val = fieldmap.value(Position(r, c))
                    if val == "O" {
                        //search along the path the boulder could roll
                        for d in stride(from: r+1, through: fieldmap.rows - 1, by: 1){
                            let dpos = Position(d,c)
                            if fieldmap.value(dpos) == "." {
                                //we can roll the boulder
                                let sourcepos = Position(d-1,c)
                                fieldmap.setvalue(pos: sourcepos, val: ".")
                                fieldmap.setvalue(pos: dpos, val: "O")
                            } else {
                                //we can't roll the boulder, so stop moving this boulder
                                break
                            }
                        }
                    }
                }
            }
        case .Left:
            //Roll left
            for c in 0..<fieldmap.columns {
                for r in 0..<fieldmap.rows {
                    let val = fieldmap.value(Position(r, c))
                    if val == "O" {
                        //search along the path the boulder could roll
                        for d in stride(from: c-1, through: 0, by: -1){
                            let dpos = Position(r,d)
                            if fieldmap.value(dpos) == "." {
                                //we can roll the boulder
                                let sourcepos = Position(r,d+1)
                                fieldmap.setvalue(pos: sourcepos, val: ".")
                                fieldmap.setvalue(pos: dpos, val: "O")
                            } else {
                                //we can't roll the boulder, so stop moving this boulder
                                break
                            }
                        }
                    }
                }
            }
        case .Right:
            //Roll right
            for c in stride(from: fieldmap.columns-1, through: 0, by: -1){
                for r in 0..<fieldmap.rows {
                    let val = fieldmap.value(Position(r, c))
                    if val == "O" {
                        //search along the path the boulder could roll
                        for d in stride(from: c+1, through: fieldmap.columns-1, by: 1){
                            let dpos = Position(r,d)
                            if fieldmap.value(dpos) == "." {
                                //we can roll the boulder
                                let sourcepos = Position(r,d-1)
                                fieldmap.setvalue(pos: sourcepos, val: ".")
                                fieldmap.setvalue(pos: dpos, val: "O")
                            } else {
                                //we can't roll the boulder, so stop moving this boulder
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    func cycleBoulder(fieldmap: inout TwoDMap) {
        //north, then west, then south, then east
        //UP, then LEFT, then DOWN, then RIGHT
        for d : Direction in [.Up, .Left, .Down, .Right] {
            //print("Tilting \(d)")
            tiltBoulders(fieldmap: &fieldmap, direction: d)
            //print("\(fieldmap)")
        }
    }
    
    func totalLoadOnNorthBeam(input: TwoDMap) -> Int {
        var runningTotal = 0
        var loadFactor = input.rows
        for r in 0..<input.rows {
            let rowLoad = input.map[r].filter({$0=="O"}).count
            runningTotal += (rowLoad * loadFactor)
            loadFactor += -1
        }
        return runningTotal
    }
    
    
    func calculatePartOne() -> Int {
        //Roll the boulders north
        //I suspect part 2 is going to involve rolling boulders in a different direction
        //But let's hold off that for a moment
        var p1map = boulderMap
        tiltBoulders(fieldmap: &p1map, direction: .Up)

        return totalLoadOnNorthBeam(input: p1map)
    }
    
    func calculatePartTwo() -> Int {
        ///Run 1000000000 cycles?
        ///My guess is we'll hit a repeating stable pattern fairly soon, so need to detect that
        ///
        ///Approach:
        ///Generalise part 1 to rotate in any direction
        ///Find a way of hashing the whole map
        ///
        var p2map = boulderMap
        var cycleHash : [Int] = []
        cycleHash.append(p2map.hashValue)
        var skipped = false
        var i = 1
        while i <= 1000000000 {
            cycleBoulder(fieldmap: &p2map)
            //detect cyclic nature of problem
            if !skipped {
                if let seenbefore = cycleHash.firstIndex(of: p2map.hashValue) {
                    let cycleLenth = i - seenbefore
                    print("Cycle detected: \(seenbefore) -> \(i) with cycle length \(cycleLenth)")
                    //skip forward
                    let remainder = 1000000000 - i
                    let cycleToSkip = remainder / cycleLenth
                    i += (cycleLenth * cycleToSkip) //looks weird dividing then muiltiplying, but it rounds to whole cycles
                    print("Skipping to \(i)")
                    skipped = true
                    //6999999940 <-- we've skipped too far
                    //1000000000
                }
            }
            
            cycleHash.append(p2map.hashValue)
            i += 1
        }
        
        
        return totalLoadOnNorthBeam(input: p2map)
    }
}
