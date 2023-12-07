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
        //I don't have a good way of making part2 work whilst preserving part 1... so I'm not going to bother today.
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
        self.cards = String(splits[0])
    }
    
    func primaryStrength(_ theseCards:String) -> Int {
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
    static func bestHand(_ theseCards:String) -> String {
        if !theseCards.contains("J") {
            return theseCards
        }
        
        
        
        let sortedHistogram = theseCards.histogram.sorted { $0.1 > $1.1 }
        //^^^ this producing an array of tuples (key: xxx, value: xxx)
        
        var bestCard : String? = nil
        for candidate in sortedHistogram {
            if candidate.key != "J" {
                bestCard = String(candidate.key)
                break
            }
        }
        
        if bestCard==nil {
            //all jokers... so any card will do
            bestCard = "2"
        }
        
        let jokerCards = theseCards.replacingOccurrences(of: "J", with: bestCard!)
        return jokerCards
    }
    
    var strength : Int {
        //Two thoughts on approach here:
        //1. Build a custom comparitor which chomps through the rules
        //2. Contruct a single value "rank" which combines the rules to produce a single number
        
        let hexCards = String(Array(cards).map({Hand.cardToHexDigit(card: $0)}))
        let tiebreak : Int = Int(hexCards, radix: 16)!

        //Part 2... options for joker.
        //A few possible approach here...
        //1. brute force it... try it with all possible options (max 15 per hand), pick higest
        //2. smartly: find the current best scoring part of a hand and add to that... might create some challenges:
        //    complexity 1: around 2 pairs.. would you ever create 2 pair, given you could always make 3 of a kind
        //    complixity 2: multiple jokers... can just work iteratively!
        // edge case: more jokers than other cards!
        // edge case: all jokers
        

        let jokerCards = Hand.bestHand(self.cards)
        let pStrength = self.primaryStrength(jokerCards)

        return pStrength * Int("a000000", radix: 16)! + tiebreak
    }
    
    private static func cardToHexDigit(card:Character)->Character {
        if card.isNumber {
            return card
        } else {
            switch card {
            case "T":
                return "a"
            case "J":
                return "1" //changed for part 2
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
