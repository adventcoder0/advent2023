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

            let mapping = words.map { numString in
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
    func part2() -> Any {
        let seedString = entities[0].split(separator: " ").dropFirst()
        let seedValues: [Int] = seedString.map { Int(String($0))! }
        var rangeList = getInitList(seedValues)
        var mappingSet: [[Int]] = []

        for lineNum in 1 ..< entities.count {
            let words = entities[lineNum].split(separator: " ")
            if words[1] == "map:" {
                if mappingSet.isEmpty { continue }
                processMapping(rangeList: &rangeList, mappingSet: &mappingSet)
                continue
            }

            let mapping = words.map { numString in
                Int(String(numString))!
            }

            mappingSet.append(mapping)
        }

        processMapping(rangeList: &rangeList, mappingSet: &mappingSet)
        return rangeList[0][0]
    }

    func getInitList(_ seedValues: [Int]) -> [[Int]] {
        var rangeList: [[Int]] = []
        var start = true
        var range: [Int] = [0, 0]
        for num in 0 ..< seedValues.count {
            if start == true {
                range[0] = seedValues[num]
                start = false
                continue
            }
            range[1] = seedValues[num]
            rangeList.append(range)
            start = true
        }
        return rangeList.sorted { $0[0] < $1[0] }
    }

    func processMapping(rangeList: inout [[Int]], mappingSet: inout [[Int]]) {
        mappingSet = mappingSet.sorted { $0[1] < $1[1] }
        adjustRangeList(rangeList: &rangeList, mappingSet: mappingSet)
        // printStatus(rangeList: rangeList, mappingSet: mappingSet)
        mappingSet = []
    }

    func adjustRangeList(rangeList: inout [[Int]], mappingSet: [[Int]]) {
        var newRanges: [[Int]] = []
        for rangePair in rangeList {
            let rangeSplits = splitRange(rangePair: rangePair, mappingSet: mappingSet)
            rangeSplits.forEach { newRanges.append($0) }
        }
        rangeList = newRanges.sorted { $0[0] < $1[0] }
    }

    func splitRange(rangePair: [Int], mappingSet: [[Int]]) -> [[Int]] {
        var splits: [[Int]] = []
        let rangeStart = rangePair[0]
        let rangeLength = rangePair[1]

        for mapping in mappingSet {
            let adjustRangeByValue = mapping[0] - mapping[1]
            let mapStart = mapping[1]
            let mapLength = mapping[2]
            let startDiff = rangeStart - mapStart
            if startDiff >= mapLength {
                continue
            }

            if rangeLength + startDiff <= 0 {
                break
            }

            let needExtra = rangeStart + rangeLength > mapStart + mapLength

            if needExtra, startDiff < 0 {
                splits.append([rangeStart, 0 - startDiff])
                splits.append([mapStart + adjustRangeByValue, mapLength])
                splits.append([mapStart + mapLength, rangeLength + startDiff - mapLength])
                break
            } else if needExtra, startDiff >= 0 {
                splits.append([rangeStart + adjustRangeByValue, mapStart + mapLength - rangeStart])
                splits.append([mapStart + mapLength, rangeLength + startDiff - mapLength])
                break
            } else if startDiff < 0 {
                splits.append([rangeStart, 0 - startDiff])
                splits.append([mapStart + adjustRangeByValue, rangeLength + startDiff])
                break
            } else {
                splits.append([rangeStart + adjustRangeByValue, rangeLength])
                break
            }
        }
        if splits.isEmpty {
            return [rangePair]
        }
        return splits
    }
}
