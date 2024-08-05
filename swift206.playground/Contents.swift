// Extension
import Foundation

//extension Int {
//    // 定義一個計算屬性 `toDouble`，將 Int 型別轉換為 Double 型別。
//    var toDouble: Double {
//        // 將當前 Int 值轉換為 Double 並返回。
//        Double(self)
//    }
//    // 定義一個方法 `square`，計算當前 Int 值的平方。
//    func square() -> Int { self * self }
//    // 定義一個類型屬性 `one`，值為 1。
//    static let one = 1
//    // 定義一個類型方法 `random`，返回一個隨機的 Int 值。
//    static func random() -> Self {
//        // 返回一個在 Int 型別的最小值到最大值範圍內的隨機值。
//        random(in: Int.min...Int.max)
//    }
//    // 定義一個接受 Bool 型別的初始化方法。
//    init(_ bool: Bool) {
//        // 如果 `bool` 為 true，則將 `self` 設置為 1，否則設置為 0。
//        self = bool ? 1 : 0
//    }
//}
//
//let number = 100
//print(number.toDouble)
//Int.one
//number.square()
//print(Int.random())
//Int(true)
//Int(false)


// 方便轉換數字成 String 的 extension

extension Locale {
    static let tch: Locale = .init(identifier: "zh-hant-tw")
    static let japan: Locale = .init(identifier: "ja-JP")
}

//extension NumberFormatter {
//    static let decimalFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        return formatter
//    }()
//    static let currencyFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = .tch
//        return formatter
//    }()
//}
//
//extension Numeric {
//    func formatted(by formatter: NumberFormatter = .decimalFormatter) -> String {
//        formatter.string(for: self)!
//    }
//}
//
//let number = 1000
//
//print(number.formatted())
//print((2000000000.5454).formatted(by: .currencyFormatter))
//print(Decimal(31354).formatted())
//print(number.formatted(.currency(code: "TWD")))


// 新增啟動發誓、protocol、類型

//struct Cat {
//    var name: String
//    var color: String
//}
//
//extension Cat {
//    enum Color: String { case 橘色, 黃色, 黑色, 灰色, 白色 }
//    
//    init(name: String, color: Color) {
//        self.name = name
//        self.color = color.rawValue
//    }
//}
//
//extension Cat: Equatable { }
//
//extension Cat: CustomStringConvertible {
//    var description: String {
//        "\(color)的\(name)"
//    }
//}
// 
//let cat = Cat(name: "蛋蛋", color: "橘色")
//let cat2 = Cat(name: "皇阿瑪", color: .黃色)
//
//print(cat)
//print(cat2)


// 新增 subscript

//extension String {
//    subscript(_ offset: Int) -> Character? {
//        guard offset >= 0, let index = self.index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex)) else { return nil }
//        
//        return self[index]
//    }
//}
//
//let string = "可愛小貓咪"
//for index in -1...string.count {
//    print(string[index] ?? "沒有")
//}



// protocol extension
//extension Collection where Element: Numeric {
//    func sum() -> Self.Element {
//        reduce(.zero, +)
//    }
//}
//
//extension Collection where Element == Int {
//    func sum() -> Self.Element {
//        reduce(.zero, +)
//    }
//}
//
//[1,2,3,4,5].sum()
//print("----------------")
//[1,2,3,4,5.222].sum()







//: ### 【【ChaoCode】 Swift 中級 6：Extension 實作作業

/*: 1. 新增以下兩個功能到 String 中：
    * 名為「trimmed」的方法，功能是回傳把前後的空白和換行都移除的 String。
    * 新增可以放入 ClosedRange<Int> 做為 Index 的 subscript，只需設定 get，回傳對應位置的 String，如超過範圍則回傳一個空的 String。這個 subscript 不需要引數名稱，你可以假設 ClosedRange 中不會有負數。
    ```例如："ABCD"[1...2] 應回傳 "BC"。```
 */
extension String {
    func trimmed() -> String {
        // 使用 `trimmingCharacters` 方法去除字串前後的空白和換行符，並返回結果。
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    // 定義一個下標方法，接受一個封閉範圍（ClosedRange<Int>），返回範圍內的子字串。
    subscript(_ range: ClosedRange<Int>) -> String {
        // 如果範圍的起始位置大於字串的最大索引，返回空字串。
        if range.lowerBound > self.count - 1 { return "" }
        // 定義一個空字串，用於存儲結果。
        var string = ""
        // 定義一個變數 `currentIndex`，用於追蹤當前字元的索引。
        var currentIndex = 0
        // 使用 for 循環遍歷字串中的每一個字元。
        for character in self {
            // 如果當前索引在範圍內，將字元添加到結果字串中。
            if range.contains(currentIndex) {
                string += String(character)
            }
            
            currentIndex += 1
            // 如果當前索引大於範圍的上限，退出循環。
            if currentIndex > range.upperBound { break }
        }
        return string
    }
}

// ✋ 下面內容為測試用，請勿修改，並且在此行上方完成這題。
// ⚠️ 假如你的 extension 沒有設好或者名稱用不一樣的會無法執行。
stringExtensionCheck(trimmed: { $0.trimmed() }) { $0[$1] }

/*: 2. 為 Collection 新增一個名為「prettyPrint」的方法，功能是印出每一個 Element 並用「、」分隔。
 ```例如：[1,2,3,4] 應印出 "1、2、3、4"。```
 */

extension Collection{
    func prettyPrint() {
        print(self.map { String(describing: $0) }.joined(separator: "、"))
    }
}

// 👇 下面這些提供你測試，請自行檢查印出來的結果。
print("-------------------------")
"我吃飽了".prettyPrint()
Set([1, 2, 3, 4]).prettyPrint()
["貓咪", "狗狗", "兔兔"].prettyPrint()
["貓咪": 3, "狗狗": 5, "兔兔": 10].prettyPrint()
[(), ()].prettyPrint()

/*: 3. 為 Element 有 conforms to Hashable 的 Array 新增名為「unique」的方法。功能是只留下沒有重複的值（需維持原本順序）。
    * 假如 Element 是 String 的話，必須把 String trimmed 後判斷是否為空，如果是空的話也不留下。（trimmed 指的是第一題完成的方法）
    ```
        ["abc", "abc", ""].unique() 應回傳 ["abc"]。
        [2, 3, 2, 1].unique() 應回傳 [2, 3, 1]。
    ```
 */
extension Array where Element: Hashable {
    func unique() -> Self {
        // 定義一個字典 `seenMap`，用來記錄已經出現過的元素。
        var seenMap = [Element: Bool]()
        // 使用 `filter` 方法篩選數組元素。
        return filter { seenMap.updateValue(true, forKey: $0) == nil }
        // 如果字典中沒有該元素，則將其加入字典並保留在新數組中。
                    // 如果字典中已經有該元素，則過濾掉該元素。
    }
}
extension Array where Element == String {
    func unique() -> Self {
        var seenMap = [Element: Bool]()
        // 使用 `map` 方法對每個字串進行 `trimmed` 操作，去除前後空白和換行符。
        return self.map { $0.trimmed() }
            .filter {
                // 如果字典中沒有該元素且元素不為空，則將其加入字典並保留在新數組中。
                                // 如果字典中已經有該元素或元素為空，則過濾掉該元素。
                seenMap.updateValue(true, forKey: $0) == nil && !$0.isEmpty
            }
    }
}

// ✋ 下面內容為測試用，請勿修改，並且在此行上方完成這題。
// ⚠️ 假如你的 extension 沒有設好或者名稱用不一樣的會無法執行。
print("-------------------------")
arrayExtensionCheck(uniqueString: { $0.unique() }) { $0.unique() }


