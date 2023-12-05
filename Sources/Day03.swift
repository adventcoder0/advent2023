import Algorithms

struct Day03: AdventDay {
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
        var previousLine = Array("")
        var previousWordRanges: [(Int, Int)] = []
        var previousSymbols: [Int] = []
        var validNumbers: [Int] = []

        // okay so hopefully this works:
        // find index of symbols
        // if previous numbers touch , add them to list
        // if current numbers touch, add them to list
        entities.forEach { rowString in
            var startIndex: Int? = nil
            var endIndex: Int? = nil
            var currentIndex = 0
            var currentWordRanges: [(Int, Int)] = []
            var currentSymbols: [Int] = []

            let line: [Character] = Array(rowString)

            // print("-----------start line--------------")
            // print(rowString)

            var lineNumber = 1
            line.forEach {
                let digit = Int(String($0))

                if digit != nil && startIndex == nil {
                    startIndex = currentIndex
                }
                if digit == nil && startIndex != nil {
                    endIndex = currentIndex - 1
                    if startIndex != nil && startIndex! != 0 && line[startIndex! - 1] != "." {
                        let number = Int(String(line[startIndex! ... endIndex!]))!
                        // print("added: \(number)")
                        validNumbers.append(number)
                    } else {
                        currentWordRanges.append((startIndex!, endIndex!))
                    }
                    startIndex = nil
                    endIndex = nil
                }

                if digit == nil && $0 != "." {
                    currentSymbols.append(currentIndex)
                    if currentIndex != 0 && line[currentIndex - 1].isWholeNumber {
                        let range = currentWordRanges.popLast()
                        if range != nil {
                            let number = Int(String(line[range!.0 ... range!.1]))!
                            // print("added: \(number)")
                            validNumbers.append(number)
                        }
                    }
                }

                currentIndex += 1
            }

            if lineNumber == 3 && !matchToTest(validNumbers) {
                // print("----------------------!!!!!!!!!!!!-----------------------")
                // print("----------------------!!!!!!!!!!!!-----------------------")
                // print("----------------------!!!!!!!!!!!!-----------------------")
                // print("-----Does not match at \(lineNumber)")
                // print("-----Actual:")
                // print(validNumbers)
                // print("-----Expected:")
                // print(getTestList())
                // print("----------------------!!!!!!!!!!!!-----------------------")
                // print("----------------------!!!!!!!!!!!!-----------------------")
                // print("----------------------!!!!!!!!!!!!-----------------------")
            }
            lineNumber += 1
            //
            // // check with previous line to see it has any numbers that touch symbols on the current line
            if !previousLine.isEmpty {
                while !previousWordRanges.isEmpty {
                    let range = previousWordRanges.removeFirst()

                    if !currentSymbols.isEmpty {
                        let from = range.0 != 0 ? range.0 - 1 : range.0
                        let through = range.1 < line.count - 1 ? range.1 + 1 : range.1
                        // print("from: \(from)")
                        // print("through: \(through)")

                        var keep = true
                        currentSymbols.forEach {
                            if !keep {
                                return
                            }
                            if from <= $0 && through >= $0 {
                                keep = false
                                let number = Int(String(previousLine[range.0 ... range.1]))
                                // print("added: \(number!)")
                                validNumbers.append(number!)
                            }
                        }
                    }
                }
            }
            // print("check1 ----------")
            // print("CurrentSymbols : \(currentSymbols)")
            // print("CurrentRanges: \(currentWordRanges)")
            // print("PreviousSymbols: \(previousSymbols)")
            // print("PreviousRanges: \(previousWordRanges)")
            // print("Valid Numbers: \(validNumbers)")
            // print("check1 end ----------")

            // check current line to see it has any numbers that touch symbols from the previous previousLine
            var keepRanges: [(Int, Int)] = []
            while !currentWordRanges.isEmpty {
                let range = currentWordRanges.removeFirst()
                var keep = true
                if !previousSymbols.isEmpty {
                    let from = range.0 != 0 ? range.0 - 1 : range.0
                    let through = range.1 < line.count - 1 ? range.1 + 1 : range.1
                    previousSymbols.forEach {
                        if !keep {
                            return
                        }
                        if from <= $0 && through >= $0 {
                            keep = false
                            let number = Int(String(line[range.0 ... range.1]))
                            validNumbers.append(number!)
                            // print("added: \(number!)")
                        }
                    }
                }
                if keep {
                    keepRanges.append(range)
                }
            }
            !keepRanges.isEmpty ? currentWordRanges = keepRanges : nil

            // print("CurrentSymbols : \(currentSymbols)")
            // print("CurrentRanges: \(currentWordRanges)")
            // print("PreviousSymbols: \(previousSymbols)")
            // print("PreviousRanges: \(previousWordRanges)")
            // print("Valid Numbers: \(validNumbers)")

            previousLine = line
            previousWordRanges = currentWordRanges
            previousSymbols = currentSymbols
            // print(" set -----------------------------")
            // print("CurrentSymbols : \(currentSymbols)")
            // print("CurrentRanges: \(currentWordRanges)")
            // print("PreviousSymbols: \(previousSymbols)")
            // print("PreviousRanges: \(previousWordRanges)")
            // print("Valid Numbers: \(validNumbers)")
            // print("---------end line--------------------")
        }

        func getTestList() -> [Int] {
            return [954, 52, 806, 217, 664, 677, 459, 687, 398, 548, 495, 983, 282, 248, 409, 165]
        }

        func matchToTest(_ actual: [Int]) -> Bool {
            return actual == getTestList()
        }

        return validNumbers.reduce(0,+)
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        "Not implemented yet"
    }
}
