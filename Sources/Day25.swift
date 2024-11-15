import Algorithms
import Collections
import Foundation
import Swift

struct Day25: AdventDay {
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
        let componentStringList: [[String]] = entities.map { $0.split(separator: " ").map { String($0) } }
        let apparatusDict = initApparatusDict(componentStringList: componentStringList)
        let testDict = initTestDict(componentStringList: componentStringList)
        var notInKeys: Set<String> = Set()
        for connections in testDict.values {
            for item in connections {
                if !testDict.keys.contains(item) {
                    notInKeys.insert(item)
                }
            }
        }
        print("map -------------------------------")
        for key in apparatusDict.keys {
            print("component \(key) : \(apparatusDict[key]!)")
        }
        print("-----------------------------------")
        print(" first loops ------------------------")
        var mySet: Set<[String]> = Set()
        for key in apparatusDict.keys {
            let neighbors = apparatusDict[key]!
            var loopList: [[String]] = []
            for item in neighbors {
                loopList.append([key, item])
            }
            var found = false
            var foundLoop: [String] = []
            while !found && !loopList.isEmpty {
                for singleLoop in loopList {
                    let previous = singleLoop[singleLoop.count - 2]
                    var newList: [[String]] = []
                    for child in apparatusDict[singleLoop.last!]! {
                        if child == previous {
                            continue
                        }
                        if child == singleLoop.first! {
                            found = true
                            foundLoop = singleLoop
                            break
                        }
                        if singleLoop.contains(child) {
                            continue
                        }
                        var newLoop = singleLoop
                        newLoop.append(child)
                        newList.append(newLoop)
                    }
                    if found {
                        break
                    }
                    loopList = newList
                }
            }
            if !foundLoop.isEmpty {
                foundLoop.sort()
                mySet.insert(foundLoop)
            }
        }
        print(mySet.count)
        print("notInKeys: \(notInKeys)")
        return "Not implemented yet"
    }

    // Replace this with your solution for the second part of the day's challenge.
    func part2() -> Any {
        return "Not implemented yet"
    }
}

extension Day25 {
    func initApparatusDict(componentStringList: [[String]]) -> [String: [String]] {
        var apparatusDict: [String: [String]] = [:]
        for index in componentStringList.indices {
            let componentString = componentStringList[index]
            let name = String(componentString[0].split(separator: ":")[0])
            let connections: [String] = componentString[1 ..< componentString.count].map { String($0) }
            if var links = apparatusDict[name] {
                for index in connections.indices {
                    links.append(connections[index])
                }
                apparatusDict[name] = links
            } else {
                apparatusDict[name] = connections
            }
            for component in connections {
                if var links = apparatusDict[component] {
                    links.append(name)
                    apparatusDict[component] = links
                } else {
                    apparatusDict[component] = [name]
                }
            }
        }
        return apparatusDict
    }

    func initTestDict(componentStringList: [[String]]) -> [String: [String]] {
        var testDict: [String: [String]] = [:]
        for index in componentStringList.indices {
            let componentString = componentStringList[index]
            let name = String(componentString[0].split(separator: ":")[0])
            let connections: [String] = componentString[1 ..< componentString.count].map { String($0) }
            testDict[name] = connections
        }
        return testDict
    }
}
