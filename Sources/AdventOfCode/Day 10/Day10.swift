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
        for r in 0...rows {
            //REVISED: between this cell and the right hand edge of this row
            //Hold up.... potential optimisation... can calculate this row by row, rather than cell by cell.
            var inPath = [false, false]
            var pathCross = [0, 0]
            //assumption that we have an even number of columns, so let's enforce that
            assert(columns%2==0)
            
            for c in 0..<columns/2 {
                let leftpos : Position = Position(r, c)
                let rightpos : Position = Position(r, columns-c-1)
                //We're only looking at path... no any other crap in the map
                //path is an array of Positions.... which isn't now the most helpful.. fixed by changing to struct and set of these
                
                //BUG...fixed working off the path doesn't work... side by side vertical pipes are different to -
                
                //BUG... approach seems fundamentally flawed... a long pipe behaves differently depending on its surrounding, and I can't work out a logical rule.
                // Should have gone for flood fill!
                
                //OR... final hurrah? Trace from both edges and meet in the middle... I think the math might work out???
                
                //Made it work for the simple example... fails for more complex example and puzzle itself.
                
                //OK fixed for test case
                //But 653 is still too high for real problem.
                //Grrr... think I'm going to give up! 
                // 672
                // 645... still not there, so some edge cases, but unsure which direction.
                //Is the S value giving me the issue? If that should be a "|" then maybe?
                //Nah.. it's an L and I'm not doing anything special for an L
               
                //OK.. read some tips... and it seems like need to handle the bends: L7 different to LJ!!!
                //Storing "opener value" will enable doign this logic.
                //Fing U-BENDS!!!!!
                //Shame the test data didn't uncover this.
                
                //Possibly woulnd't need to work from both sides... in fact, shouldn't as will break logic.
                
                
                
                for lr in 0...1 { //crude left / right switcheroo
                    let pos = lr == 0 ? leftpos : rightpos
                    
                    let pipeType = pipemap.value(pos)
                    
                    if path.contains(pos) {
                        if pipeType == "|" {
                            pathCross[lr] += 1
                            if inPath[lr] {
                                //out of sideways pipe into a |
                                pathCross[lr] += 1
                                inPath[lr] = false
                            }
                            
                            //inPath[lr] = false //this has made it higher! 672
                        }else{
                            
                            if inPath[lr] {
                                //we're in a path and still in the path
                                
                            } else {
                                inPath[lr] = true
                            }
                        }
                    } else {
                        if inPath[lr] {
                            //we've exited the path
                            pathCross[lr] += 1
                            inPath[lr] = false
                        }
                    }
                    
                    if pathCross[lr] > 0 && pathCross[lr] % 2 == 1 && !path.contains(pos) {
                            internalPosCount += 1
                            print("Interior found at \(pos)")
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
