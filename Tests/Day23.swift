import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day23Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    R 6 (#70c710)
    D 5 (#0dc571)
    L 2 (#5713f0)
    D 2 (#d2c081)
    R 2 (#59c680)
    D 2 (#411b91)
    L 5 (#8ceee2)
    U 2 (#caa173)
    L 1 (#1b58a2)
    U 2 (#caa171)
    R 2 (#7807d2)
    U 3 (#a77fa3)
    L 2 (#015232)
    U 2 (#7a21e3)
    """

    func testPart1() throws {
        let challenge = Day23(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "62")
    }

    func testPart2() throws {
        let challenge = Day23(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "71503")
    }
}
