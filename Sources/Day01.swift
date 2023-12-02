import Algorithms

struct Day01: AdventDay {
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
        let digitList: [Int] = entities.map(changeToDigits)
        return digitList.reduce(0,+)
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        // will probably have to use sliding window to find matches.
        //
        return 0
    }

    func changeToDigits(_ calString: String) -> Int {
        var last: Int?
        var total: Int = calString.reduce(0) { total, value in
            let number = Int(String(value))
            if number != nil {
                last = number
            }
            return total == 0 && number != nil ? number! * 10 : total
        }
        if last != nil {
            total = total + last!
        }
        return total
    }
}
