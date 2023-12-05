import Algorithms
import Foundation

struct Day04: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "\n").map {
            String($0)
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        return entities.reduce(0) {
            totalWorth, lineString in
            let halves = lineString.split(separator: "|")
            let winingNumbers: [Int] = halves[0].split(separator: ":").last!.split(separator: " ").map { Int($0)! }
            let holdingNumbers: [Int] = halves[1].split(separator: " ").map { Int($0)! }
            let worth = Card(winningNumbers: winingNumbers, holdingNumbers: holdingNumbers).getWorth()
            return totalWorth + worth
        }
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        var numMatches: [Int] = []
        var numCards: [Int] = Array(repeating: 1, count: entities.count)
        entities.forEach {
            lineString in
            let halves = lineString.split(separator: "|")
            let winingNumbers: [Int] = halves[0].split(separator: ":").last!.split(separator: " ").map { Int($0)! }
            let holdingNumbers: [Int] = halves[1].split(separator: " ").map { Int($0)! }
            numMatches.append(Card(winningNumbers: winingNumbers, holdingNumbers: holdingNumbers).getMatches().count)
        }

        for cardNumber in 0 ..< numCards.count {
            let multiplier = numCards[cardNumber]
            // print("Number of cards for Card \(cardNumber + 1): \(multiplier)")
            // print("This card should propagate down to \(cardNumber + 1 + numMatches[cardNumber])")
            let depth = numMatches[cardNumber]
            if depth == 0 {
                continue
            }
            for i in 1 ... depth {
                // let cardToAdd = cardNumber + i
                // print("addingto \(cardToAdd + 1)")
                numCards[cardNumber + i] += multiplier
            }
            // print("state: \(numCards)")
            // print("---------------------")
        }
        // print("endList: \(numCards)")

        return numCards.reduce(0,+)
    }
}

struct Card {
    var winningNumbers: [Int]
    var holdingNumbers: [Int]

    func getMatches() -> [Int] {
        return holdingNumbers.filter { winningNumbers.contains($0) }
    }

    func getWorth() -> Int {
        return getMatches().isEmpty ? 0 : NSDecimalNumber(decimal: pow(2, getMatches().count - 1)).intValue
    }
}
