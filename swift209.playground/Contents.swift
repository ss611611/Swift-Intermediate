// Opaque 用途：省略不必要的複雜類型，專注在功能

//let range = 1...1000
//print("類型：", type(of: range))
//let 反過來 = range.reversed()
//print("反過來的類型：", type(of: 反過來))
//let 只要前五個 = 反過來.prefix(5)
//print("只要前五個的類型：", type(of: 只要前五個))
//
//func 從後往前的五個<T: Sequence>(_ sequence: T) -> some Sequence {
//    sequence.reversed().prefix(5)
//}
//
//let result = 從後往前的五個(1...1000)
//
//print(result.map{ String(describing: $0) })

//import Foundation
//
//protocol 有交友資料: Equatable {
//    var 名字: String { get }
//    var 自我介紹: String { get }
//}
//
//struct 高顏值機器人: 有交友資料 {
//    var 名字: String
//    var 自我介紹: String = ""
//    
//    func 發罐頭訊息() {}
//    
//    func 已讀訊息() {}
//}
//
//struct 會員: 有交友資料 {
//    enum 會員類型 { case 普通會員, 享樂會員, 尊榮會員 }
//    
//    var 名字: String
//    var 自我介紹: String = ""
//    
//    var 帳號: String = ""
//    var 手機: String = ""
//    var 生日: Date = .now
//    var 會員類型: 會員類型 = .普通會員
//    
//    var 回應率: Double = 0
//    var 熱門度: Double = 0
//    
//    func 產生每日配對() -> some 有交友資料 {
//        return 高顏值機器人(名字: "愛麗絲") //會員(名字: "湯姆")
//    }
//    
//    func 發訊息<T: 有交友資料>(給 person: T, _ message: String) {
//        print("\(名字) 對 \(person.名字) 說：\(message)")
//    }
//}
//
//
//let user = 會員(名字: "Jane")
//let match = user.產生每日配對()
//user.發訊息(給: match, "Hello")


 
//【ChaoCode】 Swift 中級篇 9 Opaque： 實作作業
//
//: 1. 請把下面這個變數類型變成一個 Opaque 的類型，修改完之後依然可以 loop 自己的 index。
// 👇 請改這變數的「類型定義」就好
let 某種資料: some Collection = [String()].dropFirst().reversed()
某種資料.indices.forEach { _ in } // 這行只是用來檢查你改完之後是否還能 loop 自己的 index


//: 2. 請調整下面的資料，讓最後在操作「呼叫狗狗」和「呼叫貓咪」的時候，只公開他們的名字、打招呼和玩的方法，同時確保「帶大家結紮」依然能正常執行。
protocol 寵物 {
    var 名字: String { get }
    func 打招呼()
    func 玩()
}


struct 狗狗: 寵物 {
    var 名字: String
    var 完成狗狗疫苗接種: Bool
    var 已結紮: Bool
    
    func 打招呼() {
        print("汪汪～")
    }
    func 玩() {
        print("翻肚子🐶")
    }
}

struct 貓咪: 寵物  {
    var 名字: String
    var 完成貓咪疫苗接種: Bool
    var 已結紮: Bool
    
    func 打招呼() {
        print("喵～")
    }
    func 玩() {
        print("征服逗貓棒😼")
    }
}

struct 動物咖啡店 {
    private var 狗狗們: [狗狗] = [.init(名字: "小乖", 完成狗狗疫苗接種: true, 已結紮: false), .init(名字: "皮皮", 完成狗狗疫苗接種: true, 已結紮: true)]
    private var 貓咪們: [貓咪] = [.init(名字: "蛋蛋", 完成貓咪疫苗接種: true, 已結紮: true), .init(名字: "布丁", 完成貓咪疫苗接種: true, 已結紮: false)]
    
    func 呼叫狗狗()  -> some 寵物  {
        let dog = 狗狗們.randomElement()!
        print("✨ \(dog.名字) 來了")
        return dog
    }
    
    func 呼叫貓咪()  -> some 寵物 {
        let cat = 貓咪們.randomElement()!
        print("✨ \(cat.名字) 來了")
        return cat
    }
    
    
    mutating func 帶大家結紮() {
        // 請勿修改這個方法
        狗狗們.indices.forEach { 狗狗們[$0].已結紮 = true }
        貓咪們.indices.forEach { 貓咪們[$0].已結紮 = true }
        print("👍 大家都結紮好了")
    }
}

// ⚠️ 請勿修改下面的 code，請修改完上方的資料後請確認以下內容依然正常執行，並且自行檢查操作「cat」和「dog」時是否只有「名字、玩、打招呼」這三個公開屬性/方法。

var 咖啡店 =  動物咖啡店()
咖啡店.帶大家結紮()

let cat = 咖啡店.呼叫貓咪()
cat.打招呼()
cat.玩()

var dog = 咖啡店.呼叫狗狗()
dog.打招呼()
dog.玩()

