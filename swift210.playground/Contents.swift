// Retain Cycle & ARC

//  weak

//class 貓咪 {
//    var name: String
//    weak var 伴侶: 貓咪?
//    
//    init(_ name: String) { self.name = name }
//    
//    deinit {
//        print("貓咪「\(name)」被釋放了")
//    }
//}
//
//
//var cat: 貓咪? = 貓咪("蛋蛋")
//var cat2: 貓咪? = 貓咪("皇阿瑪")
//
//cat?.伴侶 = cat2
//cat2?.伴侶 = cat
//
//print(">> 即將把 \(cat!.name) 設成 nil")
//cat = nil
//
//print(">> 即將把 \(cat2!.name) 設成 nil")
//cat2 = nil
//
//print("執行結束")

// unowned
//class 會員 {
//    var 處理中的訂單: 訂單?
//    
//    deinit {
//        print("會員被釋放")
//    }
//}
//
//
//class 訂單 {
//    unowned  var 訂購者: 會員?
//    }
//
//var order: 訂單? = 訂單()
//print(order?.訂購者)  // case none
//var user: 會員? = 會員()
//order?.訂購者 = user
//
//
//user = nil
//order?.訂購者 = .none
//dump(order?.訂購者) // case some
//
//print("執行結束")





//【ChaoCode】 Swift 中級篇 10 Reference Type & ARC： 實作作業
//
/*: 請閱讀以下的每一組 class，請根據你的判斷調整修改 class，確保不會有「retain cycle」。\
 ⚠️ 作業沒有測試，請自己加入 deinit 確認每個物件都被釋放。答案中有寫「哪裡產生了循環」，請務必也確認這個部分是否跟你想的一樣。
 */
// 1️⃣
class 教授 {
    var 課程: 課程?
 
}

class 課程 {
   unowned var 教授: 教授
    
    init(教授: 教授) {
        self.教授 = 教授
        教授.課程 = self
        // ⚠️ 教授和課程產生了循環。
    }
}

var 指導教授: 教授? = 教授()
var 計算機概論: 課程? = 課程(教授: 指導教授!)

// 以下兩行執行完後空間應被釋放
指導教授 = nil
計算機概論 = nil



// 2️⃣
class 老闆 {
    var 發薪水: ((Int) -> Void)?

}

class 帳戶 {
    unowned var 擁有者: 老闆
    var 存款 = 10000
    
    func 扣款(amount: Int) -> Void {
        存款 -= amount
        print("帳戶存款剩下 \(存款)")
    }
    
    init(擁有者: 老闆) {
        self.擁有者 = 擁有者
        擁有者.發薪水 = 扣款
        // ⚠️ 帳戶.擁有者 -> 老闆 ＆ 老闆.發薪水 -> 帳戶.扣款，產生了循環。
    }
}

var boss: 老闆? = 老闆()
var bank: 帳戶? = 帳戶(擁有者: boss!)

// 以下兩行執行完後空間應被釋放
bank = nil
boss = nil


// 3️⃣
class 人 {
    var 工作: 工作?
}

class 工作 {
    weak var 負責人: 人?
    // ✨ 人可以沒工作，工作也可能沒有負責人，所以用 weak。或者把 人.工作 設成 weak 也沒問題。因為只要其中一端有是弱連結就不會產生 cycle。
}

var 男孩: 人? = .init()
var 打工機會: 工作? = .init()

男孩?.工作 = 打工機會
打工機會?.負責人 = 男孩

// 以下兩行執行完後空間應被釋放
男孩 = nil
打工機會 = nil
