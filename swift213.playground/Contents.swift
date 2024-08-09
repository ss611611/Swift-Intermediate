// 「===」比較

//class Book: Equatable {
//    var name: String
//    
//    init(name: String) { self.name = name }
//    
//    static func == (lhs: Book, rhs: Book) -> Bool {
//        lhs.name == rhs.name
//    }
//}
//
//
//let book = Book(name: "哈利波特")
//let book2 = Book(name: "哈利波特")
//
//book == book2
//book === book2
//
//var book3 = book
//book3 === book
//book3 == book2
//book3 === book2
//book3.name = "魔界"
//book3 === book
//book3 == book2
//book3 === book2


//【ChaoCode】 Swift 中級篇 13 Class 總結 實作作業
//
// 寫一個 extension，讓所有 conforms to Equatable 的 class 自動比較「連結」來判斷是否相等。

// 擴展所有符合 Equatable 且是引用類型 (class) 的類型。
extension Equatable where Self: AnyObject {
    // 自訂 == 運算符，用於比較兩個引用類型的實例。
    static func ==(lhs: Self, rhs: Self) -> Bool {
        // 使用 `===` 運算符比較兩個實例是否為同一個引用。
        lhs === rhs
    }
}

// 請勿修改以下內容，執行結果應印出 false & true
class Cat: Equatable { }

let cat = Cat()
let cat2 = Cat()
let cat3 = cat
print(cat == cat2)
print(cat == cat3)
