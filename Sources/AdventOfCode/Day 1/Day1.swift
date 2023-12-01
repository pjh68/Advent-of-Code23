import Foundation
struct Day1: Solution {
    static let day = 1
    var lines : [String]
    /// Initialise your solution
    ///
    /// - parameters:
    ///   - input: Contents of the `Day1.input` file within the same folder as this source file
    init(input: String) {
        self.lines = input.components(separatedBy: "\n")
    }

    /// Return your answer to the main activity of the advent calendar
    ///
    /// If you need to, you can change the return type of this method to any type that conforms to `CustomStringConvertible`, i.e. `String`, `Float`, etc.
    func calculatePartOne() -> Int {
        var sum = 0
        self.lines.forEach { line in
            if line != "" {
                //Strip out non numerals
                let filteredChars = String(line.unicodeScalars.filter { CharacterSet.decimalDigits.contains($0)})
                let digits = "\(filteredChars.first!)\(filteredChars.last!)"
                sum += Int(digits)!
            }
        }
        
        return sum
    }

    /// Return your solution to the extension activity
    /// _ N.B. This is only unlocked when you have completed part one! _
    func calculatePartTwo() -> Int {
        //Your calculation isn't quite right. It looks like some of the digits are actually spelled out with letters: one, two, three, four, five, six, seven, eight, and nine also count as valid "digits".
        
        //Idea : use built in find function to find start position of first instance for each word and digit... prob too complex
        //(could stick digits in array of words too)
        //probably want a dictionary of string->Int.
        
        //Issue 1... it's not working.
        //Hypothesis... range() is giving me the range of the first instance. For the last digit I need the last instance.
        //Issue 2... still not working.. eye balling results... we're getting some unexpected zeros (better error handling in future?)
        //cause: if there is only one digit in the string, it should be first and last... quick fix: change inequiality to >= and <=
        
        
        
        var sum = 0
        let digits = ["0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"zero":0,"one":1,"two":2,"three":3,"four":4,"five":5,"six":6,"seven":7,"eight":8,"nine":9]
        self.lines.forEach { line in
            if line != "" {
                var firstDigit = 0
                var firstIndex = line.endIndex //worse case scenario
                var lastDigit = 0
                var lastIndex = line.startIndex //worse case scenario
                digits.forEach { (key: String, value: Int)
                    in
                    if let range = line.range(of:key) {
                        //found the key, now let's check if it's the earliest we've seen so far
                        if range.lowerBound <= firstIndex {
                            firstDigit = value
                            firstIndex = range.lowerBound
                        }
                    }
                    if let range = line.range(of:key, options:.backwards) {
                        //or the latest
                        if range.lowerBound >= lastIndex {
                            lastDigit = value
                            lastIndex = range.lowerBound
                        }
                    }
                }
            let number = "\(firstDigit)\(lastDigit)"
            //print("\(line) : \(number)")
            sum += Int(number)!
            
            }
        }
        return sum
    }
}
