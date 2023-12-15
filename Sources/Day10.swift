import Algorithms

struct Day10: AdventDay {
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
        var grid: [[Character]] = []
        grid = entities.map { Array($0) }
        var startingPos = (0, 0)
        for i in 0 ..< grid.count {
            for j in 0 ..< grid[0].count {
                if grid[i][j] == "S" {
                    startingPos = (i, j)
                }
            }
        }
        var dir = ["up", "down", "left", "right"].filter { validPosition(pos: startingPos, direction: $0, grid: grid) }.first!
        var nextPipe = getNextPipe(current: startingPos, direction: dir)
        var loop = [startingPos, nextPipe]
        var prev = reverseDirection(direction: dir)
        var current = nextPipe
        // print("before pipe run: \(loop), \(prev)")
        while current != startingPos {
            dir = getNexDirection(grid: grid, pos: current, previous: prev)
            // print("next dir: \(dir)")
            if dir == "" {
                break
            }
            nextPipe = getNextPipe(current: current, direction: dir)
            if startingPos == nextPipe {
                break
            }
            loop.append(nextPipe)
            prev = reverseDirection(direction: dir)
            current = nextPipe
        }
        // print(loop.count)
        // print(loop)
        // printOutLoopInGrid(loop: loop, grid: grid)
        return loop.count / 2
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        var grid: [[Character]] = []
        grid = entities.map { Array($0) }
        var startingPos = (0, 0)
        for i in 0 ..< grid.count {
            for j in 0 ..< grid[0].count {
                if grid[i][j] == "S" {
                    startingPos = (i, j)
                }
            }
        }
        var dir = ["up", "down", "left", "right"].filter { validPosition(pos: startingPos, direction: $0, grid: grid) }.first!
        var nextPipe = getNextPipe(current: startingPos, direction: dir)
        var loop = [startingPos, nextPipe]
        var prev = reverseDirection(direction: dir)
        var current = nextPipe
        while current != startingPos {
            dir = getNexDirection(grid: grid, pos: current, previous: prev)
            if dir == "" {
                // print("nodir")
                break
            }
            nextPipe = getNextPipe(current: current, direction: dir)
            if startingPos == nextPipe {
                // print("stop because starting pos")
                break
            }
            // print(grid[nextPipe.0][nextPipe.1])
            loop.append(nextPipe)
            prev = reverseDirection(direction: dir)
            current = nextPipe
        }
        // print("-----before---------------------")
        var editedGrid = addDotsAndChangeS(loop: loop, startingPos: startingPos, grid: grid)
        // editedGrid = addSpaces(grid: editedGrid)
        // for row in editedGrid {
        //     print(String(row))
        // }
        // var seen: [(Int, Int)] = []
        // fill(grid: &editedGrid, pos: (0, 0), seen: &seen)
        // print("-----after fill---------------------")
        // for row in editedGrid {
        //     print(String(row))
        // }
        return countDotsInLoop(grid: editedGrid)
        // return "Part 2 not done"
    }
}

extension Day10 {
    func extendLoop(current: (Int, Int), previous: String, loop: inout [(Int, Int)], grid: [[Character]]) {
        let dir = getNexDirection(grid: grid, pos: current, previous: previous)
        // print("next dir: \(dir)")
        if dir == "" {
            return
        }
        let nextPipe = getNextPipe(current: current, direction: dir)
        if loop.first! == nextPipe {
            return
        }
        loop.append(nextPipe)
        let newPrev = reverseDirection(direction: dir)
        extendLoop(current: nextPipe, previous: newPrev, loop: &loop, grid: grid)
    }

    func getNextPipe(current: (Int, Int), direction: String) -> (Int, Int) {
        switch direction {
        case "up":
            return (current.0 - 1, current.1)
        case "down":
            return (current.0 + 1, current.1)
        case "left":
            return (current.0, current.1 - 1)
        case "right":
            return (current.0, current.1 + 1)
        default:
            break
        }
        return current
    }

    func getNexDirection(grid: [[Character]], pos: (Int, Int), previous: String) -> String {
        if pos.0 < 0 || pos.1 < 0 {
            // print("lessthan0")
            return ""
        }
        if pos.0 >= grid.count || pos.1 >= grid[0].count {
            // print("greaterthanarray")
            return ""
        }
        switch grid[pos.0][pos.1] {
        case "|":
            return previous == "up" ? "down" : "up"
        case "-":
            return previous == "left" ? "right" : "left"
        case "L":
            return previous == "up" ? "right" : "up"
        case "J":
            return previous == "up" ? "left" : "up"
        case "7":
            return previous == "left" ? "down" : "left"
        case "F":
            return previous == "right" ? "down" : "right"
        default:
            break
        }
        return ""
    }

    func validPosition(pos: (Int, Int), direction: String, grid: [[Character]]) -> Bool {
        switch direction {
        case "up":
            if pos.0 != 0 && ["|", "7", "F"].contains(grid[pos.0 - 1][pos.1]) { return true }
        case "down":
            if pos.0 != grid.count - 1 && ["|", "J", "L"].contains(grid[pos.0 + 1][pos.1]) { return true }
        case "left":
            if pos.1 != 0 && ["-", "F", "L"].contains(grid[pos.0][pos.1 - 1]) { return true }
        case "right":
            if pos.1 != grid[0].count && ["-", "7", "J"].contains(grid[pos.0][pos.1 + 1]) { return true }
        default:
            break
        }
        return false
    }

    func reverseDirection(direction: String) -> String {
        switch direction {
        case "up":
            return "down"
        case "down":
            return "up"
        case "left":
            return "right"
        case "right":
            return "left"
        default:
            break
        }
        return ""
    }

    func printOutLoopInGrid(loop: [(Int, Int)], grid: [[Character]]) {
        var copy = grid
        for i in 0 ..< grid.count {
            for j in 0 ..< grid[0].count {
                if !loop.contains(where: { pos in pos == (i, j) }) {
                    copy[i][j] = "."
                }
            }
        }
        for j in copy {
            print(j)
        }
    }

    func addDotsAndChangeS(loop: [(Int, Int)], startingPos: (Int, Int), grid: [[Character]]) -> [[Character]] {
        var copy = grid
        for i in 0 ..< grid.count {
            for j in 0 ..< grid[0].count {
                if !loop.contains(where: { pos in pos == (i, j) }) {
                    copy[i][j] = "."
                }
            }
        }
        let dir = ["up", "down", "left", "right"].filter { validPosition(pos: startingPos, direction: $0, grid: grid) }
        switch dir {
        case ["up", "down"]:
            copy[startingPos.0][startingPos.1] = "|"
        case ["left", "right"]:
            copy[startingPos.0][startingPos.1] = "-"
        case ["up", "left"]:
            copy[startingPos.0][startingPos.1] = "J"
        case ["up", "right"]:
            copy[startingPos.0][startingPos.1] = "L"
        case ["down", "left"]:
            copy[startingPos.0][startingPos.1] = "7"
        case ["down", "right"]:
            copy[startingPos.0][startingPos.1] = "F"
        default:
            break
        }
        return copy
    }

    func addSpaces(grid: [[Character]]) -> [[Character]] {
        var newGrid = grid
        for i in stride(from: newGrid.count - 1, through: 0, by: -1) {
            // print("i: \(i)")
            var newRow: [Character] = []
            for j in stride(from: newGrid[i].count - 1, through: 0, by: -1) {
                // print("j: \(j)")
                switch newGrid[i][j] {
                case ".", "|", "7", "J":
                    newGrid[i].insert("#", at: j + 1)
                case "F", "L", "-":
                    newGrid[i].insert("-", at: j + 1)
                default:
                    break
                }
            }
            // print("edited row: \(String(newGrid[i]))")
            for j in 0 ..< newGrid[i].count {
                switch newGrid[i][j] {
                case ".", "-", "L", "J", "#":
                    newRow.append("#")
                case "F", "7", "|":
                    newRow.append("|")
                default:
                    break
                }
            }
            // print("new row: \(String(newRow))")
            newGrid.insert(newRow, at: i + 1)
            // add top and left
            if i == 0 {
                for j in 0 ..< newGrid.count {
                    newGrid[j].insert("#", at: 0)
                }
                let top: [Character] = Array(repeating: "#", count: newGrid[i].count)
                newGrid.insert(top, at: 0)
            }
        }
        return newGrid
    }

    func countDotsInLoop(grid: [[Character]]) -> Int {
        // L - J in, out
        // F - 7 in, out
        // | - F, | - 7, | -L , | - J, | - | ,  in out
        // if J , next one will not be 7, vice versa
        // if L, next one will not be F, vice versa
        var count = 0
        for row in grid {
            // print(String(row))
            var lastBoundary: Character = "#"
            var inBoundary = false
            for point in row {
                if (!inBoundary && point == ".") || point == "-" {
                    continue
                }
                if inBoundary, point == "." {
                    // print("counted")
                    count += 1
                    continue
                }
                var skip = false
                if (lastBoundary == "L" && point == "F") || lastBoundary == "F" && point == "L" {
                    print("ERROR L F")
                    skip = true
                }
                if (lastBoundary == "J" && point == "7") || lastBoundary == "7" && point == "J" {
                    print("ERROR J 7 ")
                    skip = true
                }
                if lastBoundary == "L" && point == "7" {
                    skip = true
                }
                if lastBoundary == "F" && point == "J" {
                    skip = true
                }
                lastBoundary = point
                if skip {
                    // print("point: \(point), is \(inBoundary)")
                    continue
                }
                inBoundary = inBoundary ? false : true
                // print("point: \(point), is \(inBoundary)")
            }
        }
        return count
    }

    func setPound(grid: inout [[Character]], pos: (Int, Int)) -> Bool {
        if grid[pos.0][pos.1] != "." && grid[pos.0][pos.1] != "#" {
            return false
        }
        if grid[pos.0][pos.1] == "." {
            grid[pos.0][pos.1] = "#"
        }
        return true
    }

    func countSpaces(grid: [[Character]]) -> Int {
        var count = 0
        for row in grid {
            for j in row {
                if j == "." {
                    count += 1
                }
            }
        }
        return count
    }
}
