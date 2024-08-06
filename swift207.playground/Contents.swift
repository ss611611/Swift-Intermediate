// 建立 Protocol & 提供通用方法

//struct 寶可夢: 可戰鬥 {
//    var name: String = "某個寶可夢"
//    var hp: Int = 50
//    var 最大hp: Int = 50
//    var 攻擊力: Int = 5
//    var 等級: Int = 1
// 
//}
//
//
//struct 邪惡外星人: 可戰鬥 {
//    var name: String = "某個邪惡外星人"
//    var hp: Int = 60
//    var 最大hp: Int = 60
//    var 攻擊力: Int = 7
//    var 等級: Int = 1
//}
//
//
//
//var 皮卡丘 = 寶可夢(name: "皮卡丘")
//var 可達鴨 = 寶可夢(name: "可達鴨")
//var 外星人 = 邪惡外星人()
//
//皮卡丘.升級()
//外星人.升級()
//
//皮卡丘.攻擊(on: &外星人)
//可達鴨.攻擊(on: &皮卡丘)
//可達鴨.攻擊(on: &外星人)


// Protocol 中的 associatedtype

//struct 絕地武士: 可戰鬥 {
//    enum 階級: Int, Strideable, CustomStringConvertible {
//        var description: String {
//            switch self {
//            case .幼徒:
//                return "幼徒"
//            case .學徒:
//                return "學徒"
//            case .絕地武士:
//                return "絕地武士"
//            case .大師:
//                return "大師"
//            case .宗師:
//                return "宗師"
//            }
//        }
//        
//        case 幼徒, 學徒, 絕地武士, 大師, 宗師
//        func distance(to other: 絕地武士.階級) -> Int {
//            other.rawValue - self.rawValue
//        }
//        
//        func advanced(by n: Int) -> 絕地武士.階級 {
//            let level = rawValue + n
//            return 階級.init(rawValue: level) ?? .宗師
//        }
//    }
//    
//    var name: String = "某個絕地武士"
//    var hp: Int = 100
//    var 最大hp: Int = 60
//    var 攻擊力: Int = 5
//    var 等級: 階級 = .幼徒
//}
//
//
//struct 寶可夢: 可戰鬥 {
//    var name: String = "某個寶可夢"
//    var hp: Int = 50
//    var 最大hp: Int = 50
//    var 攻擊力: Int = 5
//    var 等級: Int = 1
//
//}
//
//
//var 武士 = 絕地武士()
//武士.升級()
//武士.升級()
//武士.升級()
//var 皮卡丘 = 寶可夢(name: "皮卡丘")
//武士.攻擊(on: &皮卡丘)



//protocol HasName {
//    var name: String { get }
//}
//
//
//protocol HasAddress {
//    var address: String { get }
//}
//
//
//let array: [ HasName & HasAddress] = []





//【ChaoCode】 Swift 中級篇 7：Protocol 實作作業 A
// ✨ 請閱讀完整份內容，了解使用情境後，跟著以下步驟設計一個能管理兩種隊伍的 protocol。
// 1️⃣ 請設計一個名為「有優先隊伍」的 protocol。
// ＊ conforms to 這個 protocol 的資料會有兩種隊伍，一種是優先隊伍、另一種是一般隊伍，並且知道要如何判斷什麼樣的資料能進優先隊伍。
// ＊ 這個 protocol 會提供兩種方法：
//      1. 第一種是「add」，它會接收「一個隊伍內容的參數」，並把他新增到合適的隊伍中。
//      2. 第二種是「next」，它不需要任何參數，會回傳一個 optional 的隊伍內容。假如兩個隊伍都是空的就回傳 nil。如果優先隊伍有人，就回傳優先隊伍的第一位，否則回傳一般隊伍的第一位。回傳之前記得刪除隊列內的資料並且印出下一位的資訊。

protocol 有優先隊伍 {
    // 定義一個關聯型別 `排隊內容`，表示隊伍中的內容類型。
    associatedtype 排隊內容
    // 定義一個變數 `一般隊伍`，用來存放一般隊伍中的內容。
    var 一般隊伍: [排隊內容] { get set }
    // 定義一個變數 `優先隊伍`，用來存放優先隊伍中的內容。
    var 優先隊伍: [排隊內容] { get set }
    
    // 定義一個靜態方法 `優先判斷`，用來判斷某個內容是否應該進入優先隊伍。
    static func 優先判斷(_: 排隊內容) -> Bool
}

extension 有優先隊伍 {
    // 定義一個可變方法 `add`，用來向隊伍中添加內容。
    mutating func add(_ 內容: 排隊內容) {
        // 根據 `優先判斷` 方法的結果將內容添加到相應的隊伍中。
        switch Self.優先判斷(內容) {
        case true:  // 如果內容應該進入優先隊伍，則將其添加到優先隊伍。
            優先隊伍.append(內容)
        case false: // 否則，將其添加到一般隊伍。
            一般隊伍.append(內容)
        }
    }
    
    // 定義一個可變方法 `next`，用來從隊伍中取出下一個內容。
    mutating func next() -> 排隊內容? {
        // 如果優先隊伍中有內容，則取出並返回優先隊伍中的第一個內容。
        if let next = 優先隊伍.first {
            print(">> 下一位是優先隊伍的 \(next)")
            return 優先隊伍.removeFirst()
        }
        
        // 如果一般隊伍中有內容，則取出並返回一般隊伍中的第一個內容。
        if let next = 一般隊伍.first {
            print(">> 下一位是一般隊伍的 \(next)")
            return 一般隊伍.removeFirst()
        }
        
        // 如果兩個隊伍中都沒有內容，返回 nil。
        print("目前沒有下一位了")
        return nil
    }
}


// ✋ 請勿修改玩家和病患這兩個類型。
struct 玩家: CustomStringConvertible {
    var 名字: String
    var 有快速通關: Bool
    var description: String { 名字 }
}

struct 病人: CustomStringConvertible {
    var 名字: String
    var 是急診: Bool
    var description: String { 名字 }
}

// 2️⃣ 請完成以下這兩個 struct，讓他們能 conforms to 你設計的「有優先隊伍」。
// ＊ 遊樂設施中的排隊內容會是玩家，有快速通關的可以進到優先隊伍；診所的排隊內容會是病人，是急診的會進到優先隊伍。
// ＊ 請確保它們都可以不輸入任何參數啟動（不輸入啟動時隊伍都會是空的）。
struct 遊樂設施: 有優先隊伍 {
    // 定義 `一般隊伍` 和 `優先隊伍`，並初始化為空數組。
    var 一般隊伍: [玩家] = []
    var 優先隊伍: [玩家] = []
    
    // 定義靜態方法 `優先判斷`，用來判斷玩家是否有快速通關。
    static func 優先判斷(_ 玩家: 玩家) -> Bool { 玩家.有快速通關 }
}

struct 診所: 有優先隊伍 {
    // 定義 `一般隊伍` 和 `優先隊伍`，並初始化為空數組。
    var 一般隊伍: [病人] = []
    var 優先隊伍: [病人] = []
    
    // 定義靜態方法 `優先判斷`，用來判斷病人是否是急診。
    static func 優先判斷(_ 病人: 病人) -> Bool { 病人.是急診 }
}


// 3️⃣ 下面是測試，請勿修改。
var 大怒神 = 遊樂設施()
var allPlayer: [玩家] = [.init(名字: "約翰", 有快速通關: false), .init(名字: "馬可", 有快速通關: false), .init(名字: "亞妮", 有快速通關: true), .init(名字: "艾連", 有快速通關: false), .init(名字: "米卡莎", 有快速通關: false), .init(名字: "阿爾敏", 有快速通關: false), .init(名字: "萊納", 有快速通關: true), .init(名字: "柯尼", 有快速通關: false), .init(名字: "莎夏", 有快速通關: false), .init(名字: "貝爾托特", 有快速通關: true), .init(名字: "法蘭茲", 有快速通關: false), .init(名字: "漢娜", 有快速通關: false), .init(名字: "尤米爾", 有快速通關: true), .init(名字: "希斯特莉亞", 有快速通關: true)]

print("🎢 遊樂園測試...")
while !allPlayer.isEmpty {
    let nextGroup = allPlayer.prefix(2)
    nextGroup.forEach { _ in 大怒神.add(allPlayer.removeFirst()) }
    
    大怒神.next()
}

var 皮膚科 = 診所()
var allPatients: [病人] = [.init(名字: "艾維", 是急診: true),.init(名字: "萊拉", 是急診: false),.init(名字: "泰勒", 是急診: false),.init(名字: "格雷森", 是急診: false),.init(名字: "艾登", 是急診: false),.init(名字: "安娜", 是急診: false),.init(名字: "金斯頓", 是急診: false),.init(名字: "埃莉諾", 是急診: false),.init(名字: "艾莉", 是急診: true),.init(名字: "阿貝爾", 是急診: false),.init(名字: "亞瑟", 是急診: true)]

print("🏥 看診測試...")
while !allPatients.isEmpty {
    let nextGroup = allPatients.prefix(2)
    nextGroup.forEach { _ in 皮膚科.add(allPatients.removeFirst()) }
    
    皮膚科.next()
}



//【ChaoCode】 Swift 中級篇 7：Protocol 實作作業 B
// ✨ 請閱讀完整份內容，了解使用情境後，請跟著以下步驟完成這題。你會需要新增你自訂的 protocol、調整現有的類型和完成設計「載客管理員」，最後讓測試的 code 能順利執行。
// 1️⃣ 請閱讀以下這三種類型，稍後你會需要回來調整它們。這三種交通工具「汽車、機車、直升機」都已設計完成，它們都有共同的屬性、都 conforms to CustomStringConvertible，並且都用同樣的方式計算抵達目的地的時間。

protocol 可載客: CustomStringConvertible {
    var 牌號: String { get }
    var 最大乘客數: Int { get }
    var 時速: Double { get }
    
    static var 交通工具名稱: String { get }
}

extension 可載客 {
    // 實現 `description` 屬性，返回交通工具的名稱和牌號。
    var description: String { "\(Self.交通工具名稱)牌號「\(牌號)」" }

    // 定義一個方法 `計算時間`，用來計算到目的地所需的時間（以分鐘為單位）。
    func 計算時間(目的地距離: Double) -> Int {
        let time = 目的地距離 / 時速
        let min = time * 60
        
        return Int(min)
    }
}

struct 汽車: 可載客 {
    var 最大乘客數: Int = 4
    var 牌號: String
    var 時速: Double
    
    static var 交通工具名稱 = "🚘 汽車"
    
}

struct 機車: 可載客 {
    let 最大乘客數: Int = 2
    var 牌號: String
    let 時速: Double

    static var 交通工具名稱 = "🛵 機車"
}

struct 直升機: 可載客 {
    let 最大乘客數: Int = 4
    var 牌號: String
    var 時速: Double

    static var 交通工具名稱 = "🚁 直升機"
}

// 2️⃣ 以下這個類型「載客管理員」，有一個儲存屬性「可用載客車」，它是一個 Array，裡面存放的是現在可以提供載客服務的交通工具。

struct 載客管理員 {
    // 3️⃣ 請讓這個「可用載客車」的 Array 可以放入上面建立的三種交通工具。你會需要編輯上面的 struct，但請確保他們被印出來時顯示的內容還是一樣，並且都能計算時數。（沒有限制如何調整，但請至少用到一個 protocol 來解決這個問題）
    // ⚠️ 為了後面能執行測試，修改時請勿調整上面三個和這個 struct 中儲存屬性的順序和名稱，也不要自訂 init。
    
    // 定義屬性 `可用載客車`，用來存放可用的載客車輛數組。
    var 可用載客車: [可載客]
    
    // 4️⃣ 請設計派車方法，請勿修改名稱和參數，但需要放入回傳類型。
    // 請從可用載客車中依序找出第一台合適的交通工具，只要能滿足乘載要求的人數即可。假如沒有合適的交通工具就回傳 nil，有的話則把這台交通工具從隊列中移除，並且回傳這台交通工具。回傳之前請根據情況印出派車資訊。
    
    // 定義一個可變方法 `派車`，用來派出合適的載客車輛。
    mutating func 派車(人數: Int, 客人距離: Double) -> 可載客? {
        // 如果沒有找到合適的車輛，打印提示信息並返回 nil。
        guard let carIndex = (可用載客車.firstIndex { $0.最大乘客數 >= 人數 }) else {
            print("😣 很抱歉，目前沒有車輛。請稍後再試。")
            return nil
        }
        
        // 獲取找到的合適車輛。
        let car = 可用載客車[carIndex]
        // 計算車輛到達客人位置所需的時間。
        let time = car.計算時間(目的地距離: 客人距離)
        print("\(car)正在前往您的地點，預計 \(time) 分鐘後抵達。")
        // 返回找到的車輛，並從可用車輛列表中移除。
        return 可用載客車.remove(at: carIndex)
    }
}


// 5️⃣ 以下為測試內容，請勿刪除和修改。

var carManager = 載客管理員(可用載客車: [汽車(最大乘客數: 4, 牌號: "TDG-1688", 時速: 80), 機車(牌號: "LKK-0057", 時速: 60), 機車(牌號: "AWJ-0020", 時速: 60), 汽車(最大乘客數: 3, 牌號: "TDZ-2096", 時速: 80), 汽車(最大乘客數: 5, 牌號: "TRT-4042", 時速: 70), 機車(牌號: "LMI-0009", 時速: 80), 直升機(牌號: "B-70331", 時速: 293), 汽車(最大乘客數: 5, 牌號: "TJU-2244", 時速: 60), 汽車(最大乘客數: 4, 牌號: "TTN-6433", 時速: 80), 汽車(最大乘客數: 4, 牌號: "THK-9005", 時速: 85), 機車(牌號: "PXP-2273", 時速: 55), 機車(牌號: "VOJ-3635", 時速: 80), 機車(牌號: "CDH-1960", 時速: 60), 汽車(最大乘客數: 3, 牌號: "TFJ-6039", 時速: 65), 汽車(最大乘客數: 3, 牌號: "TNK-0880", 時速: 85), 機車(牌號: "UUE-2080", 時速: 50), 機車(牌號: "VCE-8777", 時速: 75), 機車(牌號: "BBD-3494", 時速: 60), 汽車(最大乘客數: 6, 牌號: "TLZ-7005", 時速: 75), 汽車(最大乘客數: 4, 牌號: "TWE-5773", 時速: 60), 直升機(牌號: "B-70921", 時速: 301), 機車(牌號: "HHC-2069", 時速: 60), 機車(牌號: "ROW-4209", 時速: 65)])

print("""
目前可用載客車共 \(carManager.可用載客車.count) 台:
\(carManager.可用載客車.map{ String(describing: $0) }.joined(separator: "、"))
-----------------------------------------
""")

carManager.派車(人數: 1, 客人距離: 10.9)
carManager.派車(人數: 5, 客人距離: 80.2)
carManager.派車(人數: 7, 客人距離: 5.3)
carManager.派車(人數: 2, 客人距離: 9.2)
carManager.派車(人數: 6, 客人距離: 2.1)
carManager.派車(人數: 2, 客人距離: 0.7)
carManager.派車(人數: 1, 客人距離: 18.5)
carManager.派車(人數: 4, 客人距離: 38.6)
carManager.派車(人數: 4, 客人距離: 7.3)
carManager.派車(人數: 1, 客人距離: 222)
