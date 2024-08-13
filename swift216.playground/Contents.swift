// 建立可以拋出錯誤的 function

//import Foundation
//
//enum MathError: LocalizedError, CustomNSError {
//    case cannotDividedEvenly, cannotDividedByZero
//    
//    static var errorDomain: String { "MathError" }
//
//    // 設定錯誤描述：LocalizedError
//    var errorDescription: String? {
//        switch self {
//        case .cannotDividedEvenly: return "無法被整除"
//        case .cannotDividedByZero: return "除數不得為零"
//        }
//    }
//}
//
//extension Int {
//    func dividedEvenly(by factor: Int) throws -> Int {
//        guard factor != .zero else {
//            throw MathError.cannotDividedByZero
//        }
//        guard self % factor == 0 else {
//            throw MathError.cannotDividedEvenly
//        }
//        
//        return self / factor
//    }
//}
//
//
//let number = 3
//let divisors = [2, 0, 3]
//
//divisors.forEach { divisor in
//    print("\(number) / \(divisor)")
//    do {
//        let result = try number.dividedEvenly(by: divisor)
//        print("沒有問題 結果為 \(result)")
//    } catch let error as NSError {
//        print(error)
//        print(error.localizedDescription)
//        print(error.code)
//        print(error.userInfo)
//        print(error.domain)
//    } catch {
//        assertionFailure()
//    }
//}


// 轉發錯誤：rethrows


//let array = [1, 3, 5]
//
//extension Array {
//    func joined(by separtor: String, stringify: (Element) throws -> String) rethrows -> String {
//        try map(stringify).joined(separator: separtor)
//    }
//}
//
//let joinedString = array.joined(by: "、", stringify: \.description)
//print(joinedString)
//let dividedString = try? array.joined(by: "、") {
//    try $0.dividedEvenly(by: 3).description
//}
//print(dividedString)






//【ChaoCode】 Swift 中級篇 16 建立和拋出錯誤 實作作業

// 💡 請依步驟完成「從生日 String 轉成星座」的過程，你可以用任何方式建立你的 Error。

import Foundation

enum 日期轉換錯誤: LocalizedError {
    case 無法解析的格式, 不正確的月份, 不正確的日子(month: Int)
    
    
    //定義了一個計算屬性 errorDescription，當錯誤發生時，返回對應的錯誤描述訊息。
    var errorDescription: String? {
        switch self {
        case .無法解析的格式:
            return "無法解析格式，正確格式應為「月/日」。"
        case .不正確的月份:
            return "月份不正確，僅接受 1~12 之間的數字。"
        case .不正確的日子(let month):
            // 當錯誤是 不正確的日子 時，返回對應的錯誤訊息，並使用 month 參數來顯示該月份的最大天數。
            return "日子不正確，\(month) 月僅接受 1~\(MyDate.maxDaysOfMonth[month]!) 之間的數字。"
        }
    }
}

// ⚠️ 請勿修改已設定好的屬性、引述名稱和靜態方法。
struct MyDate: Comparable {
    var month: Int
    var day: Int
    
    // 定義了一個靜態常數 maxDaysOfMonth，是一個字典，表示每個月份的最大天數。
    static let maxDaysOfMonth = [1: 31, 2: 29, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31]
    
    // 1️⃣ 透過數字啟動日期，如果數字不在合理範圍內應報錯，請把不正確的月份和不正確的日子設為能被區分的錯誤，錯誤描述中需提供正確的數字範圍，例如：日子不正確，2 月僅接受 1~29 之間的數字。
    // 定義了一個初始化方法，接受 month 和 day 作為參數，並且可能會拋出錯誤。
    init(month: Int, day: Int) throws {
        // 檢查 month 是否在 1 到 12 的範圍內，若不在範圍內，則拋出 不正確的月份 錯誤。
        guard (1...12).contains(month) else {
            throw 日期轉換錯誤.不正確的月份
        }
        // 檢查 day 是否在該月份的有效天數範圍內，若不在範圍內，則拋出 不正確的日子 錯誤，並將 month 作為參數傳遞。
        guard (1...Self.maxDaysOfMonth[month]!).contains(day) else
        {
            throw 日期轉換錯誤.不正確的日子(month: month)
        }
        // 如果 month 和 day 都是有效的，則將它們分別賦值給 self.month 和 self.day 屬性。
        self.month = month
        self.day = day
    }
    
    // 2️⃣ 透過 String 啟動日期。正確的輸入會是 月/日，例如：12/7、2/20，如果遇到不正確的輸入則報錯，錯誤描述為「無法解析格式，正確格式應為「月/日」。」。
    
    // 定義了一個初始化方法，接受一個日期字串作為參數，並且可能會拋出錯誤。
    init(_ string: String) throws {
        // 這行將傳入的日期字串根據斜線 / 進行分割，然後嘗試將分割後的字串轉換為整數，存儲在 numbers 陣列中。
        let numbers = string.split(separator: "/").compactMap { Int($0) }
        // 檢查 numbers 陣列是否包含兩個元素，如果不是，則拋出 無法解析的格式 錯誤。
        guard numbers.count == 2 else {
            throw 日期轉換錯誤.無法解析的格式
        }
        // 使用 numbers 陣列中的元素來初始化 MyDate 結構，並且如果初始化過程中發生錯誤，則會將錯誤向上拋出。
        self = try .init(month: numbers[0], day: numbers[1])
    }
    
    static func <(lhs: MyDate, rhs: MyDate) -> Bool {
        guard lhs.month == rhs.month else {
            return lhs.month < rhs.month
        }
        
        return lhs.day < rhs.day
    }
}

// 💡 以下星座和測試已設定好，不需修改，只要上面 init 設定正確且引數名稱沒有被修改就能正常執行，但希望你可以看一下標註 3 的 assert 用法。
enum 星座: Int, CaseIterable {
    case 水瓶座, 雙魚座, 牡羊座, 金牛座, 雙子座, 巨蟹座, 獅子座, 處女座, 天秤座, 天蠍座, 射手座, 摩羯座
    
    init(_ MyDate: MyDate) {
        guard MyDate >= Self.水瓶座.firstMyDate, MyDate < Self.摩羯座.firstMyDate else {
            self = .摩羯座
            return
        }
        self = Self.allCases.first { MyDate >= $0.firstMyDate && MyDate <= $0.lastMyDate }!
    }
    
    var firstMyDate: MyDate {
        switch self {
            case .水瓶座:
                return try! .init(month: 1, day: 21)
            case .雙魚座:
                return try! .init(month: 2, day: 19)
            case .牡羊座:
                return try! .init(month: 3, day: 21)
            case .金牛座:
                return try! .init(month: 4, day: 21)
            case .雙子座:
                return try! .init(month: 5, day: 21)
            case .巨蟹座:
                return try! .init(month: 6, day: 22)
            case .獅子座:
                return try! .init(month: 7, day: 23)
            case .處女座:
                return try! .init(month: 8, day: 23)
            case .天秤座:
                return try! .init(month: 9, day: 23)
            case .天蠍座:
                return try! .init(month: 10, day: 24)
            case .射手座:
                return try! .init(month: 11, day: 23)
            case .摩羯座:
                return try! .init(month: 12, day: 22)
        }
    }
    
    var lastMyDate: MyDate {
        let nextSign = 星座(rawValue: rawValue + 1) ?? .水瓶座
        return try! .init(month: firstMyDate.month + 1, day: nextSign.firstMyDate.day - 1)
    }
}


let correctTest: [(String, Int)] = [ ("1/1", 11), ("1/20", 11), ("1/21", 0), ("1/22", 0), ("0001/01", 11), ("11/22", 9), ("12/21", 10), ("12/22", 11), ("12/31", 11), ("09/23", 8), ("2/29", 1)]


// 3️⃣ 這組是正確狀況的測試，你可以看一下 assert 的用法，是上一集有提到的「用來檢查某個情況是否為真」。除了可以用來測試，你也可以放在你開發中的 code 中幫你確認程式執行到某個時間點的時候是否如你預期。
correctTest.forEach { testString, rawValue in
    let correctSign = 星座(rawValue: rawValue)!
    guard let result = try? 星座(MyDate(testString)) else {
        assertionFailure("生日 \(testString) 應為 \(correctSign)，但您的答案是 nil")
        return
    }
    assert(result == correctSign, "生日 \(testString) 應為 \(correctSign)，但您的答案是 \(result)")
}


// 以下為錯誤狀況的測試，不用調整。
let incorrectTest = ["2/30", "9/31", "13/29", "-1/1", "0.1/0.3", "3/", "5-5", "19990514"]

incorrectTest.forEach { testString in
    do {
        try 星座(.init(testString))
    } catch {
        print(error.localizedDescription)
    }
}
