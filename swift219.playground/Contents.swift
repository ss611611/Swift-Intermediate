//【ChaoCode】 Swift 中級篇 19 Structured Concurrency & Cancellation 實作作業

import Foundation
import _Concurrency

// 💡 這次只有一題練習，只有第二步和第三步需要調整內容。主要是希望讓你透過「實際測試看看跑出來的結果」，更確實地理解「cancel」是如何進行，以及「Task.checkCancellation()」該如何使用。


final class MyTaskManager {
    // 1️⃣ money 是現在賺到的錢錢，tasks 是正在進行中的工作，Key 是客戶名稱，Value 是對應的 Task。（不需做任何調整）
    private var money = 0
    private var tasks: [String: Task<Void, Never>] = [:]
    
    // 2️⃣ 有新工作時用 add 新增。你可以假設不會有重複名稱的客戶，也可以不理會同時讀寫的問題。
    func add(client: String) -> Task<Void, Never>? {
        // ＊請使用 work 方法新增工作，並加到 tasks 中後回傳。
        // ＊如果遇到錯誤就印出「ＯＯＯ 的案件被取消。」。
        // ＊無論失敗或成功都應從 tasks 中刪除。
        // ＊最多同時進行五個工作，如果超過就拒絕並回傳 nil。
        // ＊有接下的任務都必須計時，使用 printElapsedTime 來印出花費時間。
        guard tasks.count < 5 else {
            print("🙅‍♀️ 手上案子太多，無法接受 \(client) 的新案子。")
            return nil
        }
        
        let task = Task {
            let startTime = Date.now
            defer {
                printElapsedTime(action: "> \(client) 的工作", from: startTime)
                tasks[client] = nil
            }
            do {
                try await work(for: client)
            } catch {
                print("⚠️ \(client) 的案件被取消。")
            }
        }
        
        tasks[client] = task
        return task
    }
    
    // 3️⃣ 所有工作都是用此方法建立。基本的流程已完成，根據情境不同有些同步和非同步的 sleep，請勿刪除現在已經有的內容。
    // ＊ 整個流程是 寫程式 2 秒 -> 等客戶端 review 1 秒 -> 修正 1 秒 -> 等付尾款 0.5 秒。
    // ＊ 你要做的是在適當的地方加上「確認是否任務已取消」，建議邊執行後面第四步的測試邊調整。
    private func work(for client: String) async throws {
        money += 30_000
        print("替 \(client) 寫程式中。")
        try Task.checkCancellation()
        sleep(2)
        
        try Task.checkCancellation()
        print("等待 \(client) 進行 review。")
        try await Task.sleep(seconds: 1)
        
        print("根據 \(client) 的要求修正。")
        sleep(1)
        try Task.checkCancellation()
        
        print("交件，等待 \(client) 支付尾款。")
        do {
            try await Task.sleep(seconds: 0.5)
        } catch is CancellationError {
            print("⏰ \(client) 的案子已交件，不可取消。請乖乖付款。")
        }
        money += 70_000
    
        print("✅ 收到 \(client) 的款項，結案。")
    }
    
}

let myManager = MyTaskManager()

// 4️⃣ 這裡是測試，每一個測試中有客戶名稱 & 過幾秒後取消。測試內容都不需調整。
typealias TestCase = (client: String, cancelAfter: Double)
let testCases: [TestCase] = [("Julie", 0), ("Emily", 1), ("Billy", 1.5), ("Victor", 2.5), ("Edward", 3), ("Jason", 4.1) , ("David", 4.5)]

// 每次執行結果都會有點不一樣（因為暫停後的分配不可預測），但以下幾點應該確保：
// ＊ Julie 的任務會在 0 秒多被取消。
// ＊ Julie、Emily、Billy 不會進到 Review 階段，因為他們都在「寫程式的兩秒」期間就取消了。
// ＊ Victor 不會進到修正的階段，因為他會在「review」期間取消。
// ＊ Edward 不會進到付款階段，因為他會在「review」或「修正」期間被取消（時間點剛好比較容易被非同步的執行順序影響）。
// ＊ Jason & David 都會完成結案。
// 💡 有時候 playground 跑 concurrency 會突然就停止了，多試幾次就好。
// 💡 如果一次測太多個人資訊太雜亂，也可以自行調整成一次測一個人的寫法。

for testCase in testCases {
    while true {
        let task = myManager.add(client: testCase.client)
        guard let task = task else {
            sleep(1)
            continue
        }
        Task {
            try! await Task.sleep(seconds: testCase.cancelAfter)
            task.cancel()
        }
        break
    }
}

