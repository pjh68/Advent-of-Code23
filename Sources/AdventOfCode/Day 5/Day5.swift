import Collections

struct Day5: Solution {
    static let day = 5
    let input:String
    init(input: String) {
        self.input=input
    }
    
    func calculatePartOne() -> Int {
        var a = Almanac(input)
        return a.locations().min()!
    }
    
    func calculatePartTwo() -> Int {
        var a = Almanac(input, part2: true)
        var dest = a.location2()
        var answer = dest.min { l, r in
            l.startIndex < r.startIndex }
        return answer!.startIndex
    }
}

enum AlmanacSections: Int, CaseIterable {
    case seedToSoil = 1
    case soilToFertilizer
    case fertilizerToWater
    case waterToLight
    case lightToTemperature
    case temperatureToHumidity
    case humidityToLocation
}

struct Almanac {
    var seeds:[SeedRange] = []
    var maps:[AlmanacSections:Map] = [:]
    
    init(_ input: String, part2: Bool = false){
        let chunk = input.split(separator: "\n\n")
        //chunk[0] is the seeds line
        //chunk[AlamancSection.rawValue] is the corresponding set of maps
        
        //process seeds line
        if !part2 {
            seeds = chunk[0].split(separator: " ").dropFirst().map({SeedRange(startIndex: Int($0)!, length: 1)})
        } else {
            //Part 2 processing
            let seedChunks = chunk[0].split(separator: " ").dropFirst().map({Int($0)!})
            stride(from: 0, to: seedChunks.count, by: 2).forEach { i in
                seeds.append(SeedRange(startIndex: seedChunks[i], length: seedChunks[i+1]))
            }
        }
        //process other sections
        for mp in AlmanacSections.allCases {
            self.maps[mp] = Map(input: String(chunk[mp.rawValue]))
        }
    }
    
    ///Calculation the locations of the seeds: PART 1
    func locations() -> [Int] {
        return self.seeds.map { seed in
            var wip = seed.startIndex
            for mp in AlmanacSections.allCases {
                wip = self.maps[mp]![wip]
            }
            return wip
        }
    }
    
    mutating func location2() -> [SeedRange] {
        var wip = self.seeds
        for mp in AlmanacSections.allCases {
            //TODO add a load of logging to work out why this doesn't work.
            print("Processing \(wip.count) ranges through \(mp)")
            wip = self.maps[mp]!.destinationRanges(input: wip)
        }
        return wip
    }
    
}

///Writing my own range struct rather than battling with the Swift built in type system
struct SeedRange {
    var startIndex:Int, length:Int
    
    var endIndex:Int {
        get {
            return startIndex + length - 1
        }
    }
    
    init(startIndex: Int, length: Int) {
        self.startIndex = startIndex
        self.length = length
    }
    
    func inRange(source:Int)->Bool {
        return startIndex <= source && source <= endIndex
    }
    
    func inRange(source:SeedRange)->Bool {
        return startIndex <= source.startIndex && source.endIndex <= endIndex
    }
    
    //split this range into the parts that are within a range and the parts before or after a range
    func split(by:SeedRange) -> (prev:SeedRange?, within:SeedRange?, after:SeedRange?) {
        var prev:SeedRange?, within:SeedRange?, after:SeedRange?
        if startIndex < by.startIndex {
            //build the previous range
            var start = self.startIndex
            var end = min(self.endIndex, by.startIndex - 1)
            var length = end - start + 1
            prev = SeedRange(startIndex: start, length: length)
        }
        if endIndex >= by.startIndex && startIndex <= by.endIndex {
            //build the within range
            var start = max(by.startIndex, self.startIndex)
            var end = min(by.endIndex, self.endIndex)
            var length = end - start + 1
            within = SeedRange(startIndex: start, length: length)
        }
        if endIndex > by.endIndex {
            //build the after range
            var start = max(by.endIndex+1, self.startIndex)
            after = SeedRange(startIndex: start, length: (self.endIndex - start + 1))
        }
        return (prev, within, after)
    }
}



struct Map {
    struct RangeMapper {
        var destinationStartIndex:Int, sourceRange:SeedRange
        
        var offset : Int {
            get {
                return destinationStartIndex - sourceRange.startIndex
            }
        }
        
        init(destinationStartIndex: Int, sourceStartIndex: Int, sourceLength: Int) {
            self.destinationStartIndex = destinationStartIndex
            self.sourceRange = SeedRange(startIndex: sourceStartIndex, length: sourceLength)
        }
        
        init(string: String) {
            let parts = string.split(separator: " ")
            self.init(destinationStartIndex: Int(parts[0])!, sourceStartIndex: Int(parts[1])!, sourceLength: Int(parts[2])!)
        }
        
        func destination(source:Int)->Int? {
            if self.sourceRange.inRange(source: source) {
                return source - sourceRange.startIndex + destinationStartIndex
            } else {
                return nil
            }
        }
        
        func destinations(source:SeedRange)->SeedRange{
            assert(self.sourceRange.inRange(source: source), "Fatal error")
            return SeedRange(startIndex: source.startIndex + offset, length: source.length)
            
        }
    }
    
    //Start of Map proper
    var rangeMaps: [RangeMapper] = []
        
        init() {
            //Don't currently need to do anything special
        }
        
        init(input:String) {
            input.split(separator: "\n").dropFirst().forEach { line in
                self.rangeMaps.append(RangeMapper(string: String(line)))
            }
        }
        
        ///This seemed cute for part 1...
        subscript(input:Int) -> Int {
            get {
                for map in rangeMaps {
                    if let output = map.destination(source: input) {
                        return output
                    }
                }
                return input //Any source numbers that aren't mapped correspond to the same destination number
            }
        }
        
        ///But now let's do something that works with ranges
        mutating func destinationRanges(input:[SeedRange])->[SeedRange] {
            //First, let's sort out map ranges by startIndex.. this should make it all a bit more efficient and save multiple passes
            self.rangeMaps.sort { $0.sourceRange.startIndex < $1.sourceRange.startIndex}
            var sources = Deque(input) //let's start with this one
            var destinations : [SeedRange] = []
            while let nextSource = sources.popFirst() {
                var tmp : SeedRange? = nextSource
                for map in rangeMaps {
                    if let splits = tmp?.split(by: map.sourceRange){
                        if let prev = splits.prev {
                            //print("Prev split found")
                            destinations.append(prev) //because our ranges are in order, if there is anything is this range then it will map to the same numbers, as per the rules
                        }
                        if let within = splits.within {
                            //print("Splits found within range")
                            destinations.append(map.destinations(source: within))
                        } else {
                            //print("NO SPLITS found within range")
                        }
                        if let after = splits.after {
                            //print("After split found")
                            tmp = after
                        } else {
                            tmp = nil
                        }
                    }
                }
                if let tmp {
                    destinations.append(tmp)
                }
            }
            return destinations
        }

    
    
}

