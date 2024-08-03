// Enum
//enum 季節: String, CaseIterable, CustomStringConvertible {
//    var description: String {
//        rawValue
//    }
//    
//    case spring, summer, fall, winter
//}
//
//let season = 季節.summer
//print(season)
//print(季節.allCases)


// 定義一個枚舉類型 會員等級，並遵循 String、CaseIterable 和 CustomStringConvertible 協議。
//enum 會員等級: String, CaseIterable, CustomStringConvertible {
//    
//    case 免費會員, 銀卡會員, 金卡會員
//    
//    enum 權限: String, CaseIterable {
//        case 觀看舊片, 跳過廣告, 下載影片, 觀看新片
//    }
//    
//    var 費用: Int {
//        switch self {
//        case .免費會員:
//            return 0
//        case .銀卡會員:
//            return 250
//        case .金卡會員:
//            return 400
//        }
//    }
//    // 遵循 CustomStringConvertible 協議，返回會員等級的字符串描述。
//    var description: String { rawValue }
//    
//    func 可以使用(_ 權限: 權限) -> Bool {
//        switch self {
//        case .免費會員:
//            return 權限 == .觀看舊片
//        case .銀卡會員:
//            return 權限 != .觀看新片
//        case .金卡會員:
//            return true
//        }
//    }
//    static let 所有的會員類型 = 會員等級.allCases.map(\.rawValue).joined(separator: "、")
//}
//
//
//print("你好，請選擇你要加入的會員類型：\(會員等級.所有的會員類型)")
//let myMembership = 會員等級.allCases.randomElement()!
//print("歡迎加入\(myMembership)")
//會員等級.權限.allCases.forEach {
//    // 判斷當前會員等級是否可以使用該權限。
//    let isAllowed = myMembership.可以使用($0)
//    print(isAllowed ? "您可以 \($0.rawValue)" : "\(myMembership) 無法 \($0.rawValue)")
//}



//enum 性別: CaseIterable, CustomStringConvertible, RawRepresentable {
//    case 生理男, 生理女, 其他(描述: String = "其他")
//
//    init(rawValue: String) {
//        switch rawValue {
//        case "生理男":
//            self = .生理男
//        case "生理女":
//            self = .生理女
//        default:
//            self = .其他(描述: rawValue)
//        }
//    }
//    
//    var rawValue: String {
//        switch self {
//        case .生理男:
//            return "生理男"
//        case .生理女:
//            return "生理女"
//        case .其他(let 描述):
//            return 描述
//        }
//    }
//    
//    var description: String {
//        rawValue
//    }
//    
//    static var allCases: [性別] = [.生理男, .生理女, .其他()]
//
//}
//
//print(性別.生理女)
//print(性別.其他(描述: "酷兒"))
//print(性別.其他())
//print(性別.allCases)
//性別.init(rawValue: "不知道")
//性別.init(rawValue: "生理男")



/*:### 【ChaoCode】 Swift 中級 4：Enum 實作作業
 ---
 1. 建立一個名為「感情狀態」的 enum。
 * 一共有五種選項：單身、穩定交往中、已婚、開放式關係、一言難盡。
 * 穩定交往和結婚需要輸入伴侶名字。
 * 調整這個類型被印出來時顯示的文字，如果是穩定交往或是已婚需要顯示對象。
 ```
 例如：和小白穩定交往中。
 ```
 ---
 */
enum 感情狀態: CustomStringConvertible {
    case 單身, 穩定交往中(伴侶: String), 已婚(伴侶: String), 開放式關係, 一言難盡
    
    var description: String {
        switch self {
        case .單身:
            return "單身"
        case .穩定交往中(let 伴侶):
            return "與 \(伴侶) 穩定交往中"
        case .已婚(let 伴侶):
            return "與 \(伴侶) 結婚"
        case .開放式關係:
            return "開放式關係"
        case .一言難盡:
            return "一言難盡"
        }
    }
}


// 👇 請勿刪除下面的 print，你需要讓它們可以正常執行，請自行確認結果是否如同預期。
print(感情狀態.單身)
print(感情狀態.一言難盡)
print(感情狀態.開放式關係)
print(感情狀態.已婚(伴侶: "結衣"))
print(感情狀態.穩定交往中(伴侶: "哈利"))

/*:
 ---
 2. 請根據下列需求設計以下兩個 enum 和一個 struct。
 * 讓 Card 根據大老二的規則比大小（Comparable）。\
 ```- 先比數字大小，數字一樣時再比花色。```\
 ```- 數字大小 2 > ace > king> queen> jack > 10, 9, 8, 7, 6, 5, 4, 3```\
 ```- 同數字時比較花色，黑桃 > 紅心 > 方塊 > 梅花```
 * 讓 Card 被印出來時印出花色表情 + 全形文字。對印文字如下：\
 ```花色：黑桃 ♠️、紅心 ♥️、方塊 ♦️、梅花 ♣️```\
 ```數字：Ａ、２、３、４、５、６、７、８、９、１０、Ｊ、Ｑ、Ｋ```
 * 請勿修改 case 名稱（你可以調整順序）和屬性名稱，也不要增加自訂的啟動方式。
 ```
 例如：紅心 12 應印出♥️Ｑ
 ```
 ---
 */

enum 卡牌花色: Int, Comparable {
    // 定義四種卡牌花色：梅花、方塊、紅心和黑桃，並分別賦予整數值 0、1、2 和 3。
    case 梅花, 方塊, 紅心, 黑桃
    
    var emoji: String {
        switch self {
            case .梅花: return "♣️"
            case .方塊: return "♦️"
            case .紅心: return "♥️"
            case .黑桃: return  "♠️"
        }
    }
    // 實現 Comparable 協議所需的 < 操作符，用於比較兩個卡牌花色的大小。
    static func < (lhs: 卡牌花色, rhs: 卡牌花色) -> Bool {
        // 比較兩個花色的原始值（整數），左邊的小於右邊的則返回 true，否則返回 false。
        lhs.rawValue < rhs.rawValue
    }
}

enum 卡牌數字: Int, Comparable, CustomStringConvertible {
    static func < (lhs: 卡牌數字, rhs: 卡牌數字) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    // 定義十三種卡牌數字，並分別賦予整數值 0 到 12。
    case three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace, two
    
    // 實現 CustomStringConvertible 協議所需的 description 屬性，返回對應數字的字符串表示。
    var description: String {
        switch self {
        case .ace: return "Ａ"
        case .two: return "２"
        case .three: return "３"
        case .four: return "４"
        case .five: return "５"
        case .six: return "６"
        case .seven: return "７"
        case .eight: return "８"
        case .nine: return "９"
        case .ten: return "１０"
        case .jack: return "Ｊ"
        case .queen: return "Ｑ"
        case .king: return "Ｋ"
        }
    }
}

struct Card: Comparable, CustomStringConvertible {
    var 花色: 卡牌花色
    var 數字: 卡牌數字
    // 實現 Comparable 協議所需的 < 操作符，用於比較兩張卡牌的大小。
    static func < (lhs: Card, rhs: Card) -> Bool {
        // 如果兩張卡牌的數字相同，則比較它們的花色。
        if (lhs.數字 == rhs.數字) {
            return lhs.花色 < rhs.花色
        }
        return lhs.數字 < rhs.數字
    }
    // 實現 CustomStringConvertible 協議所需的 description 屬性，返回卡牌的字符串表示，由花色的表情符號和數字的字符串表示組成。
    var description: String { 花色.emoji + 數字.description }
}





func testCard() {
    let testCases = [(Card(花色: .紅心, 數字: .ace), Card(花色: .黑桃, 數字: .nine), true, "♥️Ａ"),
                     (Card(花色: .梅花, 數字: .two), Card(花色: .梅花, 數字: .queen), true, "♣️２"),
                     (Card(花色: .梅花, 數字: .ace), Card(花色: .梅花, 數字: .three), true, "♣️Ａ"),
                     (Card(花色: .黑桃, 數字: .ten), Card(花色: .黑桃, 數字: .nine), true, "♠️１０"),
                     (Card(花色: .方塊, 數字: .queen), Card(花色: .黑桃, 數字: .ten), true, "♦️Ｑ"),
                     (Card(花色: .梅花, 數字: .king), Card(花色: .紅心, 數字: .king), false, "♣️Ｋ"),
                     (Card(花色: .紅心, 數字: .two), Card(花色: .紅心, 數字: .king), true, "♥️２"),
                     (Card(花色: .梅花, 數字: .six), Card(花色: .梅花, 數字: .ace), false, "♣️６"),
                     (Card(花色: .方塊, 數字: .six), Card(花色: .黑桃, 數字: .two), false, "♦️６"),
                     (Card(花色: .紅心, 數字: .three), Card(花色: .梅花, 數字: .seven), false, "♥️３"),
                     (Card(花色: .紅心, 數字: .five), Card(花色: .黑桃, 數字: .seven), false, "♥️５"),
                     (Card(花色: .梅花, 數字: .ace), Card(花色: .紅心, 數字: .three), true, "♣️Ａ"),
                     (Card(花色: .梅花, 數字: .five), Card(花色: .紅心, 數字: .five), false, "♣️５"),
                     (Card(花色: .方塊, 數字: .king), Card(花色: .黑桃, 數字: .four), true, "♦️Ｋ"),
                     (Card(花色: .梅花, 數字: .ace), Card(花色: .黑桃, 數字: .queen), true, "♣️Ａ"),
                     (Card(花色: .黑桃, 數字: .seven), Card(花色: .方塊, 數字: .seven), true, "♠️７"),
                     (Card(花色: .紅心, 數字: .jack), Card(花色: .梅花, 數字: .eight), true, "♥️Ｊ"),
                     (Card(花色: .方塊, 數字: .jack), Card(花色: .方塊, 數字: .queen), false, "♦️Ｊ"),
                     (Card(花色: .梅花, 數字: .jack), Card(花色: .紅心, 數字: .four), true, "♣️Ｊ")]
    for testCase in testCases {
        if String(describing: testCase.0) != testCase.3 {
            print("❌ 您印出的是\(String(describing: testCase.0))，應印出 \(testCase.3)")
            return
        }
    }
    
    
    for test in testCases {
        if (test.0 > test.1) != test.2 {
            let answer = test.2 ? "小於" : "大於"
            print("❌ \(test.0) 應\(answer) \(test.1)")
            return
        }
    }
    print("✅ 您的卡牌設計沒有問題。")
}
testCard()
