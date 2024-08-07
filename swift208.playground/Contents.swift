// KeyPath

//struct 貓咪 {
//    var name: String
//    var age: Int? = nil
//}
//
//
//let someKeyPath = \貓咪.name
//let someClosure: (貓咪) -> String = \.name
//
//let 貓咪們 = [貓咪(name: "蛋蛋"), 貓咪(name: "橘咪", age: 6)]
//
//print(貓咪們.map(\.name))
//print(貓咪們.map(\.age?.description))
//
//print(貓咪們[keyPath: \.[0].name])
//var cat = 貓咪們.first!
//cat[keyPath: someKeyPath] = "Egg"
//
//print(cat)


//import Foundation
//
//struct 貓咪: CustomStringConvertible {
//    var name: String
//    var color: String
//    
//    var description: String { "\(name) (\(color))"}
//}
//
//let 貓咪們 = [貓咪(name: "蛋蛋", color: "橘"), 貓咪(name: "橘咪", color: "白+黃")]
//
//extension Array {
//    // 定義一個方法 `filter`，根據關鍵字和屬性 KeyPath 來篩選陣列中的元素。
//    func filter(keyword: String, on paths: [KeyPath<Element, String>]) -> Self {
//        // 使用 `filter` 方法來篩選陣列。
//        filter { 資料 in
//            // 檢查是否有屬性包含關鍵字。
//            paths.contains { path in
//                // 使用 KeyPath 獲取屬性值。
//                let 屬性資料 = 資料[keyPath: path]
//                // 檢查屬性值是否包含關鍵字。
//                return 屬性資料.contains(keyword)
//            }
//        }
//    }
//}
//
//print(貓咪們.filter { $0.name.contains("橘") || $0.color.contains("橘") })
//print(貓咪們.filter(keyword: "橘", on: [\.name, \.color]))



//import Foundation
//
//protocol 可搜尋 {
//    // 定義一個靜態屬性 `搜尋屬性`，這是一個 `KeyPath` 陣列，用來指定哪些屬性可以被用來進行篩選。
//    static var 搜尋屬性: [KeyPath<Self, String>] { get }
//}
//
//// 擴展 `Sequence`，為符合 `可搜尋` 協議的元素添加方法。
//extension Sequence where Element: 可搜尋 {
//    func filter(keyword: String) -> [Element] {
//        filter { 資料 in
//            Element.搜尋屬性.contains { path in
//                let 屬性資料 = 資料[keyPath: path]
//                return 屬性資料.contains(keyword)
//            }
//        }
//    }
//}
//
//struct 貓咪: CustomStringConvertible, 可搜尋 {
//    static var 搜尋屬性: [KeyPath<貓咪, String>] = [\.color, \.name]
//    
//    var name: String
//    var color: String
//    
//    var description: String { "\(name) (\(color))"}
//}
//
//let 貓咪們 = [貓咪(name: "蛋蛋", color: "橘"), 貓咪(name: "橘咪", color: "白+黃")]
//
//print(貓咪們.filter(keyword: "橘"))
//print(貓咪們.filter(keyword: "白"))
//print(貓咪們.filter(keyword: "蛋蛋"))
//
//
//struct 狗狗: CustomStringConvertible, 可搜尋 {
//    // 定義 `可搜尋` 協議所需的靜態屬性 `搜尋屬性`，這是一個 `KeyPath` 陣列，用來指定哪些屬性可以被用來進行篩選。
//    static var 搜尋屬性: [KeyPath<狗狗, String>] = [\.名字, \.品種.rawValue]
//    
//    // 定義了一個內部枚舉 `品種`，用來表示狗狗的品種，每個品種都對應一個字串值。
//    enum 品種: String {
//        case 博美, 柴犬, 哈士奇, 米克斯
//    }
//    
//    var 名字: String
//    var 品種: 品種
//    var 體重: Int
//    // 實現 `CustomStringConvertible` 協議所需的 `description` 屬性，返回狗狗的名字和品種的描述字串。
//    var description: String { "\(名字) (\(self.品種.rawValue)) " }
//}
//let 狗狗們 = [狗狗(名字: "皮皮", 品種: .米克斯, 體重: 7000),
//           狗狗(名字: "米粒", 品種: .博美, 體重: 3000),
//           狗狗(名字: "栗子", 品種: .柴犬, 體重: 6520)]
//
//print(狗狗們.filter(keyword: "柴犬"))
//print(狗狗們.filter(keyword: "米"))


// KeyPath 版本的 sorted 和數字加總
//import Foundation
//
//struct 狗狗: CustomStringConvertible {
//    enum 品種: String { case 博美, 柴犬, 哈士奇, 米克斯 }
//    
//    var 名字: String
//    var 品種: 品種
//    var 體重: Int
//    
//    var description: String { "\(名字) (\(self.品種.rawValue)) " }
//}
//
//let 狗狗們 = [狗狗(名字: "皮皮", 品種: .米克斯, 體重: 7000),
//           狗狗(名字: "米粒", 品種: .博美, 體重: 3000),
//           狗狗(名字: "栗子", 品種: .柴犬, 體重: 6520)]
//
//extension Sequence {
//    // 定義一個泛型方法 `sorted`，接受一個 KeyPath 作為參數，這個 KeyPath 指向 Element 類型的屬性，並且這個屬性需要符合 Comparable 協議。
//    // 返回排序後的陣列。
//    func sorted<T: Comparable>(_ path: KeyPath<Element, T>) ->[Element] {
//        sorted {
//            // 使用陣列的 `sorted` 方法，根據提供的 KeyPath 進行排序。
//            // 這裡使用了閉包，將元素的指定屬性進行比較來確定排序順序。
//            $0[keyPath: path] < $1[keyPath: path]
//        }
//    }
//    
//    // 定義一個泛型方法 `sum`，接受一個 KeyPath 作為參數，這個 KeyPath 指向 Element 類型的屬性，並且這個屬性需要符合 AdditiveArithmetic 協議。
//    // 返回所有元素指定屬性的總和。
//    func sum<T: AdditiveArithmetic>(_ path: KeyPath<Element, T>) -> T {
//        // 使用 `reduce` 方法來計算總和。從 `T.zero` 開始，逐一將元素的指定屬性累加起來。
//        reduce(T.zero) { $0 + $1[keyPath: path] }
//    }
//}
//
//print(狗狗們.sorted { $0.體重 < $1.體重 })
//print(狗狗們.sorted(\.體重))
//print(狗狗們.sum(\.體重))
//print([200.3, 400].sum(\.self))





//【ChaoCode】 Swift 中級篇 8：KeyPath 實作作業
//: 1. 在 Array 的 extension 中寫一個能把所有資料的某個 Double 屬性加總後算出平均值的方法。
extension Array {
    // 定義一個方法 `average`，接受一個 KeyPath 作為參數，這個 KeyPath 指向 Element 類型的某個 Double 屬性。
    func average(_ keyPath: KeyPath<Element, Double>) -> Double {
        // 使用 `reduce` 方法將陣列中指定屬性的所有值加起來，初始值為 0。
        let total = self.reduce(0) { $0 + $1[keyPath: keyPath] }
        // 將總和除以陣列的長度，得到平均值並返回。
        return total / Double(self.count)
    }
}

// ✨ 以下測試請自行完成，前面是 Array，然後是要計算哪個屬性的平均，最後 == 後面是預期結果，你只需要把中間文字的部分改成你設計的方法並放入 keyPath，然後確認兩邊相比結果是 true 即可

[100, 60, 5.0].average(\.self) == 55 // 這個就是平均數字本身
[長度單位(m: 3), 長度單位(m: 0.23), 長度單位(m: 935), 長度單位(m: 1130)].average(\.公尺) ==  517.0575
[長度單位(m: 23), 長度單位(m: 32.311), 長度單位(m: 935), 長度單位(m: 113.0)].average(\.公分) == 27582.775
[長度單位(m: 9), 長度單位(m: 12321), 長度單位(m: 935), 長度單位(m: 1.130)].average(\.公里) == 3.3165325


/*: 2. 在 Sequence 的 extension 中寫一個透過某個屬性分類後回傳字典的方法。
 ```
 假設一筆資料是 [(name: "小芳", 性別: "女"), (name: "偉偉", 性別: "男"), (name: "芯宜", 性別: "女")]
 這筆資料用「性別」分類的話，回傳的字典結果就會是
 ["女": [(name: "小芳", 性別: "女"), (name: "芯宜", 性別: "女")], "男": [(name: "偉偉", 性別: "男")]]
 ```
 */
extension Sequence {
    // 定義一個泛型方法 `groupBy`，接受一個 KeyPath 作為參數，這個 KeyPath 指向 Element 類型的屬性，並且這個屬性需要符合 Hashable 協議。
    // 返回一個字典，字典的鍵是 Value 類型，值是包含 Element 類型的陣列。
    func groupBy<Value: Hashable>(_ keyPath: KeyPath<Element, Value>) -> [Value: [Element]] {
        // 定義一個空字典，將用來存儲分組結果。
        var result = [Value: [Element]]()
        
        // 對序列中的每一個元素進行遍歷。
        self.forEach {
            // 使用元素的指定屬性作為鍵，如果字典中已經存在該鍵，則在其值的陣列中追加當前元素；如果不存在，則創建一個新的鍵值對。
            result[$0[keyPath: keyPath], default: []].append($0)
        }
        return result // 返回分組結果。
    }
}

// ✨ 請使用以下兩個變數進行分類，並印出回傳的字典。
// spends 請分別印出用「付款方式」和用「類別」分類的方式
print(spends.groupBy(\.付款方式))
print(spends.groupBy(\.類別))

// movies 請用「類型」分類
print(movies.groupBy(\.類型))


