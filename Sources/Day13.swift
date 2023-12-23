import Algorithms
import Collections
import Foundation
import Swift

struct Day13: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: "\n\n").map {
            String($0)
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        return entities.reduce(0) { sum, patternBlock in sum + findValueFromReflection(pattern: patternBlock, part: 1) }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        // print("part 2 ---------------------kjdlksjfkdsj")
        return entities.reduce(0) { sum, patternBlock in sum + findValueFromReflection(pattern: patternBlock, part: 2) }
    }
}

extension Day13 {
    func findValueFromReflection(pattern: String, part: Int) -> Int {
        let grid: [[Character]] = pattern.split(separator: "\n").map { Array($0) }
        // print("checking row")
        if let rowReflection = part == 2 ? findReflectionWithStacksPart2(grid: grid) : findReflectionWithStacks(grid: grid) {
            return rowReflection * 100
        }
        // print("checking column")
        let transposedGrid = transpose(grid: grid)
        if let columnReflection = part == 2 ? findReflectionWithStacksPart2(grid: transposedGrid) : findReflectionWithStacks(grid: transposedGrid) {
            return columnReflection
        }
        return 0
    }

    func transpose(grid: [[Character]]) -> [[Character]] {
        var value: [[Character]] = []
        for index in grid.first!.indices {
            value.append(grid.map { $0[index] })
        }
        return value
    }

    func findReflectionWithStacks(grid: [[Character]]) -> Int? {
        var leftStack: [[Character]] = []
        var tempStack: [[Character]] = []
        for index in grid.indices {
            let previous = leftStack.popLast()
            if previous == nil {
                leftStack.append(grid[index])
                continue
            }
            if previous != grid[index] {
                leftStack.append(previous!)
                leftStack.append(grid[index])
                continue
            }
            tempStack.append(grid[index])
            tempStack.append(previous!)
            var check = index + 1
            var isReflection = true
            while check < grid.count {
                let leftOne = leftStack.popLast()
                if leftOne == nil {
                    // left stack is empty , we have reached the end of the left side
                    break
                }
                tempStack.append(leftOne!)
                let rightOne = grid[check]
                if leftOne! == rightOne {
                    check += 1
                    continue
                }

                isReflection = false
                break
            }
            if isReflection {
                return index
            }
            while !tempStack.isEmpty {
                let left = tempStack.removeLast()
                leftStack.append(left)
            }
        }
        return nil
    }

    func matchesWithSmudge(rowOne: [Character], rowTwo: [Character]) -> Bool {
        var switched = false
        for index in rowOne.indices {
            if rowOne[index] == rowTwo[index] {
                continue
            }
            if switched {
                return false
            }
            switched = true
        }
        return true
    }

    func findReflectionWithStacksPart2(grid: [[Character]]) -> Int? {
        // print("new")
        var leftStack: [[Character]] = []
        var tempStack: [[Character]] = []
        for index in grid.indices {
            // print("iterate: \(index)")
            let previous = leftStack.popLast()
            if previous == nil {
                leftStack.append(grid[index])
                continue
            }
            let smudgeable = matchesWithSmudge(rowOne: previous!, rowTwo: grid[index])
            if smudgeable, previous! != grid[index], leftStack.isEmpty {
                // print("we smudged the first two, do not need to propagate, return index : \(index)")
                return index
            }
            if smudgeable, previous! != grid[index], index + 1 == grid.count {
                // print("we smudged the last two, do not need to propagate, return index : \(index)")
                return index
            }
            if previous! == grid[index], propagatesToEnd(grid: grid, index: index, leftStack: &leftStack, tempStack: &tempStack) {
                // print("found matching middle rows: \(index), smudged one of the propagated")
                return index
            }
            if !smudgeable {
                leftStack.append(previous!)
                leftStack.append(grid[index])
                continue
            }
            if propagatesToEnd(grid: grid, index: index, leftStack: &leftStack, tempStack: &tempStack) {
                return index
            }
            leftStack.append(previous!)
            leftStack.append(grid[index])
        }
        return nil
    }

    func propagatesToEnd(grid: [[Character]], index: Int, leftStack: inout [[Character]], tempStack: inout [[Character]]) -> Bool {
        var check = index + 1
        // print("check: \(check)")
        var isReflection = true
        var alreadySmudged = false
        while check < grid.count {
            let leftOne = leftStack.popLast()
            if leftOne == nil {
                break
            }
            tempStack.append(leftOne!)
            let rightOne = grid[check]
            if leftOne! == rightOne {
                check += 1
                continue
            }

            if alreadySmudged {
                isReflection = false
                break
            }
            let smudgeable = matchesWithSmudge(rowOne: leftOne!, rowTwo: rightOne)
            if smudgeable {
                // print("made a smudge")
                check += 1
                alreadySmudged = true
                continue
            }
            isReflection = false
            break
        }
        // print("did we smudge: \(alreadySmudged)")
        if isReflection && alreadySmudged {
            return true
        }
        while !tempStack.isEmpty {
            let left = tempStack.removeLast()
            leftStack.append(left)
        }
        return false
    }
}
