import Algorithms
import Collections
import Foundation
import Swift

struct Day16: AdventDay {
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
        var row = 0
        var column = 0
        let grid: [[Character]] = entities.map { Array($0) }
        var direction = "right"
        var seen: [String: String] = [:]
        while isValid(grid: grid, point: (row, column)) {
            let key = "\(row),\(column)"
            seen[key] = direction
            if grid[row][column] == "." {
                adjustPoint(direction: direction, row: &row, column: &column)
                continue
            }
            if grid[row][column] == "-" && (direction == "left" || direction == "right") {
                adjustPoint(direction: direction, row: &row, column: &column)
                continue
            }
            if grid[row][column] == "|" && (direction == "up" || direction == "down") {
                adjustPoint(direction: direction, row: &row, column: &column)
                continue
            }
            if grid[row][column] == "/" {
                direction = "up"
            }
        }
        // beware/becareful for loops in the beams, will cause infinite loop
        // how do we know it's a loop though?
        // if it's energized in the same direction?
        // can we make it simplier? for - or | , if it hits this twice, both time split, then this is "loop"
        // because the second beam will continue the same path
        // what about \ and / ? can two beams come from same direction? no? maybe test this to be sure
        return "not imp"
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return "not imp"
    }
}

extension Day16 {
    func checkDupAngle(seen: [String: String], point: String, direction: String) -> Bool {
        if seen[point] == direction {
            return true
        }
        return false
    }

    func isValid(grid: [[Character]], point: (Int, Int)) -> Bool {
        let x = point.0
        let y = point.1
        if x < 0 || x >= grid.count {
            return false
        }
        if y < 0 || y >= grid[0].count {
            return false
        }
        return true
    }

    func adjustPoint(direction: String, row: inout Int, column: inout Int) {
        switch direction {
        case "right":
            column += 1
        case "left":
            column -= 1
        case "up":
            row -= 1
        case "down":
            row += 1
        default:
            break
        }
    }
}
