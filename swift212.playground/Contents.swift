// Class 啟動

//class 矩形 {
//    var 寬: Double
//    var 長: Double
//    
//    init(寬: Double, 長: Double) {
//        self.寬 = 寬
//        self.長 = 長
//    }
//    
//    convenience init(單邊長: Double) {
//        self.init(寬: 單邊長, 長: 單邊長)
//    }
//}
//
//
//class 立體矩形: 矩形 {
//    var 高: Double
//    
//    init(寬: Double, 長: Double, 高: Double) {
//        self.高 = 高
//        super.init(寬: 寬, 長: 長)
//    }
//    
//    convenience init(單邊長: Double) {
//        self.init(寬: 單邊長, 長: 單邊長, 高: 單邊長)
//    }
//}
//
//// 在 extenstion 中新增 class 啟動
//extension 矩形 {
//    convenience init() {
//        self.init(單邊長: 1)
//    }
//}


// 自動繼承啟動

//class 矩形 {
//    var 寬: Double
//    var 長: Double
//
//    init(寬: Double, 長: Double) {
//        self.寬 = 寬
//        self.長 = 長
//    }
//
//    convenience init(單邊長: Double) {
//        self.init(寬: 單邊長, 長: 單邊長)
//    }
//}
//
//class 矩形B: 矩形 {
//    var 高: Double = 3
//    
//    init() {
//        super.init(寬: 2, 長: 2)
//    }
//    
//    override init(寬: Double, 長: Double) {
//        super.init(寬: 寬, 長: 長)
//    }
//}
//
//let designated = 矩形B(寬: 1, 長: 2)
//let convenience = 矩形B(單邊長: 2)


// 關鍵字：Required

//protocol 形狀 {
//    init()
//}
//
//
//class 矩形: 形狀 {
//    var 寬: Double
//    var 長: Double
//    
//    required init() {
//        self.寬 = 1
//        self.長 = 1
//    }
//
//    init(寬: Double, 長: Double) {
//        self.寬 = 寬
//        self.長 = 長
//    }
//
//    convenience init(單邊長: Double) {
//        self.init(寬: 單邊長, 長: 單邊長)
//    }
//}
//
//class 矩形B: 矩形 {
//    init(單邊長: Double) {
//        super.init(寬: 單邊長, 長: 單邊長)
//    }
//    
//    required init() {
//        fatalError("init() has not been implemented")
//    }
//}






//【ChaoCode】 Swift 中級篇 12 Class & 啟動： 實作作業

// 請根據下列數字步驟完成練習。

class File {
    var filename: String
    var data: String
    
    
    init(filename: String, data: Any) {
        self.filename = filename
        self.data = String(describing: data)
    }
}

// 1️⃣ 請讓這個 class 繼承 File，並新增一個「version」的屬性，類型是 Double。預設值是 1。
class VersionedFile: File {
    var version: Double = 1
    
    convenience init(filename: String, data: Any, version: Double) {
        self.init(filename: filename, data: data)
        self.version = version
    }
}

// 2️⃣ 請讓這個 class 繼承 VersionedFile，並新增一個「author」的屬性，類型是 String?。此類型不會再被繼承。
final class BookFile: VersionedFile {
    var author: String?
    
    convenience init(filename: String, data: Any, version: Double = 1, author: String?){
        self.init(filename: filename, data: data)
        self.version = version
        self.author = author
    }
}

// 3️⃣ 請調整 VersionedFile 和 BookFile 的啟動，請只使用「convenience init」，讓以下六種啟動方式都能正常執行（不會報錯即可）。
VersionedFile(filename: "Homework", data: 123)
VersionedFile(filename: "Homework", data: "abc", version: 2)
BookFile(filename: "First Book", data: "")
BookFile(filename: "Second Book", data: "", author: "Jane")
BookFile(filename: "Second Book", data: 2.0, version: 2, author: "Jane")
BookFile(filename: "First Book", data: 3, version: 3)



