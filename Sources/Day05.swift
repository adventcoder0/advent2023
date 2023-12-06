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
            let rangeStart = mapping[1]
            let rangeEnd = rangeStart + mapping[2]

            var index = 0
            idValues.forEach {
                element in
                if rangeStart <= element && element < rangeEnd {
                    transformValues[index] = transformStartID + (element - rangeStart)
                }
                index += 1
            }
        }

        return transformValues.min()!
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        let seedString = entities[0].split(separator: " ").dropFirst()
        var idRanges: [(Int, Int)] = []
        var startRange: Int? = nil
        seedString.forEach {
            numString in
            if startRange == nil {
                startRange = Int(String(numString))!
                return
            }
            let endRange = Int(String(numString))! + startRange!
            idRanges.append((startRange!, endRange))
            startRange = nil
        }
        //
        // print(idRanges)
        idRanges.sort { $0.1 < $1.0 }
        var transformedRanges: [(Int, Int)] = idRanges
        for lineNum in 1 ..< entities.count {
            let words = entities[lineNum].split(separator: " ")

            if words[1] == "map:" {
                transformedRanges.sort { $0.1 < $1.0 }
                idRanges = transformedRanges
                continue
            }

            let mapping = words.map {
                numString in
                Int(String(numString))!
            }

            let needChangeRangeStart = mapping[0]
            let needChangeRangeEnd = needChangeRangeStart + mapping[2]
            let changeToRangeStart = mapping[1]
            let changeToRangeEnd = mapping[1] + mapping[2]

            for index in 0 ..< idRanges.count {
                if needChangeRangeEnd <= idRanges[index].0 {
                    // the range that needs to be transformed is before the current range,
                    // the next ranges will be higher, so we can break here
                    break
                }
                if idRanges[index].1 <= needChangeRangeStart {
                    continue
                }
                // get overlaps
                // interests: idRange[index].0 will always be leftmost
                // idRange[index].1 will always be the rightmost
                // things outside the range dont correspond to seeds
                let leftBorder = idRanges[index].0
                let rightBorder = idRanges[index].1
                var rangeStart = leftBorder
                if needChangeRangeStart > leftBorder {
                    // this part is right, things outside neededchange range don't need to change
                    transformedRanges.append((leftBorder, needChangeRangeStart))
                    rangeStart = needChangeRangeStart
                }
                if needChangeRangeEnd <= rightBorder && needChangeRangeStart == rangeStart {
                    // this is right, the whole needchange range is a subrange, so no adjustment is needed
                    transformedRanges.append((changeToRangeStart, changeToRangeEnd))
                    transformedRanges.append((needChangeRangeEnd, rightBorder))
                } else if needChangeRangeEnd <= rightBorder {
                    let diff = needChangeRangeEnd - rangeStart
                    transformedRanges.append((changeToRangeEnd - diff, changeToRangeEnd))
                    transformedRanges.append((needChangeRangeEnd, rightBorder))
                } else if needChangeRangeStart == rangeStart {
                    // this is wrong, we need to adjust here with difference
                    let diff
                    transformedRanges.append((rangeStart, rightBorder))
                } else {
                    // this scenario should be when the idRange is a subset of the neededRange
                }
            }
        }

        transformedRanges.sort {
            $0.1 < $1.0
        }
        return transformedRanges[0].0
    }
}
