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
        let digitList: [Int] = entities.map(changeToDigits)
        return digitList.reduce(0,+)
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        let digitList: [Int] = entities.map(changeToDigitsPart2)
        return digitList.reduce(0,+)
    }

    func changeToDigits(_ calString: String) -> Int {
        var last: Int?
        var total: Int = calString.reduce(0) { total, value in
            let number = Int(String(value))
            if number == nil {
                return total
            }
            last = number
            return total == 0 && number != nil ? number! * 10 : total
        }
        if last != nil {
            total = total + last!
        }
        return total
    }

    func changeToDigitsPart2(_ calString: String) -> Int {
        var last: Int?
        var index = calString.startIndex
        var total = 0
        while index < calString.endIndex {
            let numberFromDigit = Int(String(calString[index]))
            let number = numberFromDigit == nil ? checkForNumWord(calString, index) : numberFromDigit

            if number == nil {
                calString.formIndex(after: &index)
                continue
            }

            last = number
            total == 0 ? total = number! * 10 : nil

            if numberFromDigit == nil {
                incrementIndexByWordLength(calString, number!, &index)
            } else {
                calString.formIndex(after: &index)
            }
        }
        if last != nil {
            total += last!
        }
        return total
    }

    func checkForNumWord(_ calString: String, _ index: String.Index) -> Int? {
        var offset = 3
        var number: Int?
        while offset < 6 {
            let endex = calString.index(index, offsetBy: offset, limitedBy: calString.endIndex)
            if endex == nil {
                break
            }

            let substring = String(calString[index ..< endex!])
            switch offset {
            case 3:
                number = threeLetterDigit(substring)
            case 4:
                number = fourLetterDigit(substring)
            case 5:
                number = fiveLetterDigit(substring)
            default:
                // Unexpected; should be a throws in real life
                break
            }

            if number != nil {
                break
            }
            offset += 1
        }
        return number
    }

    func incrementIndexByWordLength(_ line: String, _ wordValue: Int, _ index: inout String.Index) {
        switch wordValue {
        case 1, 2, 6:
            line.formIndex(&index, offsetBy: 2)
        case 4, 5, 9:
            line.formIndex(&index, offsetBy: 3)
        case 3, 7, 8:
            line.formIndex(&index, offsetBy: 4)
        default:
            // Unexpected
            break
        }
    }

    func threeLetterDigit(_ substring: String) -> Int? {
        switch substring {
        case "one":
            return 1
        case "two":
            return 2
        case "six":
            return 6
        default:
            return nil
        }
    }

    func fourLetterDigit(_ substring: String) -> Int? {
        switch substring {
        case "four":
            return 4
        case "five":
            return 5
        case "nine":
            return 9
        default:
            return nil
        }
    }

    func fiveLetterDigit(_ substring: String) -> Int? {
        switch substring {
        case "three":
            return 3
        case "seven":
            return 7
        case "eight":
            return 8
        default:
            return nil
        }
    }
}
