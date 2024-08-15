// Capture

//func getBuyCandyClosure() -> () -> Void {
//    var money = 100
//    
//    func buyCandy() {
//        money -= 20
//        print("😊🍬，剩下\(money)")
//    }
//    return buyCandy
//}
//let buyCandy = getBuyCandyClosure()
//
//buyCandy()
//buyCandy()
////print("買完兩次剩下 \(money)元")


// 類型中的 Capture

//struct 錢包 {
//    var money: Int = 100
//    
//    mutating func buySomething(cost: Int) {
//        money -= cost
//        print("花了 \(cost)，剩下 \(money)")
//    }
//}
//
//var wallet = 錢包()
//wallet.buySomething(cost: 20)


// Capture List: 把需要的外部變數建立成 local 變數。

//class 錢包 {
//    var money: Int = 100
//
//    lazy var buySomething: (Int) -> Void = { [錢錢 = money] cost in
//        print("剩下 \(錢錢)")
//    }
//
//    func 稍後付款(amount: Int) {
//        Task { [weak self] in
//            try! await Task.sleep(nanoseconds: 5)
//            guard let self = self else {
//                print("沒錢包了")
//                return
//            }
//            self.money -= amount
//            print("付了 \(amount) 元，剩下 \(self.money) 元。")
//        }
//    }
//    deinit {
//        print("錢包掰掰")
//    }
//}
//
//var wallet: 錢包? = 錢包()
//wallet?.buySomething(20)
//var buySomething = wallet?.buySomething
//wallet?.money = 200
//wallet?.稍後付款(amount: 50)
//wallet = nil
//buySomething?(30)


//// Escaping
//import _Concurrency
//
//let number = [1, 2, 3]
//
//// Non-escaping
//number.forEach { number in
//    print(number)
//}
//
//// Escaping: 被一個變數儲存的時候。
//struct A {
//    var closure: () -> Void
//    init(closure: @escaping () -> Void) {
//        self.closure = closure
//    }
//}
//
//A.init {}
//
//// Escaping: 被另一個 escaping closure capture 的時候。
//func doSomething(action: @escaping () -> Void) {
//    Task.init {
//        action()
//    }
//}





//【ChaoCode】 Swift 中級篇 20 Capture & Escaping 實作作業
import _Concurrency
import Foundation
// 1. 把 GymMemeber 中的 payBill 改成一個 closure 的屬性，並且讓月費價格固定於入會時的價格。（例如：如果入會時月費是 150，後面漲價也不受影響。
// 💡 真實情況只需要替每個會員設定一個自己的月費金額就好，不過這裡是為了練習 & 理解 Value Type 的 capture 情況～所以請用 closure 解決，不要修改其他地方。
struct GymMember {
    static var monthlyCost = 150
    let name: String
    
    // 定義了一個延遲存儲屬性 payBill，它是一個閉包，用來模擬自動扣款功能。
    // 閉包捕獲了兩個值：name 和 price，其中 name 是會員的名字，price 則是當前的 monthlyCost 值。
    lazy var payBill = { [name, price = GymMember.monthlyCost] in
        print("會員 \(name) 自動扣款 \(price) 元訂閱費。")
    }
}

// 以下是測試，請勿修改
var member1 = GymMember(name: "賈伯斯")
member1.payBill()
print("漲價到每月 200 元。")
GymMember.monthlyCost = 200
var memeber2 = GymMember(name: "庫克")
member1.payBill()
memeber2.payBill()


print("---------------------------")

// 2. 修正以下兩個 schedule 的方法，兩者都是等待幾秒後執行 action，一個是同步的 、另一個是非同步的。
// ＊ 用 Task.sleep 等待，如果等待時報錯就直接 return。
// ＊ 宣告的地方也會需要修改，確保引數標籤一樣即可。
// ＊ action 可能是 async 的，也可能報錯，如果有報錯的話必須傳出來。

// @escaping：表示傳入的 action 閉包可能會在函式返回後被調用，這在非同步情境下是必要的，因為 Task 內的操作不會立即執行。
// rethrows：表示這個函式只會在 action 閉包內部拋出錯誤時才會拋出錯誤，否則不會主動拋出錯誤。
func schedule(after second: Double, action: @escaping () async throws -> Void) rethrows {
    // 建立一個新的非同步任務，這意味著 action 的執行是在一個新的並行任務中進行的。
    Task {
        // ask.sleep(seconds:)：讓當前的 Task 睡眠指定的秒數，這是一個非同步操作。如果睡眠過程中發生錯誤（例如被取消），這裡使用 try? 來忽略錯誤並直接返回。
        guard let _ = try? await Task.sleep(seconds: second) else {
            return
        }
        try await action()
    }
}

// action 閉包被直接在調用者的當前 Task 內部執行，而不是在新的 Task 中。
// async rethrows：表示這個函式是非同步的，且它只會在 action 閉包內部拋出錯誤時才會拋出錯誤。
func schedule(after second: Double, action: () async throws -> Void) async rethrows {
    guard let _ = try? await Task.sleep(seconds: second) else {
        return
    }
    try await action()
}


// 3. 以下是使用者和信用卡 class，請根據步驟完成類型宣告和測試。

final class User {
    var name: String
    var notify: (String) -> Void
    
    // 1️⃣ 完成啟動，參數名稱請用跟屬性名稱一樣的。
    init(name: String, notify: @escaping (String) -> Void) {
        self.name = name
        self.notify = notify
    }
}

final class CreditCard {
    var owner: User
    private var limit: Int
    private var used: Int = 0
    
    init(owner: User, limit: Int) {
        self.owner = owner
        self.limit = limit
    }
    
    deinit {
        print("信用卡已註銷。")
        sendBill()
    }
    
    func sendBill() {
        // 2️⃣ 在 capture list 中直接存取需要的值。並確保這裡沒有產生任何強連結。（這裡產生強連結並不會有問題，這個調整只是為了練習）
        // 💡 這點你要自己對答案檢查。
        Task { [unowned owner, used] in
            owner.notify("[帳單] 您本月的刷卡金額為 \(used) 元。")
        }
    }
    
    @MainActor
    func swipe(amount: Int) {
        guard used + amount <= limit else {
            owner.notify("[刷卡通知] 卡片被拒絕。")
            return
        }
        
        used += amount
        owner.notify("[刷卡通知] 消費\(amount)。")
    }
}


// 3️⃣ 這個測試會每秒刷一次卡，使用者在兩秒後就會剪卡。你會在下面手指的地方寫每秒刷卡的程式碼，並確保裡面沒有對信用卡的強連結。
func runTest() {
    let startTime = Date.now
    let user = User(name: "Jane") { print($0) }
    let creditCard = CreditCard(owner: user, limit: 1000)
    
    // 💡 這是剪卡的 Task，這裡應該要是唯一一個 capture 信用卡的地方。如果後面弱連結設定都正確，這個 Task 兩秒後被釋放時卡片就會跟著被釋放。
    Task {
        try! await Task.sleep(seconds: 2)
        print("\(creditCard.owner.name) 剪卡了。")
    }
    
    let testCases = [300, 200, 700, 220]
    // 👇 請從這裡開始編輯，請新增一個 TaskGroup，其中任務是使用第二題寫的 schedule 來刷卡。（也是測試 schedule 有沒有寫對）
    // ＊ testCases 的數字是刷卡金額，請根據 index 設定等待秒數。例如 700 的 index 是 2，就是等待 2 秒後執行刷卡。
    // ＊ 假如卡片已註銷就拋出 CancellationError。印出「ＯＯＯ 的卡片註銷，取消剩餘任務。」後直接結束整組任務。
    // ＊ 確保這些任務不會對 CreditCard 產生強連結。（包含 Task 本身）
    // 💡 這題用連結判斷是否註銷也是為了練習而已，實際上用一個布林屬性判斷是否註銷即可。
    
    // card = creditCard 是用來捕捉外部的 creditCard 物件，並使用 [weak card] 將它變成弱引用，這樣在 Task 中使用 card 時，不會強制保留它，避免可能的循環引用。
    Task { [weak card = creditCard] in
        // 創建一個可以拋出錯誤的任務組。這個任務組中的每個任務都會回傳 Void，並且可以拋出錯誤。
        await withThrowingTaskGroup(of: Void.self) { group in
            // 逐一遍歷測試用的金額（amount），並取得它們的索引值（index）。
            testCases.enumerated().forEach { index, amount in
                // 對於每個測試金額，會向任務組中添加一個任務（group.addTask）。
                group.addTask { [weak card] in
                    // 每個任務使用弱引用的 card，並且在 schedule(after:) 中延遲 index 秒後執行。
                    try await schedule(after: Double(index)) {
                        // card.swipe(amount:) 方法會被調用來模擬刷卡操作。這裡使用 guard let card = card 來確保卡片仍然存在，否則會拋出 CancellationError 來中止任務。
                        guard let card = card else { throw CancellationError() }
                        await card.swipe(amount: amount)
                    }
                }
            }
            do {
                try await group.waitForAll()
            } catch {
                print("\(user.name) 的卡片已註銷，取消剩餘任務。")
            }
        }
       
        printElapsedTime(from: startTime)
    }
}


runTest()
