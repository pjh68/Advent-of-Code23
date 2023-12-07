import Foundation
import Collections

struct Day4: Solution {
    static let day = 4
    var cards:[LotteryCard] = []
    
    init(input: String) {
        var tmpCard:[LotteryCard] = []
        input.enumerateLines { line, stop in
            tmpCard.append(LotteryCard(line))
        }
        self.cards = tmpCard
    }

    func calculatePartOne() -> Int {
        return cards.reduce(0) { $0 + $1.score() }
    }
    
    func calculatePartTwo() -> Int {
        //Need to do some funky copying
        //Could possibly do this more efficiently using maths (the question hits to this)... but let's try a brute force approach first.
        var cardsToProcess = Deque(self.cards)
        var cardCount = 0
        while var nextCard = cardsToProcess.popFirst() {
            cardCount += 1
            let index = nextCard.index
            for i in (index + 1)..<(index + 1 + nextCard.matchCount) {
                if i<self.cards.count {
                    cardsToProcess.append(self.cards[i])
                }
            }
        }
        
        return cardCount
    }
}

struct LotteryCard {
    var cardNumber:Int, winningNumbers:Set<Int>, yourNumbers:Set<Int>
    
    var index: Int {
        get {
            return self.cardNumber - 1
        }
    }
    
    init(_ input:String){
        //print("\(input)")
        let split1 = input.split(separator: ":")
        self.cardNumber = Int(split1[0].split(separator: " ")[1])!
        let split2 = split1[1].trimmingCharacters(in: .whitespaces).components(separatedBy: "|")
        self.winningNumbers = Set(split2[0].split(separator: " ").map({Int($0)!}))      // Set(split2[0].trimmingCharacters(in: .whitespaces).components(separatedBy: " ").map({Int($0)!}))
        self.yourNumbers = Set(split2[1].split(separator: " ").map({Int($0)!}))
    }
    
    lazy var matchCount = self.matches()
    
    func matches()->Int {
        let match = self.winningNumbers.intersection(self.yourNumbers)
        return match.count
    }
    
    func score()->Int {
        var mc = self.winningNumbers.intersection(self.yourNumbers).count
        if mc > 0 {
            var score = pow(2.0, (mc - 1))   //2^(matchCount - 1)
            //print("Card: \(cardNumber), Score: \(score)")
            return (score as NSDecimalNumber).intValue
        } else {
            return 0
        }
    }
}
