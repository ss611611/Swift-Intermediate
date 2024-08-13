// Asynchronous

//import Foundation
//import _Concurrency
//import UIKit
//
//
//let randomImageUrl = URL(string: "https://random.imagecdn.app/300/300")!
//
//func downloadImage() async throws -> UIImage {
//    let (data, response) =  try await URLSession.shared.data(from: randomImageUrl)
//    guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
//        fatalError()
//    }
//    return UIImage(data: data)!
//}
//
//Task {
//    try! await downloadImage()
//}






//【ChaoCode】 Swift 中級篇 17 Asynchronous 實作作業

import Foundation
import _Concurrency

// 1. 以下是一段 Synchronous 的叫外送方式，請修改讓外送變成 Asynchronous 的，讓最後在大約 3 秒初完成所有運送「所有餐點」。
// ⚠️ 下一集會教更便利地一次處理多個任務的方法，但現在請用目前學會的方式來處理，確保掌握了基本概念。

extension Deliverable {
    func order() async {
        // 檢查 sleep 是否成功，若失敗則觸發 assertionFailure，並打印錯誤訊息。
        guard let _ = try? await Task.sleep(seconds: Self.deliveryTime) else {
            assertionFailure("無法完成送餐(\(self))")
            return
        }
        print("您的餐點已抵達：\(self)")
    }
}

let startTime = Date.now
// 記錄已接收到的餐點數量
var itemReceived = 0

let allItems: [Deliverable] = Food.allCases + Drink.allCases
// 使用 for 迴圈遍歷 allItems 陣列中的每個項目，並對每個項目建立一個非同步任務 Task。
for item in allItems {
    Task {
        // 非同步地呼叫 order() 方法來模擬餐點的送達。
        await item.order()
        
        // 確保更新 itemReceived 計數器的操作在主執行緒上進行，避免競爭條件。
        await MainActor.run {
            itemReceived += 1
            // 每次 itemReceived 增加後，檢查是否所有餐點都已送達。
            if itemReceived == (Food.allCases.count + Drink.allCases.count) {
                printElapsedTime(from: startTime)
            }
        }
    }
    
}



/* 2. 練習取得網路上的資料，請透過下列網址會取得隨機貓咪知識，收到資料請透過 CatFact(data:) 來啟動 CatFact，並印出其中的 fact。請取得三個貓咪知識，並且滿足以下條件：
 > 三個請求等待不阻擋彼此。
 > 確保網路請求不是在 Main Thread 進行，而最後印出來貓咪知識時是在 Main Thread 進行。
 > 在網路請求和印出貓咪知識的地方都印出是否在 Main Thread。
 */

enum HTTPError: Error {
    case invalidResponse
}

struct CatFact: Codable {
    let fact: String
    let length: Int
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(CatFact.self, from: data)
    }
    // 用來保存請求貓咪知識 API 的 URL 地址。
    static private let requestUrl = URL(string: "https://catfact.ninja/fact")!
    
    // 靜態非同步方法，負責從網路獲取隨機貓咪知識。
    static func getRandomFact() async throws -> String {
        print("> 網路請求是否在 Main Thread？\(Thread.current.isMainThread)")
        // 發送網路請求，並等待響應。
        let (data, res) = try await URLSession.shared.data(from: requestUrl)
        // 檢查 HTTP 響應的狀態碼是否在 200 到 299 之間，確保請求成功。否則，拋出 HTTPError.invalidResponse 錯誤。
        guard let res = res as? HTTPURLResponse, (200...299).contains(res.statusCode) else {
            throw HTTPError.invalidResponse
        }
        
        let catFact = try CatFact(data: data)
        return catFact.fact
    }
}

for _ in 1...3 {
    Task {
        // 調用 CatFact.getRandomFact() 方法獲取貓咪知識。如果請求失敗，用 "Something went wrong..."。
        let fact = (try? await CatFact.getRandomFact()) ?? "Something went wrong..."
        // 使用 MainActor.run 在主執行緒上執行打印操作，這是因為 UI 更新必須在主執行緒上進行。
        await MainActor.run {
            print("> 印出貓咪知識是否在 Main Thread？\(Thread.current.isMainThread)")
            print("🐈 貓咪知識：\(fact)")
        }
    }
}



