import Algorithms

struct Day02: AdventDay {
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
        let elfRules = Rules(red: 12, green: 13, blue: 14)
        var id = 0
        return entities.reduce(0) { sum, line in
            id += 1
            return isPossible(line, elfRules) ? sum + id : sum
        }
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        let elfRules = Rules(red: 12, green: 13, blue: 14)
        return entities.reduce(0) { sum, line in
            getPower(line, elfRules) + sum
        }
    }

    func getPower(_ line: String, _ elfRules: Rules) -> Int {
        let setText = line.split(separator: ":").last?.split(separator: ";")
        let arrayGameSet = setText?.map {
            text -> GameSet in
            let colorsText = text.split(separator: ",")
            var newGameSet = GameSet(constraint: elfRules)
            colorsText.forEach {
                let colorValues = $0.split(separator: " ")
                let value = Int(colorValues.first!)
                switch colorValues.last! {
                case "red":
                    newGameSet.red = value
                case "green":
                    newGameSet.green = value
                case "blue":
                    newGameSet.blue = value
                default:
                    // unexpected
                    break
                }
            }
            return newGameSet
        }
        let myGame = Game(sets: arrayGameSet!)
        return myGame.power()
    }

    func isPossible(_ line: String, _ elfRules: Rules) -> Bool {
        let setText = line.split(separator: ":").last?.split(separator: ";")
        let arrayGameSet = setText?.map {
            text -> GameSet in
            let colorsText = text.split(separator: ",")
            var newGameSet = GameSet(constraint: elfRules)
            colorsText.forEach {
                let colorValues = $0.split(separator: " ")
                let value = Int(colorValues.first!)
                switch colorValues.last! {
                case "red":
                    newGameSet.red = value
                case "green":
                    newGameSet.green = value
                case "blue":
                    newGameSet.blue = value
                default:
                    // unexpected
                    break
                }
            }
            return newGameSet
        }
        let myGame = Game(sets: arrayGameSet!)
        return myGame.isValid()
    }

    func validValues(_: String) -> Bool { return true }

    struct Game {
        var sets: [GameSet]

        func isValid() -> Bool {
            return sets.filter {
                !$0.isValid()
            }.isEmpty
        }

        func power() -> Int {
            var redMax = 0
            var greenMax = 0
            var blueMax = 0

            sets.forEach {
                if $0.red != nil && $0.red! > redMax {
                    redMax = $0.red!
                }
                if $0.blue != nil && $0.blue! > blueMax {
                    blueMax = $0.blue!
                }
                if $0.green != nil && $0.green! > greenMax {
                    greenMax = $0.green!
                }
            }

            return redMax * greenMax * blueMax
        }
    }

    struct GameSet {
        var red: Int?
        var green: Int?
        var blue: Int?
        var constraint: Rules

        func isValid() -> Bool {
            if red != nil && red! > constraint.red {
                return false
            }

            if green != nil && green! > constraint.green {
                return false
            }

            if blue != nil && blue! > constraint.blue {
                return false
            }
            return true
        }
    }

    struct Rules {
        var red: Int
        var green: Int
        var blue: Int

        func getTotal() -> Int {
            return red + blue + green
        }
    }
}
