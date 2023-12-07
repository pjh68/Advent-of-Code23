import Foundation


/// Approach:
/// first thought was to use enum for playing cards... but that's a bit overkill as we can just use Int and map the higher cards to higher numbers - there is no special handling of numeric vs face cards, and no consideration of suits
/// I really want to work in base 13... possible, but could make life easier for standardisation and use base 16... Trick: don't bother splitting up string and coverting to ints... instead relabel the face cards and treat the values as hexidecimal.. automatic comparison!


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
            //print("Rank: \(rank) Hand: \(h.cards) Strength: \(h.strength)")
            winnings += (rank * h.bid)
            rank += 1
        }
        return winnings
    }
    
    func calculatePartTwo() -> Int {
        //I don't have a good way of making part2 work whilst preserving part 1... so I'm not going to bother today.
        let sortedHands = hands.sorted { h1, h2 in
            h1.strengthWithJokers < h2.strengthWithJokers
        }
        var winnings = 0
        var rank = 1
        for h in sortedHands {
            //print("Rank: \(rank) Hand: \(h.cards) Strength: \(h.strength)")
            winnings += (rank * h.bid)
            rank += 1
        }
        return winnings
    }
}



struct Hand {
    var cards:String
    var bid:Int

    init(_ input:String){
        let splits = input.split(separator: " ")
        self.bid = Int(splits[1])!
        self.cards = String(splits[0])
    }
    
    private static func primaryStrength(_ theseCards:String) -> Int {
        let histogram = theseCards.histogram.values
        var primaryStrength = 0
        if histogram.contains(5) {
            primaryStrength = 6
        } else if histogram.contains(4) {
            primaryStrength = 5
        } else if histogram.contains(3) && histogram.contains(2) {
            primaryStrength = 4
        }else if histogram.contains(3) {
            primaryStrength = 3
        } else if histogram.filter({$0==2}).count == 2 {
            primaryStrength = 2
        } else if histogram.contains(2) {
            primaryStrength = 1
        }
        return primaryStrength
    }
    

    //get the best hand availabe from jokers
    static func bestHandFromJokers(_ theseCards:String) -> String {
        if !theseCards.contains("J") {
            return theseCards
        }
        
        let bestCard = String(theseCards.histogram.sorted { $0.1 > $1.1 }.first(where: {$0.key != "J"})?.key ?? "2")
        
        let jokerCards = theseCards.replacingOccurrences(of: "J", with: bestCard)
        return jokerCards
    }
    
    var strengthWithJokers : Int {
        let hexCards = String(Array(cards).map({Hand.cardToHexDigit(card: $0, jokers: true)}))
        let tiebreak : Int = Int(hexCards, radix: 16)!

        let jokerCards = Hand.bestHandFromJokers(self.cards)
        let pStrength = Hand.primaryStrength(jokerCards)
        
        return pStrength * Int("a000000", radix: 16)! + tiebreak
    }
    
    var strength : Int {
        let hexCards = String(Array(cards).map({Hand.cardToHexDigit(card: $0)}))
        let tiebreak : Int = Int(hexCards, radix: 16)!
        let pStrength = Hand.primaryStrength(self.cards)
        return pStrength * Int("a000000", radix: 16)! + tiebreak
    }
    
    private static func cardToHexDigit(card:Character, jokers:Bool = false)->Character {
        if card.isNumber {
            return card
        } else {
            switch card {
            case "T":
                return "a"
            case "J":
                return jokers ? "1" : "b"
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
