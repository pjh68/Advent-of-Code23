import Foundation

struct Day7: Solution {
    static let day = 7
    var hands : [Hand]
    
    init(input: String) {
        self.hands = input.split(separator: "\n").compactMap({Hand(String($0))})
    }
    
    func calculatePartOne() -> Int {
        let sortedHands = hands.sorted { h1, h2 in
            h1.strength < h2.strength
        }
        var winnings = 0
        var rank = 1
        for h in sortedHands {
            print("Rank: \(rank) Hand: \(h.cards) Strength: \(h.strength)")
            winnings += (rank * h.bid)
            rank += 1
        }
        return winnings
        
    }
    
    func calculatePartTwo() -> Int {
        0
    }
}

/// Approach:
/// first thought was to use enum for playing cards... but that's a bit overkill as we can just use Int and map the higher cards to higher numbers - there is no special handling of numeric vs face cards, and no consideration of suits
/// I really want to work in base 13... possible, but could make life easier for standardisation and use base 16... Trick: don't bother splitting up string and coverting to ints... instead relabel the face cards and treat the values as hexidecimal.. automatic comparison!

struct Hand {
    var cards:String
    var bid:Int

    init(_ input:String){
        let splits = input.split(separator: " ")
        self.bid = Int(splits[1])!
        self.cards = String(Array(splits[0]).map({Hand.cardToHexDigit(card: $0)}))
    }
    
    var strength : Int {
        //Two thoughts on approach here:
        //1. Build a custom comparitor which chomps through the rules
        //2. Contruct a single value "rank" which combines the rules to produce a single number
        let tiebreak : Int = Int(self.cards, radix: 16)!

        let histogram = cards.histogram.values
        var primaryRank = 0
        if histogram.contains(5) {
            primaryRank = 6
        } else if histogram.contains(4) {
            primaryRank = 5
        } else if histogram.contains(3) && histogram.contains(2) {
            primaryRank = 4
        }else if histogram.contains(3) {
            primaryRank = 3
        } else if histogram.filter({$0==2}).count == 2 {
            primaryRank = 2
        } else if histogram.contains(2) {
            primaryRank = 1
        }
        
        return primaryRank * Int("a000000", radix: 16)! + tiebreak
    }
    
    private static func cardToHexDigit(card:Character)->Character {
        if card.isNumber {
            return card
        } else {
            switch card {
            case "T":
                return "a"
            case "J":
                return "b"
            case "Q":
                return "c"
            case "K":
                return "d"
            case "A":
                return "e"
            default:
                fatalError()
            }
        }
    }
}

//Source: https://stackoverflow.com/questions/30545518/how-to-count-occurrences-of-an-element-in-a-swift-array
extension Sequence where Element: Hashable {
    var histogram: [Element: Int] {
        return self.reduce(into: [:]) { counts, elem in counts[elem, default: 0] += 1 }
    }
}
