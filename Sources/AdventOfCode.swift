import ArgumentParser

// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
    Day00(),
    Day01(),
    Day02(),
    Day03(),
    Day04(),
    Day05(),
    Day06(),
    Day07(),
    Day08(),
    Day09(),
    Day10(),
    Day11(),
    Day12(),
    Day13(),
    Day14(),
    Day15(),
    Day16(),
    Day17(),
    Day18(),
    Day19(),
    // Day25(),
]

@main
struct AdventOfCode: AsyncParsableCommand {
    @Argument(help: "The day of the challenge. For December 1st, use '1'.")
    var day: Int?

    @Flag(help: "Benchmark the time taken by the solution")
    var benchmark: Bool = false

    /// The selected day, or the latest day if no selection is provided.
    var selectedChallenge: any AdventDay {
        get throws {
            if let day {
                if let challenge = allChallenges.first(where: { $0.day == day }) {
                    return challenge
                } else {
                    throw ValidationError("No solution found for day \(day)")
                }
            } else {
                return latestChallenge
            }
        }
    }

    /// The latest challenge in `allChallenges`.
    var latestChallenge: any AdventDay {
        allChallenges.max(by: { $0.day < $1.day })!
    }

    func run(part: () async throws -> Any, named: String) async -> Duration {
        var result: Result<Any, Error> = .success("<unsolved>")
        let timing = await ContinuousClock().measure {
            do {
                result = try .success(await part())
            } catch {
                result = .failure(error)
            }
        }
        switch result {
        case let .success(success):
            print("\(named): \(success)")
        case let .failure(failure):
            print("\(named): Failed with error: \(failure)")
        }
        return timing
    }

    func run() async throws {
        let challenge = try selectedChallenge
        print("Executing Advent of Code challenge \(challenge.day)...")

        let timing1 = await run(part: challenge.part1, named: "Part 1")
        let timing2 = await run(part: challenge.part2, named: "Part 2")

        if benchmark {
            print("Part 1 took \(timing1), part 2 took \(timing2).")
            #if DEBUG
                print("Looks like you're benchmarking debug code. Try swift run -c release")
            #endif
        }
    }
}
