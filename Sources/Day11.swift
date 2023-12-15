import Algorithms

struct Day11: AdventDay {
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
        var grid: [[Character]] = entities.map { Array($0) }
        let (occupiedRows, occupiedColumns) = findOccupied(grid: grid)
        expandGrid(grid: &grid, occupiedRows: occupiedRows, occupiedColumns: occupiedColumns)
        // printGrid(grid: grid)
        // print(gridToString(grid: grid))

        return "Not Implemented"
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        "Part 2 not done"
    }
}

extension Day11 {
    func printGrid(grid: [[Character]]) {
        for row in grid {
            print(row)
        }
    }

    func findOccupied(grid: [[Character]]) -> (Set<Int>, Set<Int>) {
        var occupiedColumns: Set<Int> = Set()
        var occupiedRows: Set<Int> = Set()
        for i in 0 ..< grid.count {
            for j in 0 ..< grid[0].count {
                if grid[i][j] == "#" {
                    occupiedRows.insert(i)
                    occupiedColumns.insert(j)
                }
            }
        }
        return (occupiedRows, occupiedColumns)
    }

    func expandGrid(grid: inout [[Character]], occupiedRows: Set<Int>, occupiedColumns: Set<Int>) {
        for i in stride(from: grid.count - 1, through: 0, by: -1) {
            if !occupiedRows.contains(i) {
                grid.insert(Array(repeatElement(".", count: grid[0].count)), at: i + 1)
            }
        }
        for i in stride(from: grid[0].count - 1, through: 0, by: -1) {
            if !occupiedColumns.contains(i) {
                for j in 0 ..< grid.count {
                    grid[j].insert(".", at: i + 1)
                }
            }
        }
    }

    func expandedString() -> String {
        var grid: [[Character]] = entities.map { Array($0) }
        let (occupiedRows, occupiedColumns) = findOccupied(grid: grid)
        expandGrid(grid: &grid, occupiedRows: occupiedRows, occupiedColumns: occupiedColumns)
        return gridToString(grid: grid)
    }

    func gridToString(grid: [[Character]]) -> String {
        var retString = ""
        for row in grid {
            retString += String(row) + "\n"
        }
        return retString
    }
}
