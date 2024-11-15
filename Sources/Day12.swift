import Algorithms

struct Day12: AdventDay {
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
        let conditionRecords = entities
            .map { $0.split(separator: " ") }
            .map {
                [
                    $0[0]
                        .split(separator: ".")
                        .map { String($0) },
                    $0[1]
                        .split(separator: ",")
                        .map { String($0) },
                ]
            }
            .map { geMatchingSlices(conditionRecordSingle: $0) }
        print(conditionRecords)
        return "Not implemented yet"
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        return "Not implemented yet"
    }
}

extension Day12 {
    func geMatchingSlices(conditionRecordSingle: [[String]]) -> [([Character], [Int])] {
        let springs: [[Character]] = conditionRecordSingle[0].map { Array($0) }
        var amountList = conditionRecordSingle[1].map { Int($0)! }
        var index = 0
        return springs
            .map {
                let chunksize = $0.count
                var sum = 0
                var slice: [Int] = []
                while !amountList.isEmpty {
                    let nextAmount = amountList.first!
                    sum += nextAmount
                    if sum > chunksize {
                        break
                    }
                    // add one more for "." that goes in between
                    sum += 1
                    amountList.removeFirst()
                    slice.append(nextAmount)
                }
                return slice
            }
            .map {
                let pair = (springs[index], $0)
                index += 1
                return pair
            }
    }

    func possibly(conditionPair: ([Character], [Int])) -> Int {
        let springs = conditionPair.0
        var amounts = conditionPair.1
        var possiblies = 0
        var amountPointer = 0
        var springPointer = 0
        var size = amounts[amountPointer]
        var chunkEnd = size + springPointer
        // if chunkEnd >= springs.count || springs[chunkEnd] == "#" {
        //     goNext
        // } else {
        //     amountPointer += 1
        //     size = amountPointer
        // }
        return possiblies
    }
}
