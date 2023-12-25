import Algorithms
import Collections
import Foundation
import Swift

struct Day18: AdventDay {
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
        let instructionList: [[String]] = entities.map { $0.split(separator: " ").map { String($0) } }
        var gridBoundaries = Boundaries(leftMost: 0, rightMost: 0, topMost: 0, bottomMost: 0)
        var currentPoint = (0, 0)
        var pointList: [(Int, Int)] = []
        instructionList.forEach { instructionComponents in
            let direction = instructionComponents[0]
            let distance = Int(instructionComponents[1])!
            let color = instructionComponents[2]
            let newInstruction = InstructionSet(direction: direction, distance: distance, color: color)
            newInstruction.execute(currentPoint: &currentPoint, boundaries: &gridBoundaries)
            pointList.append(currentPoint)
        }
        var grid = makeGridFromBoundaries(boundaries: gridBoundaries)
        paintGrid(pointList: pointList, grid: &grid, boundaries: gridBoundaries)
        return grid.reduce(0) { $0 + numDigForLine(line: $1) }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return "Not implemented yet"
    }
}

extension Day18 {
    func makeGridFromBoundaries(boundaries: Boundaries) -> [[Character]] {
        let width = boundaries.rightMost - boundaries.leftMost
        let height = boundaries.bottomMost - boundaries.topMost
        let row: [Character] = Array(repeating: ".", count: width + 1)
        return Array(repeating: row, count: height + 1)
    }

    func paintGrid(pointList: [(Int, Int)], grid: inout [[Character]], boundaries: Boundaries) {
        let widthOffset = 0 - boundaries.leftMost
        let heightOffset = 0 - boundaries.topMost
        let startPoint = (heightOffset, widthOffset)
        let first = adjustPoint(point: pointList[0], widthOffset: widthOffset, heightOffset: heightOffset)
        drawLine(pointOne: startPoint, pointTwo: first, grid: &grid)
        for index in 0 ..< pointList.count - 1 {
            let lp = adjustPoint(point: pointList[index], widthOffset: widthOffset, heightOffset: heightOffset)
            let rp = adjustPoint(point: pointList[index + 1], widthOffset: widthOffset, heightOffset: heightOffset)
            drawLine(pointOne: lp, pointTwo: rp, grid: &grid)
        }
    }

    func adjustPoint(point: (Int, Int), widthOffset: Int, heightOffset: Int) -> (Int, Int) {
        return (point.0 + heightOffset, point.1 + widthOffset)
    }

    func drawLine(pointOne: (Int, Int), pointTwo: (Int, Int), grid: inout [[Character]]) {
        if pointOne.0 != pointTwo.0 {
            let diff = abs(pointOne.0 - pointTwo.0)
            let start = min(pointOne.0, pointTwo.0)
            for i in start ... start + diff {
                grid[i][pointOne.1] = "#"
            }
            return
        }
        let diff = abs(pointOne.1 - pointTwo.1)
        let start = min(pointOne.1, pointTwo.1)
        for i in start ... start + diff {
            grid[pointOne.0][i] = "#"
        }
    }

    func numDigForLine(line: [Character]) -> Int {
        return line.lastIndex(where: { $0 == "#" })! - line.firstIndex(where: { $0 == "#" })! + 1
    }
}

struct InstructionSet {
    let direction: String
    let distance: Int
    let color: String

    func execute(currentPoint: inout (Int, Int), boundaries: inout Boundaries) {
        switch direction {
        case "R":
            currentPoint = (currentPoint.0, currentPoint.1 + distance)
            boundaries.update(point: currentPoint)
        case "L":
            currentPoint = (currentPoint.0, currentPoint.1 - distance)
            boundaries.update(point: currentPoint)
        case "D":
            currentPoint = (currentPoint.0 + distance, currentPoint.1)
            boundaries.update(point: currentPoint)
        case "U":
            currentPoint = (currentPoint.0 - distance, currentPoint.1)
            boundaries.update(point: currentPoint)
        default:
            break
        }
    }
}

struct Boundaries {
    var leftMost: Int
    var rightMost: Int
    var topMost: Int
    var bottomMost: Int

    mutating func update(point: (Int, Int)) {
        topMost = point.0 < topMost ? point.0 : topMost
        bottomMost = point.0 > bottomMost ? point.0 : bottomMost
        leftMost = point.1 < leftMost ? point.1 : leftMost
        rightMost = point.1 > rightMost ? point.1 : rightMost
    }
}
