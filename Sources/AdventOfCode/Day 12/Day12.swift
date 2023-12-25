

struct ConditionRecord : CustomStringConvertible {
    let springConditions : [Character] //Possible values: ?.#
    let groupSizes : [Int]
    let lastKnownSpringIndex : Int
    //Partial solving
    let partialSolution : [Character]
    let remainingGroups : [Int]
    
    init(springConditions: [Character], groupSizes: [Int]) {
        self.springConditions = springConditions
        //calc last spring index
        if let lastspring = springConditions.lastIndex(of: "#") {
            lastKnownSpringIndex = Int(lastspring)
        } else {
            lastKnownSpringIndex = 0
        }
        
        self.groupSizes = groupSizes
        self.remainingGroups = groupSizes
        self.partialSolution = []
    }
    
    init(input: String) {
        let chunks = input.split(separator: " ")
        self.init(springConditions: Array(chunks[0]), groupSizes: chunks[1].split(separator: ",").map({Int($0)!}))
    }
    
    init(cr: ConditionRecord, partialSolution: [Character], remainingGroups: [Int]){
        self.springConditions = cr.springConditions
        self.groupSizes = cr.groupSizes
        self.lastKnownSpringIndex = cr.lastKnownSpringIndex
        self.remainingGroups = remainingGroups
        self.partialSolution = partialSolution
    }
    
    var recordLength : Int {
        return springConditions.count
    }
    
    var totalSprings : Int {
        return groupSizes.sum()
    }
    
    var validSolution : Bool {
        //work out if solution is valid based on spring condition report
        //Should work on partial... so only look at those elements
        for i in 0..<partialSolution.count {
            if springConditions[i] == partialSolution[i] || springConditions[i] == "?" {
                //this is fine
            } else {
                return false
            }
        }
        //PROBLEMO... doesn't work on full solution, where last # is after our last partial #
        //Can check if we're shorter than last # but have already placed all springs?
        let placedSprings = partialSolution.filter({$0=="#"}).count
        if placedSprings == totalSprings {
            let lastSpring = Int(partialSolution.lastIndex(of: "#")!)
            if lastSpring < self.lastKnownSpringIndex {
                return false
            }
            
        }
        
        
        return true
    }
    
    var sufficientSpace : Bool {
        //is there sufficient space in this partial solution for the remaining groups
        let spaceNeeded = remainingGroups.sum()
        + (partialSolution.last == "#" && remainingGroups.count > 0 ? 1 : 0)
        + (remainingGroups.count > 1 ? remainingGroups.count - 1 : 0)
        
        let spaceAvailable = recordLength - partialSolution.count
        
        return spaceNeeded <= spaceAvailable
    }
    
    var description: String {
        return "\(String(self.springConditions)) [\(self.recordLength)] |> \(String(self.partialSolution)) [\(self.partialSolution.count)]"
    }
    
}

struct Day12: Solution {
    static let day = 12
    let conditionReport : [ConditionRecord]
    
    
    init(input: String) {
        var tmpReport : [ConditionRecord] = []
        input.enumerateLines { line, stop in
            //Example: ???.### 1,1,3
            tmpReport.append(ConditionRecord(input: line))
        }
        conditionReport = tmpReport
    }
    
    func calcPossibleArranagements(cr: ConditionRecord)->Int {
        //calculate all possible solutions
        let allPossible = allPossibleArrangements(cr: cr)
        //debug printing
        for c in allPossible {
            print(c)
        }
        return allPossible.count
    }
    
    //Unfiltered - build off the root string
    func allPossibleArrangements(cr: ConditionRecord)->[ConditionRecord] {
        let thisGroupLength = cr.remainingGroups.first
        let remainder = cr.remainingGroups.dropFirst()
        //Work out all the iterations
        //I need to worry about padding
        var partialSolution = cr.partialSolution
        if partialSolution.last == "#" {
            partialSolution.append(".")
        }
        
        if thisGroupLength == nil {
            //this should stop recurrsion
            return [cr]
        } else if partialSolution.count + thisGroupLength! > cr.recordLength {
            //this should stop
            print("Stopping cos it won't fit: \(cr)")
            fatalError("HALT")
        } else {
            var wip : [ConditionRecord] = []
            //Build the array of partially solved condition reports for the first group
            let springElements = [Character](repeating: "#", count: thisGroupLength!)
            let firstPossibleStartIndex = partialSolution.count            
            let lastPossibleStartIndex = cr.recordLength - thisGroupLength! - remainder.sum() - (remainder.count > 1 ? remainder.count - 1 : 0)
            
            
            for i in firstPossibleStartIndex...lastPossibleStartIndex {
                let padding = i - firstPossibleStartIndex
                let paddElements = [Character](repeating: ".", count: padding)
                var newPartial = partialSolution
                newPartial.append(contentsOf: paddElements)
                newPartial.append(contentsOf: springElements)
                let newCr = ConditionRecord(cr: cr, partialSolution: newPartial, remainingGroups: Array(remainder))
                if newCr.validSolution && newCr.sufficientSpace {
                    wip.append(newCr)
                }
            }
            
            
            //Collect all the subparts using recurrsion.
            var output : [ConditionRecord] = []
            for partial in wip {
                output.append(contentsOf: allPossibleArrangements(cr: partial))
            }
            return output
        }
    }
    
    
    
    func calculatePartOne() -> Int {
        ///For each row, count all of the different arrangements of operational and broken springs that meet the given criteria. 
        ///What is the sum of those counts?
        
        let possibleArrangementCounts = self.conditionReport.map({calcPossibleArranagements(cr: $0)})
        print("How many reports processed? \(possibleArrangementCounts.count)")
        let output = possibleArrangementCounts.sum()
        print("Sum them up: \(possibleArrangementCounts.sum())")
        //print(possibleArrangementCounts)
        return output
    }
    
    //8011 is apparently too high... oh dear.
    
    func calculatePartTwo() -> Int {
        0
    }
}
