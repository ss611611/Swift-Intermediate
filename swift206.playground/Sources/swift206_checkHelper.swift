public func stringExtensionCheck(trimmed: (String) -> String, findString: (String, ClosedRange<Int>) -> String) {
    let trimTests =  [
        ("\n   Good Morning! 😊", "Good Morning! 😊"),
        ("  \t   ChaoCode\n", "ChaoCode"),
        ("  ", ""),
        ("\n", ""),
        ("吃飯\n睡覺\n寫code\n", "吃飯\n睡覺\n寫code")]
    
    for test in trimTests {
        let result = trimmed(test.0)
        if result != test.1 {
            print("❌ 「\(test.0)」trimmed 結果應為「\(test.1)」，但您的結果是「\(result)」")
            return
        }
    }
    print("✅ 您的 String trimmed 沒有問題。")
    
    let finderTest = [("", 0...3, ""),
                      ("", 0...0, ""),
                      ("0123456", 0...0, "0"),
                      ("0123456", 0...7, "0123456"),
                      ("0123456", 0...20,"0123456"),
                      ("0123456", 0...3, "0123"),
                      ("0123456", 0...5, "012345"),
                      ("0123456", 0...6, "0123456"),
                      ("0123456", 2...3, "23"),
                      ("0123456", 4...5, "45"),
                      ("0123456", 6...6, "6"),
                      ("我會寫code 我好厲害😎", 0...1, "我會"),
                      ("我會寫code 我好厲害😎", 0...6, "我會寫code"),
                      ("我會寫code 我好厲害😎", 1...6, "會寫code"),
                      ("我會寫code 我好厲害😎", 0...26, "我會寫code 我好厲害😎"),
                      ("我會寫code 我好厲害😎", 8...12, "我好厲害😎")]
    
    for test in finderTest {
        let result = findString(test.0, test.1)
        if result != test.2 {
            print("❌ \(test.0) 的第 \(test.1.lowerBound) 到 \(test.1.upperBound) 個字應為「\(test.2)」，但您的結果是「\(result)」")
            return
        }
    }
    
    print("✅ 您的 String subscript 沒有問題。")
}


public func arrayExtensionCheck(uniqueString: ([String]) -> [String], unique: ([AnyHashable]) -> [AnyHashable]) {
    let stringTests = [(["貓", "狗", "貓", "兔", "貓", "狗", "兔", "狗"], ["貓", "狗", "兔"]),
                       (["貓", "貓", "貓\n", " 貓", "  貓貓  "], ["貓", "貓貓"])]
    for test in stringTests {
        let result = uniqueString(test.0)
        guard result == test.1 else {
            print("❌ String Array: \(test.0) 結果應為 \(test.1)，但您的結果是 \(result)")
            return
        }
    }
    func runTest<T: Hashable>(array: [T], answer: [T]) -> Bool {
        let result = unique(array)
        guard (result == answer.map { AnyHashable($0) }) else {
            print("❌ Array: \(array) 結果應為 \(answer)，但您的結果是 \(result as! [T])")
            return false
        }
        return true
    }
    
    guard runTest(array: [true, false, false, true], answer: [true, false]),
          runTest(array: [1, 21, 77, 21, 1, 0, -3, -99, -99, 77, 88, -3, 77], answer: [1, 21, 77, 0, -3, -99, 88]),
          runTest(array: [1.9, 1.9, -1, 0, 1, 1], answer: [1.9, -1, 0, 1]) else { return }
    
    
    print("✅ 您的 Array unique 沒有問題。")
}
