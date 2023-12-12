typealias Position = (Int, Int)
typealias Line = (Position, Position)

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
        var tmpStart : (Int, Int)?
        var map : [[Character]] = []
        for l in input.split(separator: "\n").enumerated() {
            var la = Array(l.element)
            map.append(la)
            if let c = la.firstIndex(of: "S") {
                tmpStart = (l.offset, c)
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
        var currentPos : [Position] = nextPos(from: start, excluding: (-1,-1)) //using an invalid pos for excluding as easier than making it optional
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
        var currentPos : [Position] = nextPos(from: start, excluding: (-1,-1)) //using an invalid pos for excluding as easier than making it optional
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
                var next = nextPos(from: currentPos[i],excluding: lastPos[i]).first!
                lastPos[i] = currentPos[i]
                currentPos[i] = next
            }
            wipPath[0].append(currentPos[0])
            wipPath[1].append(currentPos[1])
            steps += 1
        }
        
        //assemble path - going to need this for part2
        var path : [Position] = []
        path.append(start)
        path.append(contentsOf: wipPath[0])
        path.append(contentsOf: wipPath[1].reversed().dropFirst())
        path.append(start)
        let pathSegments = path.adjacentPairs()
        print("Path assembled: \(pathSegments)")
        
        //Raytrace
        
        //Bug: corner case... literally! When ray crosses a corner. Could a further away point help?
        //Observations... setting farfaraway to a large number results in no hits at all
        //maybe flood fill would have been a better idea... lost the mojo on this now.
        
        //RETHINK: I don't need to trace to the same point... I can just trace horizontal lines to the edge of the map :facepalm:
        //Can also trace to either side of the map, so can trace to right to keep the iteration simple.
        //Means we don't need to do any maths
        //But do need to track when entering and exiting path... as a continuius run of paths is only crossing it twice.
        ///examples:
        /// X->...F-----7   //X is outside the shape. Enters path, stays in path, exists path
        /// X--> F7 //X is outside the shape
        /// X ->  Not possible to have a single tile wiggle... ubend takes two tiles.
        /// X -> .....|......|......|  //Inside... crosses path 3 times
        /// How to code this logic???
        /// Can strip out "-" with no impact on resutls
        /// Now just need to detect double pipe (e.g. "F7")
        
        
        print("Raytracing internal area")
        var internalPosCount = 0
        let farfaraway = (-100,-100)
        for r in 0...rows {
            for c in 0..<columns {
                let pos : Position = (r, c)
                //check how many pathSegements it intersects
                //discard the path itself
                if !path.contains(where: {$0 == pos}) {
                    print("Raytracing pos: \(pos)")
                    let line = (farfaraway, pos)
                    var intersectCount = 0
                    for seg in pathSegments {
                        //Specific debug check
                        if pos == (6,2)  {
                            print("DEBUG trigger")
                        }
                        
                        if intersects(line: line, segment: seg) {
                            intersectCount += 1
                        }
                    }
                    if intersectCount % 2 == 1 { //odd
                        internalPosCount += 1
                        print("Pos: \(pos) has intersection count of \(intersectCount) so is \(intersectCount % 2 == 1 ? "internal" : "external")")
                    }
                        
                    
                }
            }
        }

        return internalPosCount
    }
    
    func intersects(line: Line, segment: Line)->Bool {
        //Does the line intersect this segment?
        //Vert or horizontal seg?
        if segment.0.0 == segment.1.0 { //matching rows, horizontal segment
            //Are we even in the same columns?
            let segmentMin = min(segment.0.1, segment.1.1) //col
            let segmentMax = max(segment.0.1, segment.1.1) //col
            let lineMax = max(line.0.1, line.1.1) //col
            if lineMax > segmentMin { //weirdly, this is the only check we need to make at this time, assuming line starts off grid at negative number
        
                //get the column values of the line and see if they intersect..
                //Gradient... columns / rows
                let gradient : Double = Double((line.1.0 - line.0.0)) / Double((line.1.1 - line.0.1))
                let r1 = Double(line.0.1) + gradient * Double(segmentMin)
                let r2 = Double(line.0.1) + gradient * Double(segmentMax)
                //detect if these cross the current row
                let r1sign = (r1 - Double(segment.0.0)).sign
                let r2sign = (r2 - Double(segment.0.0)).sign
                if r1sign != r2sign {
                    print("Ray crosses segment: \(segment)")
                }
                return r1sign != r2sign //true if crosses
            } else {
                return false
            }
        } else { //vertical segment
            //TODO: redo the logic above, but flipped 90deg... matching columns, vertical segment
            //Are we even in the same row?
            let segmentMin = min(segment.0.0, segment.1.0) //row
            let segmentMax = max(segment.0.0, segment.1.0) //row
            let lineMax = max(line.0.0, line.1.0) //row
            if lineMax >= segmentMin { //weirdly, this is the only check we need to make at this time, assuming line starts off grid at negative number
        
                //get the column values of the line and see if they intersect..
                //Gradient... rows / columns
                let gradient : Double = Double((line.1.1 - line.0.1)) / Double((line.1.0 - line.0.0))
                let r1 = Double(line.0.0) + gradient * Double(segmentMin)
                let r2 = Double(line.0.0) + gradient * Double(segmentMax)
                //detect if these cross the current row
                let r1sign = (r1 - Double(segment.0.1)).sign
                let r2sign = (r2 - Double(segment.0.1)).sign
                if r1sign != r2sign {
                    print("Ray crosses segment: \(segment)")
                }
                return r1sign != r2sign //true if crosses
            } else {
                return false
            }
        }
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
            let pos = (from.0 + d.value.0, from.1 + d.value.1)
            if inRange(pos) && (pos != excluding) {
                output.append((pos,d))
            }
        }
        return output
    }
    
    func inRange(_ pos:Position)->Bool {
        //is this position within the field of play?
        return pos.0 >= 0 && pos.0 <= rows && pos.1 >= 0 && pos.1 < columns
    }
    
    func nextPos(from:Position, excluding:Position)->[Position] {
        return possibleNextMove(from: from, excluding: excluding).filter({canConnect(fromPipe: pipemap.value(from), direction: $0.direction, toPipe: pipemap.value($0.position))}).map({$0.position})

    }
}

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

struct TwoDMap : CustomStringConvertible {
    var description: String {
        var output = ""
        map.forEach { e in
            output.append("\(e)\n")
        }
        return output
    }
    
    var map : [[Character]]
    
    init(map: [[Character]]) {
        self.map = map
    }
    
    func value(_ pos:Position)->Character {
        return map[pos.0][pos.1]
    }
    
}

//helper to allow comparison of Position tuples
func ==<T: Equatable, U: Equatable>(lhs: (T,U), rhs: (T,U)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}
