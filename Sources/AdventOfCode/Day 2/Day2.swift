import RegexBuilder

struct Day2: Solution {
    static let day = 2
    var games : [Game] = []
    let bag = Hand(b: 14, r: 12, g: 13)
    
    init(input: String) {
        //Process input into structs
        var tmpGames: [Game] = []
        input.enumerateLines { line, stop in
            //let's crack out the regex
            //Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
            //let search1 = /^Game (\d+): (.+?)$/
            let search1 = Regex {
                /^/
                "Game "
                Capture {
                    OneOrMore(.digit)
                }
                ": "
                Capture {
                    OneOrMore(.reluctant) {
                        /./
                    }
                }
                /$/
            }
            
            if let match = line.firstMatch(of: search1) {
                let (wholematch, gamenum, hands) = match.output
                //print("Game number: \(gamenum)")
                //print("Games: \(games)")
                
                let game = Game(num: gamenum, rawhands: hands)
                tmpGames.append(game)
            } else {
                fatalError("regex failure")
            }
        }
        self.games = tmpGames
    }

    func calculatePartOne() -> Int {

        //Now do the actual puzzle.
        var sumOfIds = 0
        for game in games {
            if game.possible(bag: bag) {
                sumOfIds += game.number
            }
        }
        
        return sumOfIds
    }
    
    func calculatePartTwo() -> Int {
        var sumofPower = 0
        for game in games {
            sumofPower += game.power()
        }
        return sumofPower
    }
}

struct Game {
    var number : Int
    var hands : [Hand]
    
    init(num:Int){
        self.number = num
        self.hands = []
    }
    
    init(num:Substring, rawhands:Substring){
        self.init(num: Int(num)!)
        
        //parse rawgames
        rawhands.components(separatedBy: ";").forEach { rawhand in
            //now need to parse the hand.
            //looks like the order of colours isn't consistent. And there may be 1 to 3 colours present.
            //e,g: 3 blue, 4 red
            //Do I bother wrangling the regex? Or just split on space and manually wrangle?
            let chunks = rawhand.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces)
            //let colormap = stride(from: 1, to: chunks.count, by: 2).map {(chunks[$0], chunks[$0-1])}
            var colormap : [String:Int] = [:]
            stride(from: 1, to: chunks.count, by: 2).forEach { i in
                colormap[String(chunks[i]).trimmingCharacters(in: .punctuationCharacters)] = Int(chunks[i-1])
            }
            //print(colormap["red"])
            self.hands.append(Hand(b: colormap["blue"], r: colormap["red"], g: colormap["green"]))
        }
    }
    
    func possible(bag: Hand)->Bool {
        var possible = true
        for hand in hands {
            if hand.blue <= bag.blue && hand.red <= bag.red && hand.green <= bag.green {
               //ok
            } else {
                possible = false
            }
        }
        
        return possible
    }
    
    func power()->Int {
        //power is red * blue * green of minimal set of RBG
        let minbag = self.minimalBag()
        return minbag.blue * minbag.red * minbag.green
    }
    
    func minimalBag()->Hand {
        var minBag = Hand(b: 0, r: 0, g: 0)
        for hand in hands {
            minBag.blue = max(minBag.blue, hand.blue)
            minBag.red = max(minBag.red, hand.red)
            minBag.green = max(minBag.green, hand.green)
        }
        return minBag
    }
    
    

}

struct Hand {
    var blue, red, green : Int
    
    init(b:Int?,r:Int?,g:Int?) {
        self.blue = b ?? 0
        self.red = r ?? 0
        self.green = g ?? 0
    }
}
