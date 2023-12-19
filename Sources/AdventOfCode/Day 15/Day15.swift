struct Day15: Solution {
    static let day = 15
    let seq : [String]
    
    init(input: String) {
        seq = input.split(separator: ",").map({String($0).replacingOccurrences(of: "\n", with: "")})
        
    }
    
    func calculatePartOne() -> Int {
        return seq.reduce(0, {$0 + hashAlgo($1)})
    }
    
    func calculatePartTwo() -> Int {
        0
    }
    
//    The HASH algorithm is a way to turn any string of characters into a single number in the range 0 to 255. To run the HASH algorithm on a string, start with a current value of 0. Then, for each character in the string starting from the beginning:
//
//    Determine the ASCII code for the current character of the string.
//    Increase the current value by the ASCII code you just determined.
//    Set the current value to itself multiplied by 17.
//    Set the current value to the remainder of dividing itself by 256.
    func hashAlgo(_ input:String)->Int {
        var value = 0
        for char in Array(input) {
            let ascii = char.asciiValue!
            value += Int(ascii)
            value = value * 17
            value = value % 256
        }
        //print("- \(input) becomes \(value)")
        return value
    }
    
    
}
