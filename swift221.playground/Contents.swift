// Actor

//import _Concurrency
//
//actor BankAccount {
//    let name: String
//    var balance = 1000
//    
//    init(_ name: String) { self.name = name }
//    
//    func withdraw(_ amount: Int) -> Int {
//        if amount > balance {
//            print("⚠️ \(name)存款只剩 \(balance) 元，無法提款 \(amount) 元。")
//            return 0
//        }
//        balance -= amount
//        print("🔽 \(name)提款 \(amount) 元，剩下 \(balance) 元。")
//        return amount
//    }
//    
//    func deposit(_ amount: Int) -> Int {
//        balance += amount
//        print("\(name)存款 \(amount) 元，目前存款為 \(balance) 元。")
//        return balance
//    }
//    
//    func printBance() {
//        print("\(name)餘額為：\(balance) 元。")
//    }
//}
//
//func syncActions(account: isolated BankAccount) {
//    print("------------------開始")
//    account.withdraw(200)
//    account.deposit(100)
//    print("------------------結束")
//}
//
//extension BankAccount: CustomStringConvertible, Hashable {
//    nonisolated var description: String {
//        name
//    }
//    
//    static func == (lhs: BankAccount, rhs: BankAccount) -> Bool {
//        lhs.name == rhs.name
//    }
//    
//    nonisolated func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//    }
//}
//
//
//let familyAccout = BankAccount("家庭帳戶")
//
//print("創建了 \(familyAccout.name)。")
//
//Task {
//    print("一開始有：\(await familyAccout.balance) 元。")
//    await withTaskGroup(of: Void.self) { groud in
//        (0...3).forEach { number in
//            groud.addTask {
//                await syncActions(account: familyAccout)
//            }
//        }
//        
//        await groud.waitForAll()
//        await familyAccout.printBance()
//    }
//}








//【ChaoCode】 Swift 中級篇 21 Actor 實作作業
import _Concurrency
import Foundation

// 💡 我測試的時候沒有 thread safe 的程式在 playground 很容易停住，所以如果你一直遇到執行時跑到一半就停住，建議先修改程式碼。

// 1. 請修改以下訂位系統，確保不會因為同時訂位導致多人訂到同個位置。

actor BookingSystem {
    private(set) var seats = [Seat: String]()
    
    /// 回傳值表示訂位是否成功。
    func booking(seat: Seat, by buyer: String) -> Bool {
        switch seats[seat] {
            case .none:
                seats[seat] = buyer
                return true
            default:
                return false
        }
    }
}


// 💡 以下是測試，會根據你的設計需要新增「await」的部分。除了 await 之外的地方請勿修改。
// ＊ 測試會有 10 人同時訂位，最後印出來的結果應該是 10 人都要有訂到位置。假如有位置的人數少於 10 表示有重複訂位被覆蓋了。
let system = BookingSystem()

Task {
    await withTaskGroup(of: Void.self) { group in
        bookingTestCases.forEach { testCase in
            group.addTask {
                for seat in popularSeats {
                    let didBook = await system.booking(seat: seat, by: testCase.name)
                    if didBook {
                        print("\(testCase.name) 訂到 \(seat)")
                        return
                    }
                }
                await system.booking(seat: testCase.seat, by: testCase.name)
                print("\(testCase.name) 訂到 \(testCase.seat)")
            }
        }
        
        await group.waitForAll()
        print("共有 \(await system.seats.count) 人訂到位子。")
        print("座位表： \(await system.seats)")
    }
}


// 2. 請設計一個商品資料下載的系統，裡面需要有 cache（暫存資料） 的機制，盡可能地提升效率。

actor ProductDownloadManager {
    // 你可以用任意方式設計 cache，最基本的就是一個 cache 屬性的字典。
    // 為了方便後面測試，請確保這個類型不需要輸入參數即可啟動。
    var cache = [Int: Task<Product?, Never>]()
    //＊ 請調整 download 方法，不要修改參數和回傳。
    //＊ 不能有重複的下載，記得「下載中」的情況也要處理。💡 你可以用 Task 解決。
    func download(id: Int) async -> Product? {
        if !cache.keys.contains(id) {
            cache[id] = Task { await getProduct(id: id) }
        }
        
        let task = cache[id]!
        
        return await task.value
    }
}

// 🤚 以下是測試，download 本來就是非同步所以應該不需要修改。
// 💡 為了避免執行時跟第一題混再一起我先 comment 掉了，再請你要測試時自己 uncomment。
// ＊ 你印出來的結果應該要沒有重複的下載，但下載了幾次商品就要印出幾次結果。例如：下載了 3 次 ID 10 的商品，應該印出一次下載和三次一樣的結果。
Task {
    let downloadManager = ProductDownloadManager()

    await withTaskGroup(of: Product?.self) { group in
        let savedIDs = [9, 14, 10]
        print("下載使用者儲存的商品資料...")
        savedIDs.forEach { id in
            group.addTask { await downloadManager.download(id: id) }
            group.addTask { await downloadManager.download(id: id) }
        }

        let bestSellerIDs = await getBestSellersID()
        bestSellerIDs.forEach { id in
            group.addTask { await downloadManager.download(id: id) }
        }

        for await product in group {
            if let product = product {
                print(product)
            }
        }
    }
}

