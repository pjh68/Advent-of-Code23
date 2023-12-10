typealias Position = (Int, Int)

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
    
    var pipemap : PipeMap
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
        pipemap = PipeMap(map: map)
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
        0
    }
    
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
            var pos = (from.0 + d.value.0, from.1 + d.value.1)
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

struct PipeMap : CustomStringConvertible {
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
