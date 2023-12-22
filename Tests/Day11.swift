import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day11Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    ...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#.....
    """

    let expandData = """
    ....#........
    .........#...
    #............
    .............
    .............
    ........#....
    .#...........
    ............#
    .............
    .............
    .........#...
    #....#.......
    """

    func testPart1() throws {
        let challenge = Day11(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "374")
    }

    func testExpand() throws {
        let challenge = Day11(data: testData)
        // let x = challenge.expandedString().split(separator: "\n").map { String($0) }
        // let y = expandData.split(separator: "\n").map { String($0) }
        // print(x == y)
        XCTAssertEqual(String(describing: challenge.expandedString()), expandData)
    }

    func testPart2() throws {
        let challenge = Day11(data: testData)
        let parts = challenge.part2() as! (Int, Int, Int, Int)
        XCTAssertEqual(String(describing: parts.0), "1030")
    }

    func testPart3() throws {
        let challenge = Day11(data: testData)
        let parts = challenge.part2() as! (Int, Int, Int, Int)
        XCTAssertEqual(String(describing: parts.1), "8410")
    }

    func testPart4() throws {
        let challenge = Day11(data: testData)
        let parts = challenge.part2() as! (Int, Int, Int, Int)
        XCTAssertEqual(String(describing: parts.2), "374")
    }
}
