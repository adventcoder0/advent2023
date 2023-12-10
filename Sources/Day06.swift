import Algorithms

struct Day06: AdventDay {
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
        let raceTimeLimits: [Int] = entities[0].split(separator: " ").dropFirst().map {
            Int(String($0))!
        }
        let raceDistanceRecords: [Int] = entities[1].split(separator: " ").dropFirst().map {
            Int(String($0))!
        }

        var product = 1
        for index in 0 ..< raceTimeLimits.count {
            let timelimit = raceTimeLimits[index]
            let margin = determineMargin(timelimit: timelimit, record: raceDistanceRecords[index])
            product = product * margin
            if product == 0 {
                // print("found 0 for index: \(index)")
                break
            }
        }
        return product
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        let timelimit = Int(entities[0].split(separator: " ").dropFirst().reduce("") {
            $0 + String($1)
        })!
        let record = Int(entities[1].split(separator: " ").dropFirst().reduce("") {
            $0 + String($1)
        })!
        return determineMargin(timelimit: timelimit, record: record)
    }

    func determineMargin(timelimit: Int, record: Int) -> Int {
        var hold = 0
        var max = 0
        var margin = 0
        // speed is proportional to hold
        while hold < timelimit {
            let distance: Int = (timelimit - hold) * hold

            // print("check at hold: \(hold), distance: \(distance), max: \(max)")
            if distance < record && distance < max {
                // we have peaked and are now no longer beating the distance
                // print("Peaked at hold: \(hold), distance: \(distance), max: \(max), margin: \(margin)")
                break
            }
            if distance > record {
                margin += 1
            }
            if distance > max {
                max = distance
            }
            hold += 1
        }
        if margin == 0 {
            // print("0 for timelimit: \(timelimit) and record: \(record)")
        }

        return margin
    }
}
