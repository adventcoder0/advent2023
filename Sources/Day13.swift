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
        return entities.reduce(0) { sum, patternBlock in sum + findValueFromReflection(pattern: patternBlock) }
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return "Not implemented"
    }
}

extension Day13 {
    func findValueFromReflection(pattern: String) -> Int {
        let grid: [[Character]] = pattern.split(separator: "\n").map { Array($0) }
        if let rowReflection = findReflectionWithStacks(grid: grid) {
            return rowReflection * 100
        }
        let transposedGrid = transpose(grid: grid)
        if let columnReflection = findReflectionWithStacks(grid: transposedGrid) {
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
            // print("begin iteration, leftstack: \(leftStack)")
            let previous = leftStack.popLast()
            if previous == nil {
                // print("left stack should be empty: \(index)")
                leftStack.append(grid[index])
                continue
            }
            if previous != grid[index] {
                // print("continue, did not match at: \(index)")
                leftStack.append(previous!)
                leftStack.append(grid[index])
                continue
            }
            tempStack.append(grid[index])
            tempStack.append(previous!)
            // print("matched with previous, lets check for reflection: \(index)")
            var check = index + 1
            var isReflection = true
            while check < grid.count {
                // print("checking at: \(check)")
                let leftOne = leftStack.popLast()
                if leftOne == nil {
                    // print("reached the end of left side")
                    // left stack is empty , we have reached the end of the left side
                    break
                }
                tempStack.append(leftOne!)
                let rightOne = grid[check]
                if leftOne! != rightOne {
                    // print("we did not match for reflection: \(check)")
                    isReflection = false
                    break
                }
                check += 1
            }
            if isReflection {
                // print("finished checking for reflection and returning true for index: \(index)")
                return index
            }
            // print("need to reset left stack, before: \(leftStack)")
            while !tempStack.isEmpty {
                let left = tempStack.removeLast()
                leftStack.append(left)
            }
            // print("after reset: \(leftStack)")
            // print("end of one iteration -------------------------------------")
        }
        return nil
    }
}
