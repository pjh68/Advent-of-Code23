struct Day5: Solution {
    static let day = 5
    var a : Almanac
    
    init(input: String) {
        self.a = Almanac(input)
    }
    
    func calculatePartOne() -> Int {
        return a.locations().min()!
    }
    
    func calculatePartTwo() -> Int {
        0
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
    var seeds:[Int] = []
    var maps:[AlmanacSections:Map] = [:]
    
    init(_ input: String){
        var chunk = input.split(separator: "\n\n")
        //chunk[0] is the seeds line
        //chunk[AlamancSection.rawValue] is the corresponding set of maps
        
        //process seeds line
        seeds = chunk[0].split(separator: " ").dropFirst().map({Int($0)!})
        //process other sections
        for mp in AlmanacSections.allCases {
            self.maps[mp] = Map(input: String(chunk[mp.rawValue]))
        }
    }
    
    ///Calculation the locations of the seeds
    func locations() -> [Int] {
        return self.seeds.map { seed in
            //TODO mapping
            var wip = seed
            for mp in AlmanacSections.allCases {
                wip = self.maps[mp]![wip]
            }
            return wip
        }
    }
}




struct Map {
    struct Range {
        var destinationStartIndex:Int, sourceStartIndex:Int, sourceLength:Int
        
        init(destinationStartIndex: Int, sourceStartIndex: Int, sourceLength: Int) {
            self.destinationStartIndex = destinationStartIndex
            self.sourceStartIndex = sourceStartIndex
            self.sourceLength = sourceLength
        }
        
        init(string: String) {
            var parts = string.split(separator: " ")
            self.destinationStartIndex = Int(parts[0])!
            self.sourceStartIndex = Int(parts[1])!
            self.sourceLength = Int(parts[2])!
        }
        
        func inRange(source:Int)->Bool {
            return sourceStartIndex <= source && source < sourceStartIndex + sourceLength
        }
        
        func destination(source:Int)->Int? {
            if self.inRange(source: source) {
                return source - sourceStartIndex + destinationStartIndex
            } else {
                return nil
            }
        }
    }
    
    var ranges: [Range] = []
    
    init() {
        //Don't currently need to do anything special
    }
    
    init(input:String) {
        input.split(separator: "\n").dropFirst().forEach { line in
            self.append(string: String(line))
        }
    }
    
    mutating func append(string: String) {
        self.ranges.append(Range(string: string))
    }
    
    subscript(input:Int) -> Int {
        get {
            for range in ranges {
                if let output = range.destination(source: input) {
                    return output
                }
            }
            return input //Any source numbers that aren't mapped correspond to the same destination number
        }
    }
}

