// Property Wrapper

//import Foundation
//
//@propertyWrapper
//// 定義一個屬性包裝器，名為 "限制最大值"。
//struct 限制最大值 {
//    // 定義一個私有常數 "最大值"，用來存儲最大值的限制。
//    private let 最大值: Int
//    
//    var wrappedValue: Int {
//        didSet {
//            // 每次設定 wrappedValue 時，檢查它是否超過最大值，若超過則設定為最大值。
//            wrappedValue = min(最大值, wrappedValue)
//        }
//    }
//    // 初始化時將傳入的值與最大值進行比較，設定為較小者。
//    init(wrappedValue: Int, 最大值: Int) {
//        self.wrappedValue = min(最大值, wrappedValue)
//        
//        // 將最大值參數賦值給私有常數 "最大值"。
//        self.最大值 = 最大值
//        
//    }
//}
//// 定義一個結構體 "行李"。
//struct 行李 {
//    // 使用 "限制最大值" 屬性包裝器來限制 "手提重量" 的最大值為 10，初始值為 0。
//    @限制最大值(最大值: 10) var 手提重量: Int = 0
//    
//    // 使用 "限制最大值" 屬性包裝器來限制 "托運重量" 的最大值為 25，初始值為 0。
//    @限制最大值(wrappedValue: 0, 最大值: 25) var 托運重量: Int
//    
//    // 使用 "限制最大值" 屬性包裝器來限制 "高爾夫重量"，需要在初始化時設置最大值。
//    @限制最大值 var 高爾夫重量: Int
//    
//    // 定義一個初始化方法，接受四個參數：手提、托運、托運最大值和高爾夫。
//    init(手提: Int, 托運: Int, 托運最大值: Int, 高爾夫: Int) {
//        手提重量 = 手提
//        // 使用屬性包裝器的初始化方法來設置 "托運重量" 和其最大值。
//        _托運重量 = .init(wrappedValue: 托運, 最大值: 托運最大值)
//        // 使用屬性包裝器的初始化方法來設置 "高爾夫重量" 和其最大值為 30。
//        _高爾夫重量 = .init(wrappedValue: 高爾夫, 最大值: 30)
//    }
//}
//
//var packages = 行李(手提: 15, 托運: 25, 托運最大值: 22, 高爾夫: 32)
//packages.手提重量 = 7
//packages.托運重量 = 20
//packages.高爾夫重量 = 18
//
//print(packages.手提重量)
//print(packages.托運重量)
//print(packages.高爾夫重量)
//print(packages.重量)
//packages.重量 = 13
//print(packages.重量)
//packages.重量 = 7
//print(packages.重量)

//@propertyWrapper
//// 定義一個泛型屬性包裝器 ChangeLog，適用於任何類型 T。
//struct ChangeLog<T> {
//    
//    // 定義被包裝的屬性值，類型為 T。
//    var wrappedValue: T {
//        
//        // 當 wrappedValue 被改變時執行以下代碼。
//        didSet {
//            print("✏️ \(描述)的值被改變為 \(wrappedValue)")
//        }
//    }
//    
//    var projectedValue: Self { self }
//
//    // 定義一個描述屬性，類型為 String。此屬性只能在內部設置，但可以在外部讀取。
//    private(set) var 描述: String
//}
//
//struct 帳目 {
//    // 使用 ChangeLog 屬性包裝器來包裝 "用途" 屬性，並設置描述為 "用途"，初始值為空字符串。
//    @ChangeLog(描述: "用途") var 用途: String = ""
//    // 使用 ChangeLog 屬性包裝器來包裝 "費用" 屬性，描述信息將在初始化時設置。
//    @ChangeLog var 費用: Int
//    
//    // 初始化方法，接受用途和費用兩個參數。
//    init(用途: String, 費用: Int) {
//        // 設置用途屬性。
//        self.用途 = 用途
//        // 使用 ChangeLog 包裝器來初始化 "費用" 屬性，設置包裝值為費用，描述信息為 "用途 花費"。
//        _費用 = .init(wrappedValue: 費用, 描述: "\(用途) 花費")
//    }
//}
//
//var spend = 帳目(用途: "Costco 採買", 費用: 2000)
//print(spend.用途, spend.費用)
//spend.費用 = 3000
//spend.用途 = "Costco 採買 + 吃東西"
//
//print(spend.$用途)



//@propertyWrapper
//struct Validation {
//    // 私有變數 text，用來存儲包裝的實際值。
//    private var text: String
//    // 私有變數 defaultValue，用來存儲默認值。
//    private var defaultValue: String
//    // 計算屬性 isValue，返回布爾值，表示 text 是否非空。
//    var isValue: Bool {
//        !text.isEmpty
//    }
//    // 定義被包裝的屬性 wrappedValue。
//    var wrappedValue: String {
//        get {// 當獲取 wrappedValue 時執行。
//            // 如果 text 為空，返回 defaultValue，否則返回 text。
//            text.isEmpty ? defaultValue : text
//        }
//        set {
//            // 當設置 wrappedValue 時執行。
//            // 將新值賦給 text。
//            text = newValue
//        }
//    }
//    // 定義投影值，返回自身實例。
//    var projectedValue: Self { self }
//    // 初始化方法，接受初始值和默認值。
//    init(wrappedValue: String, defaultValue: String) {
//        // 將初始值賦給 text。
//       text = wrappedValue
//        // 將默認值賦給 defaultValue。
//        self.defaultValue = defaultValue
//    }
//}
//
//struct User {
//    // 使用 Validation 屬性包裝器來包裝 name 屬性，設置默認值為 "未命名的使用者"，初始值為空字符串。
//    @Validation(defaultValue: "未命名的使用者") var name: String = ""
//    
//    func greeting() {
//        print("你好", name, terminator: " ")
//        // 檢查 name 的 isValue 是否為 false。
//        if (!$name.isValue) {
//            print("獲得折扣碼")
//        } else {
//            print("請設定姓名獲得折扣碼")
//        }
//    }
//}
//
//var user = User()
//user.greeting()
//user.name = "Jane"
//user.greeting()





//⚠️ 請用 shift + commend + option + V 貼上才能維持文件的縮排。
//💡 在 playground 中，從上方選單選 Editor > Show Rendered Markup 可以讓題目看起來更清楚一些。
/*:
### 【ChaoCode】 Swift 中級篇 3：Property Wrapper 作業
 ---
1. 設定一個名為 Trimmed 的屬性包裝，功能是把文字的前後空白或換行移除。
    * 限制：wrappedValue 需為儲存屬性（Stored Property）。
    * 💡 你可以使用 String 裡的 .trimmingCharacters 方法。
 ---
*/
import Foundation

@propertyWrapper
struct Trimmed {
    var wrappedValue: String {
        didSet {
            wrappedValue = wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

/*:
---
2. 設定一個名為 Log 的屬性包裝，功能是在每次存取或是更改時印出通知。
    * 可搭配任何屬性使用，需要提供一個名為「描述」的 String 參數。
    * 在存取時印出「🔍 存取\(描述)...」
    * 在修改時印出「✏️ \(描述)的值改為 ＯＯＯ」
    * 請定義 init 啟動方法，請勿修改下方提供的參數名稱和引數名稱。
 ---
*/
@propertyWrapper
struct Log<T> {
    // 私有變數 value，用來存儲包裝的實際值。
    private var value: T
    // 私有變數 描述，用來存儲屬性描述信息。
    private var 描述: String
    // 定義被包裝的屬性 wrappedValue。
    var wrappedValue: T {
        get {// 當獲取 wrappedValue 時執行。
            print("🔍 存取\(描述)...")
            return value
        }
        set {// 當設置 wrappedValue 時執行。
            print("✏️ \(描述)的值改為 \(newValue)")
            // 將新值賦給 value。
            value = newValue
        }
    }
    // 初始化方法，接受初始值和描述信息。
    init(wrappedValue: T, 描述: String) {
        // 將描述信息賦給 描述 變數。
        self.描述 = 描述
        // 將初始值賦給 value 變數。
        self.value = wrappedValue
    }
}

/*:
 ---
 3. 設定一個名為 Percentage 的屬性包裝，功能是把 Double 數字，透過 projectedValue 用百分比的文字顯示。
    - 需要提供一個名為「小數點位數」的 Int 參數，預設為 2，以該位數四捨五入後顯示，小數點位數不應小於 2。
        ```
         例如：0.18532 小數點位數小於 2 位數都應顯示 18%；小數點位數 3 位應顯示 18.5%。
        ```
    - 請使用 NumberFormatter 或 .formatted 來處理進位和文字轉換。
    - 使用 swift 自動產生的啟動，不自行定義 init。並確保以下兩種提供 wrappedValue 的方式都能執行。
        ```
        @Percentage(小數點位數: 3) var a = 0.2231
        @Percentage(wrappedValue: 0.338, 小數點位數: 3) var b
        ```
 ---
 */
@propertyWrapper
struct Percentage {
    var wrappedValue: Double
    // 定義投影值屬性 projectedValue，類型為 String。
    var projectedValue: String {
        // 計算有效的小數點位數，最小為 0。如果小數點位數設為 2，則 digits 為 0。
        let digits = max(0, 小數點位數 - 2)
        let string = wrappedValue
            .formatted(// 使用 Swift 的格式化 API 將 wrappedValue 格式化為百分比字符串。
                // .percent 表示百分比格式。
                .percent
                // .scale(100) 表示將數值乘以 100（例如 0.25 會變成 25）。
                    .scale(100)
                // .rounded(rule: .toNearestOrAwayFromZero) 表示四捨五入規則。
                    .rounded(rule: .toNearestOrAwayFromZero)
                // .precision(.fractionLength(digits)) 表示小數點後保留的位數。
                    .precision(.fractionLength(digits)))
        return string
    }
    // 定義一個私有變數 小數點位數，初始值為 2，表示默認小數點位數為 2。
    private(set) var 小數點位數 = 2
}



// ⚠️ 這次的測試需要跟你的 property wrapper 在同一個檔案中。請自行把要測試的 code 貼回你的作業下方測試。你要全放到最下方或是一個一個單獨測試都可以。
// ⚠️ 每個 struct 代表一個測試，直接呼叫他的靜態方法 .check() 即可檢查。

// 1️⃣
struct TrimTest {
    @Trimmed var input: String

    static func check() {
        let testCases: [(test: String, answer: String)] = [
            ("\n \t  Hello, \nWorld  \n", "Hello, \nWorld"),
            (" 　你好世界。", "你好世界。"),
            ("Hello~~", "Hello~~"),
            ("         \n\n\n\n", ""),
            ("🐶     ", "🐶"),
        ]
        for (string, answer) in testCases {
            let testCase = TrimTest(input: string)
            guard testCase.input == answer  else {
                print("❌「\(string)」應該被儲存為「\(answer)」，但您的結果為「\(testCase.input)」")
                return
            }
        }

        var trimmed = TrimTest(input: "")
        for (string, answer) in testCases {
            trimmed.input = string
            guard trimmed.input == answer  else {
                print("❌「\(string)」應該被儲存為「\(answer)」，但您的結果為「\(trimmed.input)」")
                return
            }
        }

        print("✅ 您的 Trimmed 屬性包裝沒有問題。")
    }
}
//
//
// 2️⃣
struct LogTest {
    static func check() {
        print("⚠️ 請自行比對以下 print 內容是否正確，如果儲存的值沒有修改會報錯。")
        
        let answer1 = Date(timeIntervalSince1970: 1)
        print("測試 1：應印出 \(answer1)")
        let test1 = LogTestModel(description: "日期", from: Date.now, to: answer1)
        assert(test1.data == answer1, "⚠️ set 沒有正確修改到儲存的值哦")
        
        let answer2 = (802, "苓雅區")
        print("測試 2：應印出 \(answer2)")
        let test2 = LogTestModel(description: "郵遞區號", from: (100, "中正區"), to: answer2)
        assert(test2.data == answer2, "⚠️ set 沒有正確修改到儲存的值哦")
    }

    struct LogTestModel<T> {
        @Log var data: T
        var secondValue: T

        init(description: String, from data: T, to secondValue: T) {
            _data = .init(wrappedValue: data, 描述: description)
            self.secondValue = secondValue
            self.data = secondValue
        }
    }
}
//
//
// 3️⃣
struct PercentTest {
    @Percentage var defaultDigitTest: Double
    @Percentage var customDigitTest: Double

    init(number: Double, digits: Int) {
        defaultDigitTest = number
        _customDigitTest = .init(wrappedValue: number, 小數點位數: digits)
    }

    static func check() {
        let testCases: [(number: Double, digits: Int, defaultAnswer: String, customAnswer: String)] = [
            // 測整數
            (1, 2, "100%", "100%"),
            (2, 2, "200%", "200%"),
            (-1, 2, "-100%", "-100%"),
            (1.999, 2, "200%", "200%"),
            // 測小數四捨五入
            (0.2345, 3, "23%", "23.5%"),
            (0.8712, 3, "87%", "87.1%"),
            (0, 3, "0%", "0.0%"),
            (0.1234, 4, "12%", "12.34%"),
            (0.12345, 4, "12%", "12.35%"),
            (-0.123, 4, "-12%", "-12.30%"),
            (-0.09756, 4, "-10%", "-9.76%"),
            // 測小數位數小於 2
            (-1, 1, "-100%", "-100%"),
            (0, 0, "0%", "0%"),
            (-0.881, -2, "-88%", "-88%"),
            (0.7787, -3, "78%", "78%"),
        ]

        for (number, digits, defaultAnswer, customAnswer) in testCases {
            let testCase = PercentTest(number: number, digits: digits)
            guard testCase.$defaultDigitTest == defaultAnswer else {
                print("❌ 兩位小數的 \(number) 應顯示為 \(defaultAnswer)，而您的結果是「\(testCase.$defaultDigitTest)」")
                return
            }
            guard testCase.$customDigitTest == customAnswer else {
                print("❌ \(digits) 位小數的 \(number) 應顯示為 \(customAnswer)，而您的結果是「\(testCase.$customDigitTest)」")
                return
            }
        }

        print("✅ 您的 Percentage 屬性包裝沒有問題。")
    }
}
//
//
// 👇 下面這幾行會執行測試。
TrimTest.check()
print("-------------------")
LogTest.check()
print("-------------------")
PercentTest.check()
