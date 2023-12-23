import Algorithms

struct Day15: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    // Splits input data into its component parts and convert from string.
    var entities: [String] {
        data.split(separator: ",").map {
            String($0)
        }
    }

    // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        // the new line at the end got my answer wrong, we have to remove it
        let listCharArrays: [[Character]] = entities.map { Array($0).filter { $0 != "\n" } }
        let sum = listCharArrays.reduce(0) { sum, hashString in
            let stringHashed = hashString.reduce(0) { hashThis(initVal: $0, letter: $1) }
            // print("hash after string : \(stringHashed)")
            return sum + stringHashed
        }
        return sum
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return "NOt Impl"
    }
}

extension Day15 {
    func hashThis(initVal: Int, letter: Character) -> Int {
        // print("character: \(letter)")
        let myass = Int(letter.asciiValue!)
        var hashVal = initVal + myass
        hashVal = hashVal * 17
        hashVal = hashVal % 256
        // print("Hashed: \(hashVal)")
        return hashVal
    }
}
