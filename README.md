# String Operations Performance Benchmark (Swift)

This project benchmarks the performance of various **stack** and **queue** implementations in Swift using `String`, `Array`, and `ArraySlice`. The goal is to evaluate their efficiency when used in checking whether a word is a palindrome. I generate 1000 samples 50% probability to be palindrome or random string with defined range.
Code provide abstract interface definition for Queue and Stack. The goal is to provide ability to test different implemenetations.

## 📋 Overview

I implement multiple variants of stacks and queues using:

- `Array<Character>` (standard dynamic array)
- `ArraySlice<Character>` (efficient queue via slicing)
- `String` (as an alternative character container)
- Buffered array-based queue (manual index management)

Each implementation is tested and the time is measured.

## 🧪 Tested Structures

### Stack Implementations
- `CharStack` — based on `Array<Character>`
- `StringStack` — based on `String`

### Queue Implementations
- `CharQueue` — standard `Array<Character>`-based queue
- `EfficientQueue` — based on `ArraySlice` for efficient `dequeue`
- `BuffCharQueue` — buffered queue using index tracking
- `StringQueue` — queue based on `String` as container 

### Wrapper
- `Solution` — encapsulates a `Queue` and `Stack` to perform palindrome tests.

## 📦 Types and Collections

- `Queue`, `Stack`, `Resettable`, `IsEmptyProtocol`: core protocols
- `CharQueue`, `CharStack`, `StringStack`, `EfficientQueue`, `BuffCharQueue`: collection implementations
- `Solution`: wraps queue and stack for palindrome logic
- `SampleGenerator`: generates test strings
- `MyTimer`: utility to measure execution time
- `TimerLogger`: preety console logger
- `PalindromeTest`: main test runner

## 🛠 How It Works

1. **Generate Sample Words** using `SampleGenerator`:
   - Words of customizable length. Defined ranges: small (3–9) and medium (10–29)
   - Randomly chosen to be palindromes or not with 50% probability

2. **Run Tests** using `PalindromeTest`:
   - Each character in a word is pushed to a stack and enqueued to a queue.
   - Then characters are popped and dequeued and finally compared.

3. **Measure Execution Time**:
   - Using `DispatchTime`, each test logs:
     - Total time for 1000 operations
     - Average time per operation
     - A simple checksum to validate correctness of palindrome checks


## 📊 Sample Performance Benchmark Results

### 🔹 Small Words (length: 3–9)

| Implementation Name       | Total Time [s] | Per Operation [s]  | Checksum |
|---------------------------|----------------|--------------------|----------|
| Sample Generation         | 1.113          | 0.001113           | 0        |
| CharQueue & CharStack     | 3.011          | 0.003011           | 509      |
| StringStack               | 2.370          | 0.002370           | 509      |
| String Queue & Stack      | 2.164          | 0.002164           | 509      |
| EfficientQueue            | 3.394          | 0.003394           | 509      |
| BuffCharQueue             | 3.179          | 0.003179           | 509      |

> 🕒 **Total benchmark time**: 15.306 seconds

---

### 🔸 Medium Words (length: 10–29)

| Implementation Name       | Total Time [s] | Per Operation [s]  | Checksum |
|---------------------------|----------------|--------------------|----------|
| Sample Generation         | 1.667          | 0.001667           | 0        |
| CharQueue & CharStack     | 11.569         | 0.011569           | 496      |
| StringStack               | 7.167          | 0.007167           | 496      |
| String Queue & Stack      | 3.393          | 0.003393           | 496      |
| EfficientQueue            | 11.473         | 0.011473           | 496      |
| BuffCharQueue             | 12.033         | 0.012033           | 496      |

> 🕒 **Total benchmark time**: 47.325 seconds

---

## ✅ Conclusion

- **String-based structures** (like `StringStack`, `String Queue & Stack`) offer better performance for short and medium-length inputs.
- **ArraySlice** and **buffered queues** do not show substantial speedup for this use case.
- `String Queue & Stack` was the fastest in most cases, making it a good candidate for lightweight palindrome checks.

---

## 🧠 Future Ideas

- Add different implementations for benchmarks
- Support for other types

## 🛠 How to Run

You can run this project in a Swift Playground or Xcode command-line project. 

## 📄 License

This project is open source and free to use under the MIT License.


