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
        var myCollection = CardCollection(originals: [])
        entities.forEach {
            lineString in
            let halves = lineString.split(separator: "|")
            let winingNumbers: [Int] = halves[0].split(separator: ":").last!.split(separator: " ").map { Int($0)! }
            let holdingNumbers: [Int] = halves[1].split(separator: " ").map { Int($0)! }
            let original = Card(winningNumbers: winingNumbers, holdingNumbers: holdingNumbers)
            myCollection.addOriginal(original: original)
        }

        myCollection.domainExpansion()
        return myCollection.totalCards()
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

    func copy() -> Card {
        return Card(winningNumbers: winningNumbers, holdingNumbers: holdingNumbers)
    }
}

struct CardCollection {
    var originals: [Card]
    var copies: [Int: [Card]] = [:]

    mutating func domainExpansion() {
        for i in 0 ..< originals.count {
            // print("-----------------start")
            // print("working on card: \(i + 1)")
            cardExpansion(from: originals[i], currentIndex: i)
            if copies[i] != nil {
                // print("Copies for card: \(i + 1)")

                for item in copies[i]! {
                    cardExpansion(from: item, currentIndex: i)
                }

                // print("---------copies end-----")
            }
            // print("-----------------end")
        }
    }

    mutating func cardExpansion(from: Card, currentIndex: Int) {
        let numCopies = from.getMatches().count

        if numCopies == 0 {
            return
        }

        for i in 1 ... numCopies {
            // print("made a copy of card #: \(currentIndex + i + 1)")
            makeCopies(copyIndex: currentIndex + i)
        }
    }

    mutating func makeCopies(copyIndex: Int) {
        let newCard = originals[copyIndex].copy()
        var copyList = copies[copyIndex]
        if copyList == nil {
            copies[copyIndex] = [newCard]
        } else {
            copyList!.append(newCard)
            copies[copyIndex] = copyList
        }
    }

    mutating func addOriginal(original: Card) {
        originals.append(original)
    }

    func totalCards() -> Int {
        return copies.reduce(0) {
            sum, dictEntry in
            sum + dictEntry.value.count
        } + originals.count
    }
}
