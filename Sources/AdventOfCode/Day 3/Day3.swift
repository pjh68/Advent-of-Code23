import Foundation
import RegexBuilder

struct Day3: Solution {
    static let day = 3
    
    ///Vague plan of attack for Day 3
    ///Find all the numbers -> test if they have punctuation adjacent to them
    ///Row and Column numbering scheme, with some fun edge behaviour
    
    
    var matrix : StringMatrix
    init(input: String) {
        self.matrix = StringMatrix(input)
    }
    
    func isPartNumberSymbol(_ char:Character?)->Bool {
        if char == nil {
            return false
        } else if char == "." || char!.isNumber {
            return false
        } else {
            return true
        }
    }
    
    func calculatePartOne() -> Int {
        //let's see if Regex helps or sends us insane.. actually, I'm already tired of the complexity of swift's strings... let's just bruteforce it.
        var inNumber = false
        var isPartNumber = false
        var digits:[Character] = []
        var partNumbers:[Int] = []
        
        for r in 0..<matrix.rows {
            for c in 0..<matrix.columns {
                let char = matrix[r,c]!
                var lastChar = false
                if char.isNumber {
                    inNumber = true
                    //add to array
                    digits.append(char)
                    //check if part number: above and below, left, right and diagonals
                    if isPartNumberSymbol(matrix[r-1,c]) 
                        || isPartNumberSymbol(matrix[r-1,c-1])
                        || isPartNumberSymbol(matrix[r-1,c+1])
                        || isPartNumberSymbol(matrix[r+1,c-1])
                        || isPartNumberSymbol(matrix[r+1,c])
                        || isPartNumberSymbol(matrix[r+1,c+1])
                        || isPartNumberSymbol(matrix[r,c-1])
                        || isPartNumberSymbol(matrix[r,c+1])
                    {
                        isPartNumber = true
                    }
                    
                    if c + 1 == matrix.columns {
                        //reached end of number
                        lastChar = true
                    }
                    
                } else if inNumber {
                        //reached the character after the number
                        lastChar = true
                }
                if lastChar {
                    let partNumber = Int(String(digits))!
                    //wrap up logic
                    if isPartNumber {
                        
                        print("Found part number: \(partNumber)")
                        partNumbers.append(partNumber)
                    } else {
                        print("Not a part number: \(partNumber)")
                    }
                    
                    //reset flags
                    inNumber = false
                    isPartNumber = false
                    digits = []
                    
                }
                
            }
        }
        
        return partNumbers.sum()
    }
    
    ///Notes from part 1: OMG this is slow.. I think it's because using String as the backing for my array is terribly inefficeint.... every subscript access is a full traverse of the string ---> now changed to Array of characters and it's "blink of an eye" fast to run.
    // answer:Part One: 546312
    
    func calculatePartTwo() -> Int {
        ///Need to find star symbol
        ///If it's got two number around it, it's a gear
        ///Finding star is easy. Detecting if it's got only two number harder...
        ///Would benefit from having coordinates of all numbers, and then testing if 9-way surround of star "hits" any of those numbers.
        ///It's almost battleships!
        var inNumber = false
        var isPartNumber = false
        var startCol = 0
        var endCol = 0
        var digits:[Character] = []
        var partNumbers:[NumberInMatrix] = []
        //Parse numbers
        for r in 0..<matrix.rows {
            for c in 0..<matrix.columns {
                let char = matrix[r,c]!
                var lastChar = false
                if char.isNumber {
                    if !inNumber {
                        //start of number
                        startCol = c
                    }
                    
                    
                    
                    inNumber = true
                    //add to array
                    digits.append(char)
                    
                    if c + 1 == matrix.columns {
                        //reached end of number
                        lastChar = true
                        endCol = c
                    }
                    
                } else if inNumber {
                    //reached the character after the number
                    lastChar = true
                    endCol = c - 1
                }
                if lastChar {
                    let partNumber = Int(String(digits))!
                    partNumbers.append(NumberInMatrix(row: r, colStart: startCol, colEnd: endCol, number: partNumber))
                    
                    //reset flags
                    inNumber = false
                    isPartNumber = false
                    digits = []
                    startCol = 0
                    endCol = 0
                }
                
            }
        }
        
        
        //Parse through *
        var gearRatioSum = 0
        for r in 0..<matrix.rows {
            for c in 0..<matrix.columns {
                let char = matrix[r,c]!
                if char == "*" {
                    let matchedNumbers = partNumbers.filter({ num in
                        num.hitAround(r: r, c: c)
                    })
                    //print("* at \(r),\(c) has \(matchedNumbers.count) adjacent numbers: \(matchedNumbers)")
                    if matchedNumbers.count == 2{
                        let gearRatio = matchedNumbers[0].number * matchedNumbers[1].number
                        gearRatioSum += gearRatio
                    }
                }
            }
        }
        
        return gearRatioSum
    }
    
    ///Dirty quick test code to make sure I've not messed up
    func matrixTests() {
        var test = """
word
play
deck
"""
        var matrix = StringMatrix( test)
        print("\(matrix.rows) x \(matrix.columns)")
        print("0,0 \(matrix[0,0] ?? "!")")
        print("0,2 \(matrix[0,2] ?? "!")")
        print("1,0 \(matrix[1,0] ?? "!")")
        print("2,2 \(matrix[2,2] ?? "!")")
        print("conversion test")
        let index = matrix.rcToIndex(row: 2, col: 2)
        let rc = matrix.indexToRc(index: index)
        print("2:2 should be \(rc)")

    }
}

///Let's have some fun with Structs
///

struct StringMatrix {
    let rows: Int, columns: Int
    var str: [Character]
    init(_ string: String) {
        self.str = Array(string)
        self.columns = string.firstIndex(of: "\n")?.utf16Offset(in: string) ?? 0
        self.rows = (string.count + 1) / (self.columns + 1)
    }
    
    func indexIsValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < columns
    }
    
    func rcToIndex(row: Int, col: Int) -> Int {
        return row * (columns + 1) + col
    }
    
    func indexToRc(index: Int) -> (Int, Int) {
        let row = index / (self.columns + 1)
        let col = index % (self.columns + 1)
        return (row, col)
    }
    
    subscript(row:Int, col:Int) -> Character? {
        get {
            if indexIsValid(row: row, col: col) {
                return self.str[rcToIndex(row: row, col: col)]
            } else {
                return nil
            }
        }
//        set {
//            assert(indexIsValid(row: row, col: col), "Index out of range")
//            self.str.replaceSubrange(rcToIndex(row: row, col: col), with: newValue)
//        }
        
    }
    
}


struct NumberInMatrix {
    let row: Int, colStart: Int, colEnd: Int, number: Int
    init(row: Int, colStart: Int, colEnd: Int, number: Int) {
        self.row = row
        self.colStart = colStart
        self.colEnd = colEnd
        self.number = number
    }
    ///Is this number hit by a strike at r,c?
    func hit(r: Int, c:Int) -> Bool {
        return r==row && c>=colStart && c<=colEnd
    }
    ///Is this number hit by a strike around r,c (8 way)
    func hitAround(r:Int, c:Int) -> Bool {
        return  self.hit(r: r, c: c-1) ||
                self.hit(r: r, c: c+1) ||
                self.hit(r: r+1, c: c-1) ||
                self.hit(r: r+1, c: c+1) ||
                self.hit(r: r+1, c: c) ||
                self.hit(r: r-1, c: c-1) ||
                self.hit(r: r-1, c: c+1) ||
                self.hit(r: r-1, c: c)
    }
}





extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}
