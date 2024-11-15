import Algorithms
import Foundation

struct Day05: AdventDay {
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
        let seedString = entities[0].split(separator: " ").dropFirst()
        var idValues = seedString.map { Int(String($0))! }
        var transformValues: [Int] = idValues

        for lineNum in 1 ..< entities.count {
            let words = entities[lineNum].split(separator: " ")

            if words[1] == "map:" {
                idValues = transformValues
                continue
            }

            let mapping = words.map {
                numString in
                Int(String(numString))!
            }

            let transformStartID = mapping[0]
            let seedStart = mapping[1]
            let seedEnd = seedStart + mapping[2]

            var index = 0
            for element in idValues {
                if seedStart <= element && element < seedEnd {
                    transformValues[index] = transformStartID + (element - seedStart)
                }
                index += 1
            }
        }

        return transformValues.min()!
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() throws -> Any {
        let seedString = entities[0].split(separator: " ").dropFirst()
        let seedValues: [Int] = seedString.map { Int(String($0))! }
        var seedRanges: [[Int]] = []
        var start = true
        var seedStart = 0
        var seedEnd = 0
        for value in seedValues {
            if start == true {
                seedStart = value
                start = false
            } else {
                seedEnd = seedStart + value - 1
                start = true
                seedRanges.append([seedStart, seedEnd])
            }
        }
        var currentRanges = seedRanges
        for lineNum in 1 ..< entities.count {
            let words = entities[lineNum].split(separator: " ")

            if words[1] == "map:" {
                currentRanges.sort()
                print("currentRanges = \(currentRanges)")
                print("new map")
                print("changing ranges:")

                continue
            }

            let mapping = words.map {
                numString in
                Int(String(numString))!
            }

            let newRangeStart = mapping[0]
            let mappingRangeStart = mapping[1]
            let offset = mapping[2] - 1
            let mappingRangeEnd = mappingRangeStart + offset
            let newRangeEnd = newRangeStart + offset

            print("before-> start: \(mappingRangeStart), end: \(mappingRangeStart + offset)")
            print("after-> start: \(newRangeStart), end: \(newRangeStart + offset)")

            var myNewRanges: [[Int]] = []
            for index in 0 ..< currentRanges.count {
                let checkRange = currentRanges[index]
                if checkRange[0] > mappingRangeStart + offset {
                    myNewRanges.append(checkRange)
                    continue
                }
                if checkRange[1] < mappingRangeStart {
                    myNewRanges.append(checkRange)
                    continue
                }
                var leftRange: [Int] = []
                var rightRange: [Int] = []
                var middleRange: [Int] = []
                // range 2 is from seeds
                // range 1 is from mapping
                // range 2 can start before range 1 start, need diff, keep numbers from before range 1 starts
                if checkRange[0] < mappingRangeStart {
                    // make leftside here
                    let diff = mappingRangeStart - checkRange[0]
                }

                // range 2 can start after range 1 start, need diff, remove numbers between starts
                // range 2 can end before range 1, need diff, remove number between ends
                // range 2 can end after range 1, keep numbers after range 1 end
                // make right side here
                let middleStart = max(mappingRangeStart, checkRange[0])
                let middleEnd = min(mappingRangeEnd, checkRange[1])
                let startDiff = abs(mappingRangeStart - checkRange[0])
                print("middles: \(middleStart) , \(middleEnd) diff: \(startDiff)")
            }
            currentRanges = myNewRanges
        }
        return seedValues
    }
}

enum BadTransformError: Error {
    case DifferentCount(countBefore: Int, countAfter: Int, before: [(Int, Int)], after: [(Int, Int)])
}

extension [Int]: Comparable {
    // this works because no overlap with ranges
    public static func < (lhs: [Int], rhs: [Int]) -> Bool {
        return lhs[0] < rhs[0]
    }
}
