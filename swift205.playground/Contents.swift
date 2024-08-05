// Optional

//let number = Optional<Int>.none
//let number2 = Int?.some(5)
//let number3: Int? = nil
//let number4: Int? = 9
//
//let array = [number, number2, number3, number4]
//
//for number in array {
//    switch number {
//    case .none:
//        print("沒有數字")
//    case .some(let wrapped):
//        print("數字 \(wrapped)")
//    }
//}


//let name: String? = nil
//if let name = name {
//    print("Hello \(name)")
//}
//
//func greeting(_ name: String?) {
//    guard let name = name else {
//        return
//    }
//    print("你好 \(name)")
//}
//
//greeting(name)
//greeting("Sandy")

//let 姓氏: String? = "Chao"
//let 名字: String? = "Jane"
//if let 姓氏 = 姓氏, let 名字 = 名字 {
//    print("Hello \(姓氏)\(名字)")
//}


//struct 個人檔案 {
//    let 名稱: String
//    let 電話: String?
//}
//
//let profile: 個人檔案? = .init(名稱: "Jane", 電話: "0988999222")
//
//if let phoneNumber = profile?.電話 {
//    print(phoneNumber)
//}








// 【ChaoCode】 Swift 中級 5：Optional 實作作業

// 這次作業有兩段，請跟著數字完成。第一段請先完成設計客戶資料的「屬性」，第二段請在下方找出要求的資料。
// ⚠️ 請不要使用 if 或 switch 語法。請使用這堂課教的 Optional 語法。（可以用 if let，它是 Optional 語法）

import Foundation

struct 客戶資料: Codable { // 請勿移除 Codable，此為讀取資料用
    // ✋ 請勿修改或新增儲存屬性
    let 姓氏: String?
    let 名字: String
    let 生日: 日期?
    
    let 郵遞區號: Int?
    let 城市: String?
    let 街道地址: String?
    
    let 備註: String?
    
    // 👇 請由此處開始設計以下「計算屬性」，請勿修改變數名稱。
    // 1️⃣ 姓名是姓氏和名字結合的 String，如沒有姓氏則直接印出名字
    var 姓名: String? { (姓氏 ?? "") + 名字 }
    
    // 2️⃣ 地址是由郵遞區號、城市和街道地址結合的 String。客戶可能沒有填寫全部欄位，只顯示有寫的部分即可。若完全沒有任何地址資訊則回傳 nil。
    var 地址: String? {
        let address = (郵遞區號?.description ?? "") + (城市 ?? "") + (街道地址 ?? "")
        return address.isEmpty ? nil : address
    }
    
    // 3️⃣ 請使用日期中的靜態屬性「today」計算年紀（Int），年紀用年份相減即可。如果沒有生日資料則回傳 nil。
    var 年紀: Int? {
        guard let birthday = 生日 else { return nil }
        return 日期.today.year - birthday.year
    }
    
    // 4️⃣ 請使用日期中的靜態屬性「today」檢查客戶是否為本月壽星。如果沒有生日資料則直接回傳 false。
    var 是本月壽星: Bool {
        guard let birthday = 生日 else { return false }
        return 日期.today.month == birthday.month
    }
}

// ✋ 請勿編輯此 struct
struct 銷售紀錄: Codable {
    let 訂單編號: Int
    let 消費金額: Int
    let 客戶資料: 客戶資料?
    let 備註: String?
    
    static func 取得本月資料() -> [銷售紀錄]? {
        guard let url = Bundle.main.url(forResource: "swift205_sellData", withExtension: "dta") else {
            print("❌ 無法讀取資料，請確認是否已經把「swift205_sellData.dta」檔案放入 Resources")
            return nil
        }
        
        guard let data = try? Data(contentsOf: url),
              let array = try? JSONDecoder().decode([銷售紀錄].self, from: data) else {
            print("❌ 無法分析資料，請確認是否有誤把「Codable」這個 Protocol 刪掉")
            return nil
        }
        
        return array
    }
}



func 尋找資料(本月銷售資料: [銷售紀錄]?) {
    // 👇 請由此處繼續編輯，根據敘述印出需要的內容，請嘗試至少使用一次 .compactMap()。
    // 5️⃣ 請找出在本月銷售資料中，年紀大於或等於 30 歲的客戶共有幾位。
    let ageOver30 = 本月銷售資料?.filter{ ($0.客戶資料?.年紀 ?? 0) >= 30 }.count ?? 0
    print("📊 大於 30 歲的客戶共 \(ageOver30) 位")
    
    // 6️⃣ 請找出在本月銷售資料中，這個月生日的客戶共有幾位，並印出他們的姓名、年齡和地址。如沒有地址資料則印出「無地址」。
    let isBirthday = 本月銷售資料?.compactMap(\.客戶資料).filter{ $0.是本月壽星 }
    print("🥳 本月壽星共 \(isBirthday?.count ?? 0) 位")
    isBirthday?.forEach {
        print("🎂 \($0.姓名) \($0.年紀!) 歲生日，地址：\($0.地址 ?? "無地址")")
    }
    
    // 7️⃣ 請使用「if let」語法，印出所有訂單的備註和客戶資料的備註。
    本月銷售資料?.forEach{ record in
        if let note = record.備註 {
            print("🛒 訂單 \(record.訂單編號) 備註：", note)
        }
        if let client = record.客戶資料, let note = client.備註 {
            print("📝 顧客 \(client.名字) 備註： \(note)")
        }
    }
}

// ✋ 以下為測試，請勿編輯
print("———————— 測試 nil 資料...")
尋找資料(本月銷售資料: nil)
print("———————— 測試正常資料...")
尋找資料(本月銷售資料: 銷售紀錄.取得本月資料())






public struct 日期: Codable {
    public let year: Int
    public let month: Int
    public let day: Int
    
    public static let today = 日期(year: 2022, month: 5, day: 15)
}
