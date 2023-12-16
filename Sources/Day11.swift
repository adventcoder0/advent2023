import Algorithms
import Foundation

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
        let galaxyList = findGalaxies(grid: grid)
        var sum = 0
        var diffList: [Int] = []
        for i in 0 ..< galaxyList.count {
            for j in i ..< galaxyList.count {
                let point1 = galaxyList[i]
                let point2 = galaxyList[j]
                let x = point2.0 - point1.0
                let y = point2.1 - point1.1
                diffList.append(abs(x) + abs(y))
                sum += abs(x) + abs(y)
            }
        }
        // print(diffList)
        return sum
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let grid: [[Character]] = entities.map { Array($0) }
        // let (occupiedRows, occupiedColumns) = findOccupied(grid: grid)
        // expandGrid(grid: &grid, occupiedRows: occupiedRows, occupiedColumns: occupiedColumns)
        // print(gridToString(grid: grid))
        // print("--------------------")
        let a = findSumDistances(grid: grid, multiplier: 10)
        let b = findSumDistances(grid: grid, multiplier: 100)
        let c = findSumDistances(grid: grid, multiplier: 2)
        let d = findSumDistances(grid: grid, multiplier: 1_000_000)
        return (a, b, c, d)
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
        let mult = 1
        for i in stride(from: grid.count - 1, through: 0, by: -1) {
            if !occupiedRows.contains(i) {
                for _ in 1 ... mult {
                    grid.insert(Array(repeatElement(".", count: grid[0].count)), at: i + 1)
                }
            }
        }
        for i in stride(from: grid[0].count - 1, through: 0, by: -1) {
            if !occupiedColumns.contains(i) {
                for j in 0 ..< grid.count {
                    for _ in 1 ... mult {
                        grid[j].insert(".", at: i + 1)
                    }
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
        var i = 0
        for row in grid {
            if i == grid.count - 1 {
                retString += String(row)

            } else {
                retString += String(row) + "\n"
            }
            i += 1
        }
        return retString
    }

    func findGalaxies(grid: [[Character]]) -> [(Int, Int)] {
        var galaxyList: [(Int, Int)] = []
        for i in 0 ..< grid.count {
            for j in 0 ..< grid[0].count {
                if grid[i][j] == "#" {
                    galaxyList.append((i, j))
                }
            }
        }
        return galaxyList
    }

    func findSumDistances(grid: [[Character]], multiplier: Int) -> Int {
        let (occupiedRows, occupiedColumns) = findOccupied(grid: grid)
        let expandRows = (0 ..< grid.count).filter { !occupiedRows.contains($0) }
        let expandColumns = (0 ..< grid[0].count).filter { !occupiedColumns.contains($0) }
        let galaxyList = findGalaxies(grid: grid)
        var diffList: [Int] = []
        var sum = 0
        for i in 0 ..< galaxyList.count {
            for j in i ..< galaxyList.count {
                let point1 = galaxyList[i]
                let point2 = galaxyList[j]
                let x: Int = point2.0 - point1.0
                let y: Int = point2.1 - point1.1
                let debug = false
                // if point1 == (0, 3) && point2 == (1, 7) || (point1 == (0, 3) && point2 == (2, 0)) {
                //     debug = true
                // }
                // if debug {
                //     print("For y cross")
                // }
                let yCross: Int = numCrosses(index1: point1.1, index2: point2.1, occupiedLines: expandColumns, debug: debug)
                // if debug {
                //     print("For x cross")
                // }
                let xCross: Int = numCrosses(index1: point1.0, index2: point2.0, occupiedLines: expandRows, debug: debug)
                // if yCross > 0 {
                //     y += (multiplier * yCross)
                // }
                // if xCross > 0 {
                //     x += (multiplier * xCross)
                // }
                // if debug {
                //     print("HERE, what to add")
                //     print((multiplier * xCross) + (multiplier * yCross))
                //     print("xcross: \(xCross)")
                //     print("ycross: \(yCross)")
                //     print("x diff: \(x)")
                //     print("y diff: \(y)")
                //     print("rows: \(expandRows)")
                //     print("columns: \(expandColumns)")
                //     print("now add it: \(abs(x) + abs(y) + (multiplier * xCross) + (multiplier * yCross))")
                // }
                let extraX: Int = multiplier * xCross
                let extraY: Int = multiplier * yCross
                let distance: Int = abs(x) + abs(y) + extraX + extraY - xCross - yCross
                diffList.append(distance)
                sum += distance
            }
        }
        // print(diffList)
        // print("---------------")
        return sum
    }

    func numCrosses(index1: Int, index2: Int, occupiedLines: [Int], debug: Bool) -> Int {
        if debug {
            print("Args: \(index1), \(index2), \(occupiedLines)")
        }
        let min = min(index1, index2)
        let max = min == index1 ? index2 : index1
        if debug {
            print("min: \(min)")
            print("max: \(max)")
        }
        var count = 0
        for line in occupiedLines {
            if min < line && max > line {
                if debug {
                    print("countshould go up")
                }
                count += 1
            }
            if max < line {
                if debug {
                    print("max :\(max) is less than \(line)")
                }
                break
            }
        }
        return count
    }
}
