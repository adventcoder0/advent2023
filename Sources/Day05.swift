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
    func part2() throws -> Any {
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
        var transformedRanges: [(Int, Int)] = []
        var before: [(Int, Int)] = idRanges
        for lineNum in 1 ..< entities.count {
            // print("\(lineNum): \(entities[lineNum])")
            let words = entities[lineNum].split(separator: " ")

            if words[1] == "map:" {
                // print("----------newMap----------")
                idRanges.forEach {
                    transformedRanges.append($0)
                }
                transformedRanges.sort { $0.1 < $1.0 }
                let test1 = totalNumbers(ranges: transformedRanges)
                let test2 = totalNumbers(ranges: before)
                if test1 != test2 {
                    guard test1 == test2 else {
                        print("ERRRORRRRRR")
                        throw BadTransformError.DifferentCount(countBefore: test2, countAfter: test1, before: before, after: transformedRanges)
                    }
                }
                idRanges = transformedRanges
                before = idRanges
                transformedRanges = []
                // print(idRanges)
                // print("Starting out ---------")
                continue
            }

            let mapping = words.map {
                numString in
                Int(String(numString))!
            }

            let needChangeRangeStart = mapping[1]
            let needChangeRangeEnd = needChangeRangeStart + mapping[2]
            let changeToRangeStart = mapping[0]
            let changeToRangeEnd = changeToRangeStart + mapping[2]

            var indexToRemove: [Int] = []
            for index in 0 ..< idRanges.count {
                // print("needStart")
                // print(needChangeRangeStart)
                // print("needEnd")
                // print(needChangeRangeEnd)
                // print("changeStart")
                // print(changeToRangeStart)
                // print("changeEnd")
                // print(changeToRangeEnd)
                if needChangeRangeEnd <= idRanges[index].0 {
                    // the range that needs to be transformed is before the current range,
                    // the next ranges will be higher, so we can break here
                    // print("outside of range: \(idRanges[index])")
                    break
                }
                if idRanges[index].1 <= needChangeRangeStart {
                    // print("outside of range: \(idRanges[index])")
                    continue
                }

                // get overlaps
                // get union -> these are the values to change.
                // then we have to find possible right and left edges to keep the same
                let overlapStart = max(needChangeRangeStart, idRanges[index].0)
                let overlapEnd = min(needChangeRangeEnd, idRanges[index].1)
                // print("overlap range is : \(overlapStart) - \(overlapEnd)")

                var startRange: Int? = nil
                var endRange: Int? = nil
                // if idrange start is < overlapStart then it means we have left range
                if idRanges[index].0 < overlapStart {
                    let lsr = (idRanges[index].0, overlapStart)
                    // print("LeftSide range:  \(lsr)")
                    transformedRanges.append((idRanges[index].0, overlapStart))
                    startRange = changeToRangeStart
                }
                // if overlapEnd is < id range end then it means we have right range
                if overlapEnd < idRanges[index].1 {
                    let rsr = (overlapEnd, idRanges[index].1)
                    // print("rightside range:  \(rsr)")
                    transformedRanges.append((overlapEnd, idRanges[index].1))
                    endRange = changeToRangeEnd
                }
                // how to comput the numberchange?
                // left diff add/sub to needChangeRangeStart?
                // right diff add/sub to needChangeRangeEnd?
                if startRange == nil {
                    let diff = idRanges[index].0 - needChangeRangeStart
                    startRange = changeToRangeStart + diff
                }
                if endRange == nil {
                    let diff = needChangeRangeEnd - idRanges[index].1
                    endRange = changeToRangeEnd - diff
                }
                // print("affectedRange: \(overlapStart) -  \(overlapEnd)")

                let newRange = (startRange!, endRange!)
                // print("change to : \(newRange)")

                // print("Remove: \(index)")
                indexToRemove.append(index)
                transformedRanges.append((startRange!, endRange!))
            }

            // print("Transformed Ranges next line:")
            // print(transformedRanges)
            var fin = 0
            idRanges = idRanges.filter {
                _ in
                let b = !indexToRemove.contains(fin)
                fin += 1
                return b
            }
            // indexToRemove.forEach {
            //     if $0 < 0 || $0 >= idRanges.count {
            //         print("outof range: \($0)")
            //     } else {
            //         print("Remove at idex: \($0)")
            //         idRanges.remove(at: $0)
            //     }
            // }
        }

        idRanges.forEach {
            transformedRanges.append($0)
        }
        transformedRanges.sort {
            $0.1 < $1.0
        }
        // print("----end result------")
        // print(transformedRanges)
        return transformedRanges[0].0
    }

    func totalNumbers(ranges: [(Int, Int)]) -> Int {
        return ranges.reduce(0) {
            sum, pair in
            sum + (pair.1 - pair.0)
        }
    }
}

enum BadTransformError: Error {
    case DifferentCount(countBefore: Int, countAfter: Int, before: [(Int, Int)], after: [(Int, Int)])
}
