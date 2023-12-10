import Algorithms

struct Day09: AdventDay {
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
        let sequenceList = entities.map { $0.split(separator: " ").map { Int(String($0))! } }
        let total = sequenceList.reduce(0) { sum, sequence in
            let test = findNextNum(sequence)
            // print(test)
            return sum + test
        }
        // print(total)
        return total
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let sequenceList = entities.map { $0.split(separator: " ").map { Int(String($0))! } }
        let total = sequenceList.reduce(0) { sum, sequence in
            let test = findFirstNum(sequence)
            // print("first num for \(sequence) : \(test)")
            return sum + test
        }
        // print(total)
        return total
    }
}

extension Day09 {
    func findNextNum(_ sequence: [Int]) -> Int {
        var allZeroes = true
        var sequenceDiffs: [Int] = []
        for i in 0 ..< sequence.count - 1 {
            let diff = sequence[i + 1] - sequence[i]
            if diff != 0 { allZeroes = false }
            sequenceDiffs.append(diff)
        }
        if allZeroes { return sequence.last! }
        return sequence.last! + findNextNum(sequenceDiffs)
    }

    func findFirstNum(_ sequence: [Int]) -> Int {
        // print("given: \(sequence)")
        var allZeroes = true
        var sequenceDiffs: [Int] = []
        for i in 0 ..< sequence.count - 1 {
            let diff = sequence[i + 1] - sequence[i]
            if diff != 0 {
                allZeroes = false
            }
            sequenceDiffs.append(diff)
        }

        if allZeroes { return sequence.first! }
        // print("------------------")
        // print("---first---------------")
        // print(sequence.first!)
        // print("---nextseq---------------")
        // print(sequenceDiffs)
        // print("---num for next---------------")
        // print(findNextNum(sequenceDiffs))
        // print("------------------")
        return sequence.first! - findFirstNum(sequenceDiffs)
    }
}
