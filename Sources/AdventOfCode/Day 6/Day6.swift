import Foundation

struct Day6: Solution {
    static let day = 6
    let raceTimes:[Int]
    let distanceRecords:[Int]
    
    init(input: String) {
        let rows = input.split(separator: "\n")
        raceTimes = rows[0].split(separator: " ").dropFirst().map({Int($0)!})
        distanceRecords = rows[1].split(separator: " ").dropFirst().map({Int($0)!})
    }

    func calculatePartOne() -> Int {
        print("Processing \(raceTimes.count) races")
        var product:Double = 1
        for i in 0..<raceTimes.count {
            print("Race time \(raceTimes[i]) has record \(distanceRecords[i])")
            let a = -1, b = raceTimes[i], c = -1*distanceRecords[i]
            let (r1, r2) = quadraticRoots(a: Double(a), b: Double(b), c: Double(c))
            let winningMoves = ceil(r1) - floor(r2) - 1 //note: using floor for both works unless roots are whole numbers, where it becomes out by one.
            print("Roots: \(r1), \(r2) -> winning moves: \(winningMoves)")
            product = product * winningMoves
        }
        return Int(product)
    }
    
    func calculatePartTwo() -> Int {
        //just one long race
        //I haven't work out how this will go wrong yet... hopefully i've already got the right approach.
        let racetime = Int(raceTimes.map({String($0)}).joined())!
        let distance = Int(distanceRecords.map({String($0)}).joined())!
        
        print("Race time \(racetime) has record \(distance)")
        let a = -1, b = racetime, c = -1*distance
        let (r1, r2) = quadraticRoots(a: Double(a), b: Double(b), c: Double(c))
        let winningMoves = ceil(r1) - floor(r2) - 1 //note: using floor for both works unless roots are whole numbers, where it becomes out by one.
        print("Roots: \(r1), \(r2) -> winning moves: \(winningMoves)")
        return Int(winningMoves)
    }
    
    //roll my own quadratic solver
    func quadraticRoots(a: Double, b: Double, c: Double) -> (Double,Double) {
        let r1 = (-b - sqrt(pow(b,2) - 4*a*c))/(2*a)
        let r2 = (-b + sqrt(pow(b,2) - 4*a*c))/(2*a)
        return (r1,r2)
        
    }
    
}
