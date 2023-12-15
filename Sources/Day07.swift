import Algorithms
import Collections
import Foundation
import Swift

struct Day07: AdventDay {
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
        // maybe a heap of <Hand> ,
        // insert/sort by type
        // then reorder by rank
        // then get winnings (might be slow but will use dict)
        // there is no official heap in swift Collections, so I guess we'll just have to use array and sort?
        var ranking = initRankings(entities: entities, jokers: false)
        ranking.sort { $0 < $1 }
        // print(ranking)
        var index = 1
        return ranking.reduce(into: 0) {
            sum, hand in
            sum = sum + (hand.bid * index)
            index += 1
        }
        // return "Not yet implemented"
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        var ranking = initRankings(entities: entities, jokers: true)
        ranking.sort { $0 < $1 }
        // var jokerIndexes: [Int] = []
        // var i = 0
        // ranking.forEach { if $0.jokers && $0.jokerNums == 1 { jokerIndexes.append(i) }; i += 1 }
        // print(jokerIndexes)
        // for j in jokerIndexes {
        //     print(ranking[j])
        // }
        var index = 1
        return ranking.reduce(into: 0) {
            sum, hand in
            // print(hand.toString())
            sum = sum + (hand.bid * index)
            index += 1
        }
    }
}

struct Hand {
    var values: [Int]
    var type: Int
    var bid: Int
    var jokers: Bool
    var jokerNums: Int?
    var debug: Bool?
    // type is integer representation of high,one pair, two pair, 3 of a kind, etc..
    // starting from 0 == high card
    mutating func setType() {
        var seen: [Int: Int] = [:]
        values.forEach {
            card in
            if let count = seen[card] {
                seen[card] = count + 1
            } else {
                seen[card] = 1
            }
        }
        type = determinHandType(seen: seen)
    }

    func toString() -> String {
        return "\(values) -> \(bid)"
    }

    mutating func setTypeWithJokers() {
        var seen: [Int: Int] = [:]
        values.forEach {
            card in
            if let count = seen[card] {
                seen[card] = count + 1
            } else {
                seen[card] = 1
            }
        }
        if seen[1] != nil { jokers = true; jokerNums = seen[1]! }
        type = determineHandWithJokers(seen: &seen)
    }

    mutating func testType() {
        var seen: [Int: Int] = [:]
        values.forEach {
            card in
            if let count = seen[card] {
                seen[card] = count + 1
            } else {
                seen[card] = 1
            }
        }
        type = determineHandWithJokers(seen: &seen)
    }

    func determinHandType(seen: [Int: Int]) -> Int {
        var pair = false
        var three = false
        for key in seen.keys {
            switch seen[key] {
            case 5, 4:
                return seen[key]! + 1
            case 3:
                if !pair {
                    three = true
                } else {
                    return 4
                }
            case 2:
                if three {
                    return 4
                } else if pair {
                    return 2
                } else {
                    pair = true
                }
            default:
                break
            }
        }
        if three {
            return 3
        }
        return pair ? 1 : 0
    }

    func determineHandWithJokers(seen: inout [Int: Int]) -> Int {
        let jokers = seen[1]
        if jokers == nil { return determinHandType(seen: seen) }
        seen.removeValue(forKey: 1)
        // print("---------------")
        // print("Jokers #: \(jokers)")
        // print("seen dict without jokers")
        // print(seen)
        var pair = false
        var type = 0
        for key in seen.keys {
            let amount = seen[key]!
            if amount == 5 || amount == 4 {
                type = seen[key]! + 1
                break
            }
            if amount == 3 {
                type = 3
                break
            }
            if amount == 2 && pair {
                type = 2

                if debug != nil && debug! {
                    print("found double : \(key): \(amount)")
                }
                break
            }
            if amount == 2 {
                pair = true
                type = 1
                if debug != nil && debug! {
                    print("found first pair and set: \(key): \(amount)")
                }
            }
        }
        if debug != nil && debug! {
            print("Seen before Jokers: \(seen)")
            print("Type before jokers: \(type)")
        }
        if jokers! == 4 || jokers! == 5 { return 6 }
        if jokers! == 3 && type == 0 { return 5 }
        if jokers! == 3 && type == 1 { return 6 }
        if jokers! == 2, type == 1 { return 5 }
        if jokers! == 2, type == 0 { return 3 }
        if jokers! == 2 { return 6 }
        if jokers! == 1, type == 0 { return 1 }
        if jokers! == 1, type == 1 { return 3 }
        if jokers! == 1, type == 2 { return 4 }
        if jokers! == 1, type == 3 { return 5 }
        if jokers! == 1, type == 5 { return 6 }
        return type
    }
}

func changeToInt(_ cardValue: Character, _ jokers: Bool) -> Int {
    switch cardValue {
    case "T":
        return 10
    case "J":
        if jokers { return 1 } else { return 11 }
    case "Q":
        return 12
    case "K":
        return 13
    case "A":
        return 14
    default:
        return Int(String(cardValue))!
    }
}

func initRankings(entities: [String], jokers: Bool) -> [Hand] {
    return entities.map {
        line in
        let values = line.split(separator: " ")
        let cardValues = values[0].map { changeToInt($0, jokers) }
        var newHand = Hand(values: cardValues, type: 0, bid: Int(String(values[1]))!, jokers: false)
        if !jokers { newHand.setType() } else { newHand.setTypeWithJokers() }
        return newHand
    }
}

extension Hand: Comparable {
    static func == (lhs: Hand, rhs: Hand) -> Bool {
        return lhs.type == rhs.type && lhs.values == rhs.values
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        if lhs.type != rhs.type {
            return lhs.type < rhs.type
        } else if lhs.values[0] != rhs.values[0] {
            return lhs.values[0] < rhs.values[0]
        } else if lhs.values[1] != rhs.values[1] {
            return lhs.values[1] < rhs.values[1]
        } else if lhs.values[2] != rhs.values[2] {
            return lhs.values[2] < rhs.values[2]
        } else if lhs.values[3] != rhs.values[3] {
            return lhs.values[3] < rhs.values[3]
        } else {
            return lhs.values[4] < rhs.values[4]
        }
    }
}
