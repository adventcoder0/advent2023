import Algorithms

struct Day12: AdventDay {
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
        let sum = entities.reduce(0) { sum, row in
            let permutations = findPermutations(row: row)
            print("---------------------------------------------->")
            return sum + permutations
        }
        print(sum)
        return "Not implemented yet"
    }

    // Replace this with your solution for the last part of the day's challenge.
    func part2() -> Any {
        return "Not implemented yet"
    }
}

extension Day12 {
    func findPermutations(row: String) -> Int {
        let rowArray = row.split(separator: " ").map { String($0) }
        let layout: [[Character]] = rowArray[0].split(separator: ".").map { Array($0) }
        let sizeLayout: [Int] = rowArray[1].split(separator: ",").map { Int(String($0))! }
        var sizePointer = 0, previousSizePointer = 0
        var subchunks: [[Character]] = []
        let permutations = layout.map { chunk in
            // instead of subchunks, lets do sub range and lets do array/list of start index for next subchunk
            // this way we can print the permutations and see if it's correct
            // if all ####, then just 1 possibility
            // var yan = 0
            // dfs(chunk: chunk, sizeLayout: sizeLayout, permutations: &yan)
            let fitSize = getSizeThatFitsChunk(sizeLayout: sizeLayout, chunk: chunk, sizePointer: &sizePointer)
            var choices = 0
            if fitSize == chunk.count {
                choices = 1
            } else {
                choices = (chunk.count - fitSize) + 1
            }
            let yan = getConstraintsForFirstSize(chunk: chunk, sizeListToFit: sizeLayout)
            previousSizePointer = sizePointer
            print("choices for chunk: \(choices)")
            print("~~~~~~~~~~~~~~~~~~~~~~~")
            return choices

            // start from previousSizePointer
            // get size from previousSizePointer
            // from previousSizePointer <= i < previousSizePointer + size
            // this is not right...
            // break off end of chunk, from righ side. the left side is what is possible if all of it is ???
            // check left chunk for #, this will be a limiter/constraint on where the first size/subchunk can be
        }
        let total = permutations.reduce(1) { $0 * $1 }
        print("choices for this line: \(total)")
        return total
    }

    func getSizeThatFitsChunk(sizeLayout: [Int], chunk: [Character], sizePointer: inout Int) -> Int {
        var fitSize = 0
        while sizePointer < sizeLayout.count {
            var newTotal = fitSize + sizeLayout[sizePointer]
            if fitSize != 0 {
                newTotal += 1
            }
            if newTotal > chunk.count {
                break
            }
            fitSize = newTotal
            sizePointer += 1
        }
        print("chunkSize: \(chunk.count)")
        print("fitSize: \(fitSize)")
        print("sizePointer: \(sizePointer)")
        return fitSize
    }

    func dfs(chunk: [Character], sizeLayout: [Int], permutations: inout Int) {
        if chunk.isEmpty {
            return
        }
        if chunk.count == sizeLayout[0] {
            permutations += 1
            return
        }

        let constraints = getConstraintsForFirstSize(chunk: chunk, sizeListToFit: sizeLayout)
        print("constraints: \(constraints.0) , \(constraints.1)")
        // var newSizeLayout = sizeLayout
        // newSizeLayout.removeFirst()
        // increase permutations by our default calculation
        // for i in newLeftContraintsList {
        //     dfs(chunk[i ..< chunk.count], newSizeLayout, permutations)
        // }
    }

    func getConstraintsForFirstSize(chunk: [Character], sizeListToFit: [Int]) -> (Int, Int) {
        var found = false
        var leftPoint = 0, rightPoint = 0
        for i in 0 ..< chunk.count {
            rightPoint = i
            if found, chunk[i] != "#" {
                break
            }
            if chunk[i] == "#" {
                leftPoint = i
                found = true
                break
            }
        }
        let firstSize = sizeListToFit[0]
        let remainderSize = sizeListToFit.count == 1 ? 0 : sizeListToFit[1 ..< sizeListToFit.count].reduce(0) { $0 + $1 }
        if leftPoint >= chunk.count - remainderSize || rightPoint >= chunk.count - remainderSize {
            // the # does not relate to the first size
            rightPoint = chunk.count - remainderSize
        }
        leftPoint = found ? rightPoint - firstSize : 0
        return (leftPoint, rightPoint)
    }
}
