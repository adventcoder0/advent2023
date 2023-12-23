import Algorithms

struct Day14: AdventDay {
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
        let grid: [[Character]] = entities.map { Array($0) }
        let rotated = transpose(grid: grid)
        return rotated.reduce(0) { sum, column in sum + rollBackSum(column: column) }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return "Not Implemented"
    }
}

extension Day14 {
    func transpose(grid: [[Character]]) -> [[Character]] {
        var value: [[Character]] = []
        for index in grid.first!.indices {
            value.append(grid.map { $0[index] })
        }
        return value
    }

    func rollBackSum(column: [Character]) -> Int {
        var sum = 0, index = 0, anchor = 0
        while index < column.count {
            if column[index] == "#" {
                index += 1
                anchor = index
                continue
            }
            if column[index] == "." {
                index += 1
                continue
            }
            let value = column.count - anchor
            sum += value
            index += 1
            anchor += 1
        }
        return sum
    }
}
