import Foundation
import Collections

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
        //Need an ordered dictionary! Luckily swift collections has this, don't have to roll our own.
        
        
        //Boxes are 0 to 255
        
        var boxes : [OrderedDictionary<String, Int>] = []
        for i in 0..<256 {
            let emptyDict : OrderedDictionary<String, Int> = [:]
            boxes.append(emptyDict)
        }
        
        for lens in seq {
            //Need to split up each lens into label, operator (= or -) and focal length
            if lens.contains("=") {
                //add lens
                let comp = lens.split(separator: "=")
                let key = String(comp[0])
                let box = hashAlgo(key)
                let focal = Int(comp[1])!
                boxes[box].updateValue(focal, forKey: key)
            } else if lens.contains("-") {
                //remove lens
                let comp = lens.split(separator: "-")
                let key = String(comp[0])
                let box = hashAlgo(key)
                boxes[box].removeValue(forKey: key)

            } else {
                fatalError("Unexpected branch")
            }
        }
        
        //print("Boxes: \(boxes)")
        
        //Now do the calcs of focussing power
        var output = 0
        for (i, box) in boxes.enumerated() {
            for (j, lens) in box.enumerated() {
                let focalpower = (i+1) * (j+1) * lens.value
                output += focalpower
            }           
        }

        return output
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
