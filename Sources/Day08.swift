import Algorithms

struct Day08: AdventDay {
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
        let directions: [Character] = Array(entities[0])
        var nodeDict: [String: (String, String)] = [:]
        var currentList: [String] = []

        setNodeDict(nodeDict: &nodeDict, currentValues: &currentList, part: 1)
        var numSteps = 0
        findStepsToZ(part: 1, numSteps: &numSteps, directions: directions, nodeDict: nodeDict, current: &currentList[0])
        return numSteps
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let directions: [Character] = Array(entities[0])
        var nodeDict: [String: (String, String)] = [:]
        var currentList: [String] = []

        setNodeDict(nodeDict: &nodeDict, currentValues: &currentList, part: 2)
        var listSteps = Array(repeating: 0, count: currentList.count)
        for i in 0 ..< currentList.count {
            var numSteps = 0
            var current = currentList[i]
            findStepsToZ(part: 2, numSteps: &numSteps, directions: directions, nodeDict: nodeDict, current: &current)

            listSteps[i] = numSteps
        }
        let ans = listSteps.reduce(1) {
            findLCM(n1: $0, n2: $1)
        }
        // print(listSteps)
        // print(ans)
        return ans
    }
}

extension Day08 {
    func setNodeDict(nodeDict: inout [String: (String, String)], currentValues: inout [String], part: Int) {
        for line in 1 ..< entities.count {
            var splitEquals = entities[line].split(separator: "=")
            splitEquals[0].removeLast()
            let value = String(splitEquals[0])
            if line == 1, part == 1 {
                currentValues.append(value)
            }
            if part == 2, value.hasSuffix("A") {
                currentValues.append(value)
            }
            var splitSpace = splitEquals[1].split(separator: " ")
            splitSpace[0].removeLast()
            splitSpace[0].removeFirst()
            let left = String(splitSpace[0])
            splitSpace[1].removeLast()
            let right = String(splitSpace[1])
            nodeDict[value] = (left, right)
        }
    }

    func findStepsToZ(part: Int, numSteps: inout Int, directions: [Character], nodeDict: [String: (String, String)], current: inout String) {
        var found = false
        for i in 0 ..< directions.count {
            if current == "ZZZ", part == 1 {
                found = true
                break
            }
            if current.hasSuffix("Z"), part == 2 {
                found = true
                break
            }
            switch directions[i] {
            case "L":
                current = nodeDict[current]!.0
            default:
                current = nodeDict[current]!.1
            }
            numSteps += 1
        }

        if !found { findStepsToZ(part: part, numSteps: &numSteps, directions: directions, nodeDict: nodeDict, current: &current) }
    }
}

// Function to find gcd of two numbers
func findGCD(_ num1: Int, _ num2: Int) -> Int {
    var x = 0

    // Finding maximum number
    var y: Int = max(num1, num2)

    // Finding minimum number
    var z: Int = min(num1, num2)

    while z != 0 {
        x = y
        y = z
        z = x % y
    }
    return y
}

// Function to find lcm of two numbers
func findLCM(n1: Int, n2: Int) -> Int {
    return n1 * n2 / findGCD(n1, n2)
}
