import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day10Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    """

    let testData2 = """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.L-J
    """

    let testData3 = """
    ...........
    .S-------7.
    .|F-----7|.
    .||.....||.
    .||.....||.
    .|L-7.F-J|.
    .|..|.|..|.
    .L--J.L--J.
    ...........
    """

    let testData4 = """
    .F----7F7F7F7F-7....
    .|F--7||||||||FJ....
    .||.FJ||||||||L7....
    FJL7L7LJLJ||LJ.L-7..
    L--J.L7...LJS7F-7L7.
    ....F-J..F7FJ|L7L7L7
    ....L7.F7||L7|.L7L7|
    .....|FJLJ|FJ|F7|.LJ
    ....FJL-7.||.||||...
    ....L---J.LJ.LJLJ...
    """

    let testData5 = """
    FF7FSF7F7F7F7F7F---7
    L|LJ||||||||||||F--J
    FL-7LJLJ||||||LJL-77
    F--JF--7||LJLJ7F7FJ-
    L---JF-JLJ.||-FJLJJ7
    |F|F-JF---7F7-L7L|7|
    |FFJF7L7F-JF7|JL---7
    7-L-JL7||F7|L7F-7F7|
    L.L7LFJ|||||FJL7||LJ
    L7JLJL-JLJLJL--JLJ.L
    """

    let yan = """
    .#.#.#.#.#.#.#.#.#.#.#
    ######################
    .#F---------------7#.#
    ##|###############|###
    .#|#F-----------7#|#.#
    ##|#|###########|#|###
    .#|#|#.#.#.#.#.#|#|#.#
    ##|#|###########|#|###
    .#|#|#.#.#.#.#.#|#|#.#
    ##|#|###########|#|###
    .#|#L---7#.#F---J#|#.#
    ##|#####|###|#####|###
    .#|#.#.#|#.#|#.#.#|#.#
    ##|#####|###|#####|###
    .#L-----J#.#L-----J#.#
    ######################
    .#.#.#.#.#.#.#.#.#.#.#
    ######################
    """

    let yan2 = """
    .#.#.#.#.#.#.#.#.#.#
    ####################
    .#S-------------7#.#
    ##|#############|###
    .#|#F---------7#|#.#
    ##|#|#########|#|###
    .#|#|#.#.#.#.#|#|#.#
    ##|#|#########|#|###
    .#|#|#.#.#.#.#|#|#.#
    ##|#|#########|#|###
    .#|#L---7#F---J#|#.#
    ##|#####|#|#####|###
    .#|#.#.#|#|#.#.#|#.#
    ##|#####|#|#####|###
    .#L-----J#L-----J#.#
    ####################
    .#.#.#.#.#.#.#.#.#.#
    ####################
    """

    func testPart1() throws {
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "4")
    }

    func testPart2() throws {
        let challenge = Day10(data: testData2)
        XCTAssertEqual(String(describing: challenge.part1()), "8")
    }

    func testPart3() throws {
        let challenge = Day10(data: testData3)
        XCTAssertEqual(String(describing: challenge.part2()), "4")
    }

    func testPart4() throws {
        let challenge = Day10(data: testData4)
        XCTAssertEqual(String(describing: challenge.part2()), "8")
    }

    func testPart5() throws {
        let challenge = Day10(data: testData5)
        XCTAssertEqual(String(describing: challenge.part2()), "10")
    }
}
