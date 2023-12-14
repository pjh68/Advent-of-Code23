struct Day10: Solution {
    

///Approach
    /// S marks the start. there are 4 differrent ways the loop could extend from this start point
    /// There isn't any branching. Will either loop or reach a dead-end
    ///  Need to work out if a tile can connect to another tile - this will depend on direction
    /// Q: Do I want to take upfront hit on process the string into pipe objects?
    /// // Advantage: makes everything else eaiser.. especially as swift string's are annoying to work with
    /// // Dissadvantages: overhead.
    /// Let's try it without first... and can add later if needed

    ///Eye-balling the examples and input file shows the S value only ever has two valid connections from it... so don't actually need to do the multiple path tests (but should asset this is true)
    ///But if trace around both directions, we'll get further away when both branches end up at the same place!
    
    
    static let day = 10
    
    var pipemap : TwoDMap
    var start : Position
    var rows : Int = 0
    var columns : Int = 0
    
    init(input: String) {
        var tmpStart : Position?
        var map : [[Character]] = []
        for l in input.split(separator: "\n").enumerated() {
            var la = Array(l.element)
            map.append(la)
            if let c = la.firstIndex(of: "S") {
                tmpStart = Position(l.offset, Int(c))
                //only want to do this operation once, so sticking it in here
                columns = la.count
            }
            rows = l.offset //bit wasteful
        }
        if let ts = tmpStart {
            self.start = ts
        } else {
            fatalError("Couldn't find start")
        }
        pipemap = TwoDMap(map: map)
        print("Pipe map loaded. Rows=\(rows) Columns=\(columns)")
    }
    
    func calculatePartOne() -> Int {
        //From the S, find the two valid paths
        
        //print("\(pipemap)")
        
        
        var steps = 1
        var currentPos : [Position] = nextPos(from: start, excluding: Position(-1,-1)) //using an invalid pos for excluding as easier than making it optional
        assert(currentPos.count == 2) //sensible check on assumption
        var lastPos : [Position] = [start, start]
        
        while currentPos[0] != currentPos[1] {
            for i in 0...1 { //iterate over both paths
                //print("Path \(i) is at \(currentPos[i])")
                var next = nextPos(from: currentPos[i],excluding: lastPos[i]).first!
                lastPos[i] = currentPos[i]
                currentPos[i] = next
            }
            steps += 1
        }
      
        return steps
    }
    
    func calculatePartTwo() -> Int {
        ///Interior fill of path
        ///Two options: 1) raytrace and count boundary crosses; 2) flood fill
        ///Both feel somewhat cumbersome and awful... so pick which feels less awful / easier to debug / less likely to blow up
        ///Let's try raytracing first:
        /// - iterate over every point in the map
        /// - ignore it if it's the path
        /// - trace a ray from that point to infinity (we'll use (-1,-1) for convience), count the number of times it crosses the path: odd = inside
        /// - interaction of path: we need to test with each section... and given 2D nature, maths is different if it's vertical or horizontal line
        
        //Calculate path - reuse of Part 1 (but copied here because mutating functions are breaking this solution)
        var steps = 1
        var currentPos : [Position] = nextPos(from: start, excluding: Position(-1,-1)) //using an invalid pos for excluding as easier than making it optional
        //TODO: At this stage we should be able to determine what type of pipe S is
        let sPipeType = calcSPipeType(directions: currentPos.map({calcDirection(from: start, to: $0)}))
        
        
        assert(currentPos.count == 2) //sensible check on assumption
        var lastPos : [Position] = [start, start]
        var wipPath : [[Position]] = []
        wipPath.append([])
        wipPath.append([])
        wipPath[0].append(currentPos[0])
        wipPath[1].append(currentPos[1])
        
        while currentPos[0] != currentPos[1] {
            for i in 0...1 { //iterate over both paths
                //print("Path \(i) is at \(currentPos[i])")
                let next = nextPos(from: currentPos[i],excluding: lastPos[i]).first!
                lastPos[i] = currentPos[i]
                currentPos[i] = next
            }
            wipPath[0].append(currentPos[0])
            wipPath[1].append(currentPos[1])
            steps += 1
        }
        
        //assemble path - going to need this IF WE DID FLOOD FILL
//        var path : [Position] = []
//        path.append(start)
//        path.append(contentsOf: wipPath[0])
//        path.append(contentsOf: wipPath[1].reversed().dropFirst())
        //path.append(start)
        
        var path : Set = [start]
        path.formUnion(wipPath[0])
        path.formUnion(wipPath[1])
        
        //Raytrace / scanlines approach

        //But 653 is still too high for real problem.
        //Grrr... think I'm going to give up!
        // 672
        // 645... still not there, so some edge cases, but unsure which direction.

        //OK.. read some tips... and it seems like need to handle the bends: L7 different to LJ!!!
        //Storing "opener value" will enable doign this logic.
        //Fing U-BENDS!!!!!
        //Shame the test data didn't uncover this.
        
        //Possibly woulnd't need to work from both sides... in fact, shouldn't as will break logic.
        
        
        
        print("Scan lining internal area")
        var internalPosCount = 0
        for r in 0...rows {
            var inPath = false
            var pathCross = 0
            var inside = false
            var pathStartChar : Character?
            
            for c in 0..<columns {
                let pos = Position(r, c)
                var pipeType = pipemap.value(pos)
                
                if pipeType == "S" {
                    //Need to work out what type of pipe S really is
                    pipeType = sPipeType
                }
            
                if path.contains(pos) {
                    if pipeType != "-" {
                        if pipeType == "|" {
                            inside = !inside //flip inside indicator
                        } else if inPath {
                            //detect end of pipe, and inside/outside logic
                            let bendType = "\(pathStartChar!)\(pipeType)"
                            if bendType == "LJ" || bendType == "F7" {
                                //UBend!
                                //do nothing
                            } else if bendType == "L7" || bendType == "FJ" {
                                //Wiggle!
                                inside = !inside
                                
                            } else {
                                fatalError("Unexpected branch")
                            }
                            inPath = false
                            pathStartChar = nil
                            
                        } else {
                            //entering the path
                            pathStartChar = pipeType
                            inPath = true
                        }
                    }
                } else {
                    // not in path... so count if we're inside
                    if inside && c != columns - 1 {
                        internalPosCount += 1
                    }
                }
            }
        }
                    

        return internalPosCount
    }
    

    //Part 2 attempt1... 8509 = too high!
    
    
    func canConnect(fromPipe: Character, direction:Direction, toPipe: Character)->Bool {
        //Note: Not return true for connecting to S... want to detect this seperately!
        let connectDown : [Character] = ["|","7","F","S"]
        let connectUp : [Character] = ["|","J","L","S"]
        let connectRight : [Character] = ["-","F","L","S"]
        let connectLeft : [Character] = ["-","7","J","S"]
        
        return (direction == .Up && connectUp.contains(fromPipe) && connectDown.contains(toPipe))
            || (direction == .Down && connectDown.contains(fromPipe) && connectUp.contains(toPipe))
            || (direction == .Left && connectLeft.contains(fromPipe) && connectRight.contains(toPipe))
            || (direction == .Right && connectRight.contains(fromPipe) && connectLeft.contains(toPipe))
    }
    
    func possibleNextMove(from:Position, excluding:Position)->[(position: Position, direction: Direction)] {
        var output : [(Position,Direction)] = []
        for d in Direction.allCases {
            let pos = Position(from.x + d.value.0, from.y + d.value.1)
            if inRange(pos) && (pos != excluding) {
                output.append((pos,d))
            }
        }
        return output
    }
    
    func calcDirection(from:Position, to:Position) -> Direction {
        let directionVector = (to.x - from.x, to.y - from.y)
        for d in Direction.allCases {
            if d.value.0 == directionVector.0 && d.value.1 == directionVector.1 {
                return d
            }
        }
        fatalError("Couldn't find direction")
    }
    
    func calcSPipeType(directions:[Direction]) -> Character {
        let setd = Set(directions)
        if setd.contains(.Up) && setd.contains(.Down) {
            return "|"
        } else if setd.contains(.Up) && setd.contains(.Left) {
            return "J"
        } else if setd.contains(.Up) && setd.contains(.Right) {
            return "L"
        } else if setd.contains(.Down) && setd.contains(.Left) {
            return "7"
        } else if setd.contains(.Down) && setd.contains(.Right) {
            return "F"
        } else if setd.contains(.Left) && setd.contains(.Right) {
            return "-"
        }
        fatalError("failed to find s pipetype")
    }
    
    func inRange(_ pos:Position)->Bool {
        //is this position within the field of play?
        return pos.x >= 0 && pos.x <= rows && pos.y >= 0 && pos.y < columns
    }
    
    func nextPos(from:Position, excluding:Position)->[Position] {
        return possibleNextMove(from: from, excluding: excluding).filter({canConnect(fromPipe: pipemap.value(from), direction: $0.direction, toPipe: pipemap.value($0.position))}).map({$0.position})

    }
}



//helper to allow comparison of Position tuples
//func ==<T: Equatable, U: Equatable>(lhs: (T,U), rhs: (T,U)) -> Bool {
//    return lhs.0 == rhs.0 && lhs.1 == rhs.1
//}
