import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day16Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    // "\" is an escape character inside strings, so we have to double up on them. i.e. escape the escape
    let testData = """
    .|...\\....
    |.-.\\.....
    .....|-...
    ........|.
    ..........
    .........\\
    ..../.\\\\..
    .-.-/..|..
    .|....-|.\\
    ..//.|....
    """

    // After energized for part 1, should look like:

    // ######....
    // .#...#....
    // .#...#####
    // .#...##...
    // .#...##...
    // .#...##...
    // .#..####..
    // ########..
    // .#######..
    // .#...#.#..

    func testPart1() throws {
        let challenge = Day16(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "46")
    }

    func testPart2() throws {
        let challenge = Day16(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "71503")
    }
}
