struct Day9: Solution {
    static let day = 9
    let histories : [History]
    
    
    init(input: String) {
        var tmpHist : [History] = []
        input.enumerateLines { line, stop in
            var hist = History(line)
            tmpHist.append(hist)
        }
        self.histories = tmpHist
        //print(self.histories)
    }
    
    func calculatePartOne() -> Int {
        //print("Calculating differentials")
        //print(self.histories)
        
        //Analyze your OASIS report and extrapolate the next value for each history. What is the sum of these extrapolated values?
        var wip = 0
        for h in self.histories {
            wip += h.prediction
        }
        
        return wip
    }
    
    func calculatePartTwo() -> Int {
        var wip = 0
        for h in self.histories {
            print("History: \(h)")
            print("Extrapolate: \(h.extrapolateBackwards)\n\n")
            
            wip += h.extrapolateBackwards
        }
        
        return wip
    }
}

struct History : CustomStringConvertible {
    var d : [[Int]] = []
    
    var description: String {
        var output = ""
        d.forEach { e in
            output.append("\(e)\n")
        }
        return output
    }
    
    
    
    init(_ input: String) {
        self.d.append(input.split(separator: " ").map({Int($0)!}))
        self.calcDifferentials()
    }
    
    mutating func calcDifferentials(){
        var i = 0
        while self.d[i].filter({$0 != 0}).count > 0 {
            //keep looping until we've got all zero differentials
            self.d.append(self.d[i].adjacentPairs().map({ $0.1 - $0.0 }))
            i += 1
        }
    }
    
    var prediction : Int {
        //Need to work backwards through the arrays of differentials
        //add together last element of all ds
        var wip = 0
        for i in self.d {
            wip += i.last!
        }
        return wip
    }
    
    var extrapolateBackwards : Int {
        //feels like this should be as easy.. but inverting nature of maths gets quite hard
        var wip = 0
        var odd = true
        for i in self.d {
            if odd {
                wip += i.first!
                odd = false
            } else {
                wip -= i.first!
                odd = true
            }
            
        }
        return wip
    }
}
