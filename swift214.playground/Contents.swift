//let number: Any = 1
//let word: Any = "hello"
//let type: Any = Int.self
//let array = [number, word, type]
//
//
//class A {}
//class B {}
//
//let a = A()
//let b = B()
//
//// Any: 任何類型
//let calssArray: [Any] = [a, b]
//// AnyObject: 任何 class
//let calssArray2: [AnyObject] = [a, b]


// Type Casting：

//let array: [Any] = ["abc", 123]
//
//let intArray = array as? [Int]
//let descriptionArray = array as! [CustomStringConvertible]
//
//print("------------------------------ is")
//descriptionArray.forEach { element in
//    if element is Int {
//        print("Int: \(element)")
//    } else if element is String {
//        print("String: \(element)")
//    }
//}
//
//print("------------------------------ as")
//descriptionArray.forEach { element in
//    if let element = element as? Int {
//        print("Int: \(element)")
//    } else if let element = element as? String {
//        print("String: \(element)")
//    }
//}
//
//print("------------------------------ switch")
//descriptionArray.forEach { element in
//    switch element {
//    case is String:
//        print("String: \(element)")
//    case let element as Int:
//        print("Int: \(element)")
//    default:
//        break
//    }
//}





//【ChaoCode】 Swift 中級篇 14 Type Casting 實作作業

import Foundation

// 1️⃣ 請閱讀 DB 和 Record，確認這個資料庫如何運作。請勿修改任何內容。

class Record: Identifiable {
    let id = UUID().uuidString
    let createdDate: Date = .now
}

final class DB<Category: Hashable> {
    private var records: [Category: [Record]] = [:]
    
    func add(_ record: Record, to category: Category) {
        records[category, default: []].append(record)
    }
    
    func get(from category: Category, where condition: (Record) -> Bool) -> Record? {
        records[category]?.first(where: condition)
    }
    
    func getAll(from category: Category? = .none) -> [Record] {
        guard let category = category else {
            return records.flatMap { $0.value }
        }
        
        return records[category] ?? []
    }
}

// 2️⃣ 請讓 PhoneRecord & ScheduleRecord 能被儲存進 DB 中。（請維持同樣的啟動方式）

final class PhoneRecord: Record {
    var name: String
    var phoneNumber: String
    
    init(name: String, phoneNumber: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        super.init()
    }
}

final class ScheduleRecord: Record {
    var todo: String
    var date: Date
    
    init(todo: String, year: Int, month: Int, day: Int) {
        self.todo = todo
        self.date =
        DateComponents(calendar: .current, year: year, month: month, day: day).date!
        super.init()
    }
}

// 3️⃣ 請決定資料庫的分類方式（DB.Category）並透過 db 變數建立 DB。
enum MyCategory {
    case phone, schedule
}

let db = DB<MyCategory>()


// 4️⃣ 請勿修改這兩組資料，如果不能執行修改讓這些啟動方式能正常使用。
let phones = [PhoneRecord(name: "媽咪", phoneNumber: "0988666888"),
              PhoneRecord(name: "寶貝", phoneNumber: "0919222333"),
              PhoneRecord(name: "獸醫院", phoneNumber: "022345666")]

let schedules = [ScheduleRecord(todo: "牛奶海", year: 2022, month: 8, day: 20),
                 ScheduleRecord(todo: "蛋蛋生日", year: 2022, month: 11, day: 12),
                 ScheduleRecord(todo: "中秋烤肉", year: 2022, month: 9, day: 10)]

// 5️⃣ 請把 phones & schedules 裡的所有資料夾進去。
phones.forEach { db.add($0, to: .phone) }
schedules.forEach { db.add($0, to: .schedule) }


// 6️⃣ 請 loop AllRecord，當資料是電話號碼時印出「找到 ＯＯＯ 的電話」，資料是行程時印出「找到一筆行程資料（ID：XXXXX）」。其他情況不需印出任何東西。
let allRecord = db.getAll()

allRecord.forEach { record in
    switch record {
    case let phoneRecord as PhoneRecord:
        print("找到 \(phoneRecord.name) 的電話")
    case is ScheduleRecord:
        print("找到一筆行程資料（ID：\(record.id)")
    default:
        break
    }
}

// 7️⃣ 請使用 db.get 找到媽咪的電話號碼（你可以假設一定找得到）。
let mom = db.get(from: .phone) { ($0 as! PhoneRecord).name == "媽咪" } as! PhoneRecord
print("媽媽的號碼是 \(mom.phoneNumber)")


// 8️⃣ 請使用 db.getAll(from:) 印出所有行程和日期（你可以假設一定有資料）。
// 日期可以使用 .date.formatted() 來印出，你可以試看看不同參數。
let allEvent = db.getAll(from: .schedule) as! [ScheduleRecord]
allEvent.forEach { print($0.date.formatted(date: .numeric, time: .omitted), $0.todo) }
