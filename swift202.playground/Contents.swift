// 計算屬性 Computed Property & 屬性觀察 Property Observers
import Foundation

// Computed Property
//struct 方形 {
//    var 單邊長: Double
//    var 面積: Double {
//        set {
//            單邊長 = sqrt(newValue)
//        }
//        get {
//            單邊長 * 單邊長
//        }
//    }
//}
//
//
//var square = 方形(單邊長: 10)
//print(square.面積)
//square.單邊長 = 4
//print(square.面積)
//square.面積 = 64
//print(square)


// Property Observers
//struct 方形 {
//    var 單邊長: Double {
//        willSet {
//            print(">>> 即將把單邊長 \(單邊長) 改成 \(newValue)")
//        }
//        didSet {
//            面積 = 計算面積()
//            print(">>> 已經把單邊長 \(oldValue) 改成 \(單邊長)")
//        }
//    }
//    lazy private(set) var 面積: Double = 計算面積()
//    
//    private func 計算面積() -> Double {
//        print(">>> 現在開始計算面積並且賦值")
//        return 單邊長 * 單邊長
//    }
//}
//
//
//var square = 方形(單邊長: 10)
//print(square.面積)
//square.單邊長 = 20
//print(square)




// 【ChaoCode】 Swift 中級 2：計算屬性 Computed Property & 屬性觀察 Property Observers 實作作業

// 💡 這個作業在錄影完後有更新，新增了一個基本練習題，還有第二題多了一個方便你對照利率的靜態屬性。你沒有下載錯~~🙈

// 1. 請根據下列要求設計「姓名」、「年紀」和「已成年」屬性。

struct Human {
    private(set) var 姓: String
    private(set) var 名: String
    
    // 請用計算屬性設定姓名屬性，並加入 set 來改變姓名，將第一個字作為姓，剩下的作為名。
    var 姓名: String {
        set(name) {
            var name = name
            姓 = String(name.removeFirst())
            名 = name
        }
        get { 姓 + 名 }
    }
    
    // 年紀是一個 Int 的儲存屬性，請加入屬性觀察，並在變化時改變「已成年」的值。
    var 年紀: Int {
        didSet { 已成年 = 年紀 >= 18 }
    }
    
    // 請將已成年設為一個 lazy 屬性。
    lazy var 已成年 = 年紀 >= 18
}

// 👇 請勿刪除下列內容，印出來的內容應該要跟作業上提供的答案「完全一樣」。
var human = Human(姓: "", 名: "", 年紀: 14)
human.姓名 = "楊過"
print(human)
print("\(human.姓名)\(human.已成年 ? "已成年" : "未成年")")
human.姓名 = "小龍女"
human.年紀 = 18
print(human)
print("\(human.姓名)\(human.已成年 ? "已成年" : "未成年")")


// 2. 請根據以下規定設計一個 struct 名為「定存」的類型。
// 💡 你可以假設金額一定大於等於一萬元，年數一定大於等於六年。不考慮二進位和十進位落差。
// ＊請設計「金額」和「年數」這兩個屬性，表示定存的金額和時間長度，兩者類型皆為 Int，必須是可以被 set 和 get 的屬性。
// ＊請設計「期滿領回」屬性表示最後能拿回的金額。每年複利計算。結果請轉為 Int，無條件捨去小數位。
//      例如：存 10,000 元， 1 % 年利率。
//      第一年成長為 10,000 * 1.01 = 10,100 元；第二年則成長為 10,100 * 1.01 = 10,201
// ＊請設計「報酬率」屬性表示最後的賺到的比例，這是一個 Double 的類型。
//      例如：存 10,000 元， 1 % 年利率，存 2 年，最後得到 10,201，報酬率就是 201 / 10000 = 0.0201。
// ＊請設計一個「描述」屬性來敘述這筆定存內容將上述四個屬性都印出，報酬率顯示方式沒有限制。
//      例如："定存 10000 元，2 年後可領回 10201 元，總報酬率為 2.01%。"

// ＊年利率計算方式為 基本利率 + 加成利率，這兩個利率的計算方式如下：
//      基本利率：存款金額大於等於 10,000 元為 1 %；大於等於 80_000 元為 2 %；大於等於 200_000 元為 3.2 %；大於等於 1_000_000 元為 6 %。
//      加成利率：年份大於等於 6 年為 0.15 %；大於等於 10 年為 0.2 %；大於等於 20 年為 1.2 %。
//      例如：存 20,000 元 10 年就會是基本利率 1 % + 加成利率 0.2 %，年利率就是 1.2 %。
// ＊只要符合上述條件並且最後檢查沒問題即可，但希望你能至少用到一個 computed property。

struct 定存: HomeworkProtocol {
    var 金額: Int { didSet { 更新利率() } }
    var 年數: Int { didSet { 更新利率() } }
    private(set) var 年利率: Double = .zero
    
    var 期滿領回: Int {
        let money = (0..<年數).reduce(Double(金額)) { money, _ in money * (1 + 年利率) }
        return Int(money)
    }
    
    var 報酬率: Double { Double(期滿領回 - 金額) / Double(金額) }
    
    var 描述: String { "定存 \(金額) 元，\(年數) 年後可領回 \(期滿領回) 元，總報酬率為 \(String(format: "%.3f %%", 報酬率 * 100))。" }
    
    // 請勿刪除「HomeworkProtocol」，這個 Protocol 規範了這個作業需要的設計。
    // 請設定啟動內容（請勿更改參數類型、參數和引數名稱）
    init(_ 金額: Int, 年數: Int) {
        self.金額 = 金額
        self.年數 = 年數
        更新利率()
    }
    
    // 方法
    private mutating func 更新利率() {
        let base = Self.基礎利率對照表.last { 金額 >= $0.最小金額 }!.利率
        let bonus = Self.年數利率加成對照.last { 年數 >= $0.最小年數 }!.利率
        年利率 = base + bonus
    }
    
    // 靜態屬性 💡 你可以透過下面這些 Array 找對應利率，當然你也可以自己設計其他方式。
    typealias 利率對照 = (最小金額: Int, 利率: Double)
    typealias 年數加成對照 = (最小年數: Int, 利率: Double)
    
    static let 基礎利率對照表: [利率對照] = [(10_000, 0.01), (80_000, 0.02), (200_000, 0.032), (1_000_000, 0.06)]
    static let 年數利率加成對照: [年數加成對照] = [(6, 0.0015), (10, 0.002), (20, 0.012)]
}


// 👇 請勿刪除下列內容，描述沒有透過 function 檢查，所以請自行確認是否正確。記得要下載 checkHelper 才能執行。
let save = 定存(250000, 年數: 10)
print(save.描述)
利率檢查(type: 定存.self)

