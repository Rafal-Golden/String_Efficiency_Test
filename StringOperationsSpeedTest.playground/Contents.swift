// String, Character, Array type Efficiency test based Playground
// Base is efficient solution for Palindrome problem
// Sample code how implement efficiency test with flexibility of code
  
import Foundation
import PlaygroundSupport


protocol Resettable {
    func reset()
}

protocol IsEmptyProtocol {
    var isEmpty: Bool { get }
    var isNotEmpty: Bool { get }
}

protocol Queue: Resettable, IsEmptyProtocol {
    func enqueue(_ char: Character)
    func dequeue() -> Character?
}

protocol Stack: Resettable, IsEmptyProtocol {
    func push(_ char: Character)
    func pop() -> Character?
}

protocol SolutionProtocol: Resettable {
    var queue: Queue { get set }
    var stack: Stack { get set }
    
    func pushCharacter(char: Character)
    func popCharacter() -> Character?
    func enqueueCharacter(char: Character)
    func dequeueCharacter() -> Character?
}

class CharQueue: Queue {
    private var data: [Character] = []
    
    var isEmpty: Bool {
        return data.isEmpty
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func enqueue(_ char: Character) {
        data.append(char)
    }
    
    func dequeue() -> Character? {
        return data.isEmpty ? nil : data.removeFirst()
    }
    
    func reset() {
        data.removeAll(keepingCapacity: true)
    }
}

class CharStack: Stack {
    private var data: [Character] = []
    
    var isEmpty: Bool {
        return data.isEmpty
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func push(_ char: Character) {
        data.append(char)
    }
    
    func pop() -> Character? {
        return data.isEmpty ? nil : data.removeLast()
    }
    
    func reset() {
        data.removeAll(keepingCapacity: true)
    }
}

class StringStack: Stack {
    private var data: String = ""
    
    var isEmpty: Bool {
        return data.isEmpty
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func push(_ char: Character) {
        data.append(char)
    }
    
    func pop() -> Character? {
        return data.popLast()
    }
    
    func reset() {
        data = ""
    }
}

class StringQueue: Queue {
    private var data: String = ""
    
    var isEmpty: Bool {
        return data.isEmpty
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func enqueue(_ char: Character) {
        data.append(char)
    }
    
    func dequeue() -> Character? {
        return data.isEmpty ? nil : data.removeFirst()
    }
    
    func reset() {
        data = ""
    }
}

class Solution: SolutionProtocol {

    var queue: Queue
    var stack: Stack
    
    init(queue: Queue, stack: Stack) {
        self.queue = queue
        self.stack = stack
    }
    
    func pushCharacter(char: Character) {
        stack.push(char)
    }
    
    func popCharacter() -> Character? {
        return stack.pop()
    }
    
    func enqueueCharacter(char: Character) {
        queue.enqueue(char)
    }
    
    func dequeueCharacter() -> Character? {
        return queue.dequeue()
    }
    
    func reset() {
        queue.reset()
        stack.reset()
    }
}

class EfficientQueue: Queue {
    
    private var data: ArraySlice<Character> = []
    
    var isEmpty: Bool {
        return data.isEmpty
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }

    func enqueue(_ ch: Character) {
        data.append(ch)
    }

    func dequeue() -> Character? {
        guard data.isEmpty == false else { return nil }
        let first = data.first
        data = data.dropFirst() // fast drop O(1)
        return first
    }
    
    func reset() {
        data.removeAll(keepingCapacity: true)
    }
}

class BuffCharQueue: Queue {
    private var data: [Character] = []
    private var headIndex = 0

    func enqueue(_ ch: Character) {
        data.append(ch)
    }

    func dequeue() -> Character? {
        guard headIndex < data.count else { return nil }
        defer { headIndex += 1 }

        return data[headIndex]
    }

    var isEmpty: Bool {
        return headIndex >= data.count
    }

    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func reset() {
        data.removeAll(keepingCapacity: true)
        headIndex = 0
    }
}


class PalindromeTest {
    var samples: [String]
    var solution: Solution
    var timer: Timer
    
    init(samples: [String], solution: Solution, timer: Timer) {
        self.samples = samples
        self.solution = solution
        self.timer = timer
    }
    
    func runTest(logger: TimerLogger? = nil) {
        var checkSum: Int = 0
        
        timer.measureTime(operations: samples.count, workBlock: {
            var results = [Bool]()
            var sum: Int = 0
            
            for word in samples {
                let result = isPalindrome(word: word)
                results.append(result)
                sum += (result ? 1 : 0)
            }
            
           checkSum = sum
        })
        
        if let logger {
            logger.println(timer: timer, checksum: checkSum)
        }
    }
    
    func isPalindrome(word: String) -> Bool {
        // prepare
        solution.reset()
        
        // push/enqueue all the characters of string s to stack.
        for character in word {
            solution.pushCharacter(char: character)
            solution.enqueueCharacter(char: character)
        }

        var isPalindrome = true

        // pop the top character from stack.
        // dequeue the first character from queue.
        // compare both the characters.
        for _ in 0..<(word.count / 2) {
            if solution.popCharacter() != solution.dequeueCharacter() {
                isPalindrome = false
                break
            }
        }

        return isPalindrome
    }
}

protocol Timer {
    var totalTime: Double { get }
    var singleTime: Double { get }
    var operations: Int { get }
    var name: String { get }
    func measureTime(operations: Int, workBlock: () -> Void)
}

class MyTimer: Timer {
    var totalTime: Double
    var singleTime: Double
    var operations: Int
    var name: String
    
    init(name: String) {
        self.totalTime = 0
        self.singleTime = 0
        self.operations = 0
        self.name = name
    }
    
    func measureTime(operations: Int, workBlock: () -> Void) {
        self.operations = operations
        let start = DispatchTime.now()
        
        workBlock()
        
        let end = DispatchTime.now()
        let totalNano = end.uptimeNanoseconds - start.uptimeNanoseconds
        totalTime = Double(totalNano) / 1_000_000_000
        singleTime = totalTime / Double(operations)
    }
}

class TimerLogger {
    var header: String
    
    init() {
        self.header = ""
    }
    
    func defineHeader(columns: [String]) {
        if columns.isEmpty {
            header = ""
            return
        }
        header = "| " + columns.joined(separator: " \t | ") + " |"
    }
    
    func println(timer: Timer, checksum: Int = 0) {
        printHeader(operations: timer.operations)
        printRow(data: [timer.name, String(format: "%.3f", timer.totalTime),
                        String(format: "%.6f", timer.singleTime),
                        String(format: "%d", timer.operations),
                        String(format: "%d", checksum)])
    }
    
    private func printRow(data: [String]) {
        let row = "| " + data.joined(separator: "\t | ") + " |"
        print(row)
    }
    
    private func printHeader(operations: Int) {
        guard header.count > 0 else { return }
        print("Executed for \(operations) operations.")
        print(header)
        header = ""
    }
}

class SampleGenerator {
    var numberOfSamples: Int
    var range: ClosedRange<Int>
    
    init(numberOfSamples: Int, range: ClosedRange<Int>) {
        self.numberOfSamples = numberOfSamples
        self.range = range
    }
    
    func generate() -> [String] {
        var samples: [String] = []
        
        for i in 0..<numberOfSamples {
            let str = generateString(length: .random(in: range))
            samples.append(str)
        }
        
        return samples
    }
    
    func generateString(length: Int) -> String {
        let letters = Array("abcdefghijklmnopqrstuvwxyz")
        var randomString = ""
        
        let isPalindrome: Bool = .random()
        let count = isPalindrome ? length / 2 + 1 : length
        
        for _ in 0..<count {
            let randomIndex = Int.random(in: 0..<letters.count)
            randomString.append(letters[randomIndex])
        }
        
        if isPalindrome {
            let reducedStr = randomString.dropLast()
            randomString += reducedStr.reversed()
        }
        
        return randomString
    }
}

extension PalindromeTest {
    convenience init(samples: [String], solution: Solution, timerName: String) {
        let myTimer = MyTimer(name: timerName)
        self.init(samples: samples, solution: solution, timer: myTimer)
    }
}

func TestForSampleWords(range: ClosedRange<Int>) {
    
    let myTimer = MyTimer(name: "char range \(range)")
    myTimer.measureTime(operations: 1) {
        
        var sampleGen = SampleGenerator(numberOfSamples: 1000, range: range)
        var samples: [String] = []
        let timer = MyTimer(name: "Sample Generation")
        timer.measureTime(operations: 1000) {
            samples = sampleGen.generate()
        }
        
        let logger = TimerLogger()
        logger.defineHeader(columns: ["Implementation name", "Total time [s]", "operation time [s]", "Checksum"])
        logger.println(timer: timer)

        // basing solution on array of characters
        var solution0 = Solution(queue: CharQueue(), stack: CharStack())
        var palindromTest0 = PalindromeTest(samples: samples, solution: solution0, timerName: "CharQueue & CharStack")
        palindromTest0.runTest(logger: logger)

        // string stack
        var solution1 = Solution(queue: CharQueue(), stack: StringStack())
        var palindromTest1 = PalindromeTest(samples: samples, solution: solution1, timerName: "StringStack")
        palindromTest1.runTest(logger: logger)
        
        // string stack and string queue
        var solution11 = Solution(queue: StringQueue(), stack: StringStack())
        var palindromTest11 = PalindromeTest(samples: samples, solution: solution11, timerName: "String Queue & Stack")
        palindromTest11.runTest(logger: logger)

        // efficient queue using sliced array
        var solution2 = Solution(queue: EfficientQueue(), stack: CharStack())
        var palindromTest2 = PalindromeTest(samples: samples, solution: solution2, timerName: "EfficientQueue")
        palindromTest2.runTest(logger: logger)

        var solution3 = Solution(queue: BuffCharQueue(), stack: CharStack())
        var palindromTest3 = PalindromeTest(samples: samples, solution: solution3, timerName: "BuffCharQueue")
        palindromTest3.runTest(logger: logger)
    }
    let logger = TimerLogger()
    logger.defineHeader(columns: ["Word length", "Total time [s]"])
    logger.println(timer: myTimer)
}


TestForSampleWords(range: 3...9)
TestForSampleWords(range: 10...29)

