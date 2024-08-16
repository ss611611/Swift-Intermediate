import Foundation

public struct Product: CustomStringConvertible {
    var id: Int
    var title: String
    
    public var description: String { "\(id)：\(title)" }
}

public struct Seat: CustomStringConvertible, Hashable {
    let row: Character
    let number: Int
    
    public var description: String {
        "\(row)\(number)"
    }
    
    public init?(string: String) {
        guard string.count == 2 else { return nil }
        guard let row = string.first,
              let number = Int(String(string.last!)),
              ("A"..."E").contains(row),
              (1...5).contains(number)
            else { return nil }
        self.row = row
        self.number = number
    }
}

public typealias BookingTestCase = (name: String, seat: Seat)

public let bookingTestCases: [BookingTestCase] = [
    ("佩姬", .init(string: "A2")!),
    ("愛德華", .init(string: "A3")!),
    ("貝拉", .init(string: "A4")!),
    ("雷恩", .init(string: "B1")!),
    ("索菲亞", .init(string: "B2")!),
    ("吉兒", .init(string: "B3")!),
    ("彼得", .init(string: "B4")!),
    ("麥特", .init(string: "B5")!),
    ("佩妮", .init(string: "C1")!),
    ("亞歷克斯", .init(string: "C2")!),
]

public let popularSeats: [Seat] = [.init(string: "A1")!, .init(string: "A5")!, .init(string: "E1")!, .init(string: "E5")!]

let productDB = [11: "🎒 小學生萬用後背包", 14: "👟 好走、防潑水、出遊必備步行者專用鞋", 2: "🧢 防曬青春棒球帽", 15: "💄 Dear 經典奢華唇彩 #AppleRed", 4: "👙 經典條紋比基尼", 6: "🧣 歐巴必備時尚圍巾", 7: "💎 絕世美 Queen - 量身打造的客製化珠寶", 16: "🎸 原廠 2 年保固：赤火電吉他", 9: "📱 預計 11 月到貨！myPhone 14", 5: "👔 職場好感度++襯衫", 0: "👓 抗藍光眼鏡", 12: "🥾 玉山先鋒登山鞋", 1: "🕶 捍衛戰士同款太陽眼鏡", 10: "👜 ChaoCode 小羊皮經典手提包", 8: "💍 蒂芙尼完美車工鑽戒", 3: "👗 限時折扣！素面收腰夏日洋裝", 13: "👡 優雅百搭低跟鞋 - 裸色"]

public func getBestSellersID() async -> [Int] {
    print("正在讀取熱門商品 ID...")
    try! await Task.sleep(seconds: 0.5)
    return [3, 1, 15, 10]
}

public func getProduct(id: Int) async  -> Product? {
    print("開始下載 ID \(id) 的商品資料...")
    try! await Task.sleep(seconds: 1)
    guard let title = productDB[id] else { return nil }
    return Product(id: id, title: title)
}

extension Task where Success == Never, Failure == Never {
    public static func sleep(seconds: Double) async throws {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: nanoseconds)
    }
}
