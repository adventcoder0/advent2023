import Algorithms

struct Day03: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [[Character]] {
        data.split(separator: "\n").map {
            Array($0)
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        var line = 0
        let symbolPoints: [(Int, Int)] = entities.flatMap { symbolIndexes(lineChars: $0, line: &line) }
        let numPoints: [(Int, Int)] = symbolPoints.flatMap { adjacentNumPoints(point: $0, grid: entities) }
        var grid = entities
        let numbers = extractNumbers(pointList: numPoints, grid: &grid, gears: false)
        return numbers.reduce(0) { $0 + $1 }
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        var line = 0
        let gearPoints: [(Int, Int)] = entities.flatMap { gearIndices(lineChars: $0, line: &line) }
        let numPoints: [[(Int, Int)]] = gearPoints.map { adjacentNumPoints(point: $0, grid: entities) }
        var grid = entities
        return numPoints
            .map { extractNumbers(pointList: $0, grid: &grid, gears: true) }
            .map { $0.reduce(1) { $0 * $1 }}
            .reduce(0) { $0 + $1 }
    }
}

extension Day03 {
    func symbolIndexes(lineChars: [Character], line: inout Int) -> [(Int, Int)] {
        var indexList: [(Int, Int)] = []
        for index in lineChars.indices {
            if lineChars[index] != ".", Int(String(lineChars[index])) == nil {
                indexList.append((line, index))
            }
        }
        line += 1
        return indexList
    }

    func gearIndices(lineChars: [Character], line: inout Int) -> [(Int, Int)] {
        var indexList: [(Int, Int)] = []
        for index in lineChars.indices {
            if lineChars[index] == "*" {
                indexList.append((line, index))
            }
        }
        line += 1
        return indexList
    }

    func adjacentNumPoints(point: (Int, Int), grid: [[Character]]) -> [(Int, Int)] {
        let neighbors: [(Int, Int)] = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        return neighbors
            .map { (point.0 + $0.0, point.1 + $0.1) }
            .filter { $0.0 >= 0 && $0.0 < grid.count && $0.1 >= 0 && $0.1 < grid[0].count }
            .filter { Int(String(grid[$0.0][$0.1])) != nil }
    }

    func extractNumbers(pointList: [(Int, Int)], grid: inout [[Character]], gears: Bool) -> [Int] {
        var numbers: [Int] = []
        for index in pointList.indices {
            let numIndex = pointList[index]
            var numChars: [Character] = []
            if grid[numIndex.0][numIndex.1] == "." {
                continue
            }
            numChars.append(grid[numIndex.0][numIndex.1])
            grid[numIndex.0][numIndex.1] = "."
            var left = numIndex.1 - 1
            var right = numIndex.1 + 1
            while left >= 0 {
                let leftChar = grid[numIndex.0][left]
                if Int(String(leftChar)) == nil {
                    break
                }
                numChars.insert(leftChar, at: 0)
                grid[numIndex.0][left] = "."
                left -= 1
            }
            while right < grid[0].count {
                let rightChar = grid[numIndex.0][right]
                if Int(String(rightChar)) == nil {
                    break
                }
                numChars.append(grid[numIndex.0][right])
                grid[numIndex.0][right] = "."
                right += 1
            }
            numbers.append(Int(String(numChars))!)
        }

        return gears && numbers.count == 1 ? [0] : numbers
    }
}
