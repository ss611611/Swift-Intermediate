


//func doSomething<T: Numeric>(number: T) -> String {
//    switch number {
//    case is Int:
//        return "整數"
//    case is Double:
//        return "浮點數"
//    default:
//        fatalError("不應該執行到這裡")
//    }
//}


// 可以處理的錯誤

//import Foundation
//
//struct 使用者 {
//    var name: String = "Jane"
//    
//    private init() {}
//    
//    static func 登入(帳號: String, 密碼: String) throws -> 使用者 {
//        guard 帳號.contains("@") && !帳號.contains(" ") else {
//            throw 登入錯誤.帳號格式錯誤(account: 帳號)
//        }
//        if 帳號 != "jane@chaocode.com" {
//            throw 登入錯誤.未註冊的帳號(account: 帳號)
//        }
//        if 密碼 != "pass" {
//            throw 登入錯誤.密碼錯誤
//        }
//        return 使用者()
//    }
//}
//
//enum 登入錯誤: LocalizedError {
//    case 未註冊的帳號(account: String)
//    case 帳號格式錯誤(account: String)
//    case 密碼錯誤
//}
//
//
//enum 網路錯誤: Error {
//    case 無法連線
//}
//
//func 嘗試登入(帳號: String, 密碼: String) {
//    do {
//        let user = try 使用者.登入(帳號: 帳號, 密碼: 密碼)
//        print("嗨 \(user.name) 歡迎回來！")
//    } catch 登入錯誤.密碼錯誤, 登入錯誤.未註冊的帳號 {
//        print("帳號或密碼不正確，請重新輸入")
//    } catch 登入錯誤.帳號格式錯誤(let account) where !account.contains("@") {
//        print("登入帳號應為信箱，請重新輸入")
//    } catch 登入錯誤.帳號格式錯誤 {
//        print("帳號有不正確的字元，請重新輸入")
//    } catch is 網路錯誤 {
//        print("網路不穩定，無法正常連線")
//    } catch {
//        print("發生未知錯誤\(error)")
//    }
//}
//
//嘗試登入(帳號: "jane@chaocode.com", 密碼: "pass")
//嘗試登入(帳號: "jane@chaocode.com", 密碼: "pass2")
//嘗試登入(帳號: "Ch", 密碼: "pass2")
//嘗試登入(帳號: "jane@ chaocode", 密碼: "pass")
//嘗試登入(帳號: "jane@chaocode", 密碼: "pass")





//【ChaoCode】 Swift 中級篇 15 Error Handling 實作作業

// 💡 請先閱讀 User 檔案，確認有哪些公開方法可以使用，也可以先看看有哪些錯誤。

// 1. 設計 createUser，依序使用 names 中的名字新建使用者，新建失敗時需印出對應的使用者名稱和原因。如果所有名字都無法使用就進入 Fatal Error，原因是：沒有可用的名字。
@discardableResult
func createUser(names: [String]) -> User {
    for name in names {
        do {
            let user = try User(name)
            return user
        } catch {
            print("無法建立使用者「\(name)」，\(error.localizedDescription)")
        }
    }
    
    fatalError("沒有可用的名字")
}

// ⚠️ 以下為測試。確認沒問題後，後請把一定會失敗的第一組 ["安娜", "安", "比莉"] 刪除，以方便繼續進行測試正常情況。
//let selectedNames = [["安娜", "安", "比莉"], ["強尼", "貝克漢", "小周"]]
let selectedNames = [["強尼", "貝克漢", "小周"]]
selectedNames.forEach { createUser(names: $0) }

print("-----------------------------------------------------------------")

// 2. 依步驟內指定的語法完成這題，指定的語法並非最佳寫法（甚至不好看），只是用來確保這幾個語法你都會使用。
// 1️⃣ 請使用 me 變數建立使用者 Jane，如果 Jane 已經存在了就使用 User.getUser 從使用者清單中取得 Jane。請在不使用 do-catch 的情況完成這題。
let me = (try? User("Jane")) ?? (try! User.getUser("Jane"))

func sendMessage(to other: String) {
    /* 2️⃣ 請透過 me 變數傳訊息給 people 中的每個使用者名稱，並搭配請 do-catch 處理錯誤。以下是所有需要處理的錯誤：
     ・AccountError.信箱未認證：印出「尚未完成信箱認證，將認證後重試⋯⋯」，並執行認證後再次傳送訊息。
     ・MessageError.被封鎖：印出「無法傳送訊息給 ＯＯＯ。」
     ・MessageError.僅接收好友訊息：印出「ＯＯＯ」僅接受互相追蹤的訊息，接著 follow 對方後再次傳送訊息並印出「將嘗試再次傳送⋯⋯」，如果在 follow 時報錯表示已經追蹤對方，則不重新傳送訊息（也就是不做任何事）。（這裡請只使用 do-catch。兩層 do-catch 並不是好的寫法，但這邊希望讓你測試一下自己是否真的理解 catch 的流程。）
     ・所有其他 MessageError：印出預設的描述。
     ・剩餘的錯誤則印出預設的錯誤描述，並使用 Fatal Error，原因是「未知的錯誤，這不該發生」。
     */
    var allowRetry = false
    repeat {
        allowRetry = false
        do {
            try me.send(message: "你在哪裡", to: other)
        } catch AccountError.信箱未認證 {
            print("尚未完成信箱驗證，將認證後重試....")
            me.validateMail()
            allowRetry = true
        } catch MessageError.僅接收好友訊息 {
            print("\(other)僅接受互相追蹤訊息。")
            do {
                try me.follow(username: other)
                print("將嘗試在次傳送....")
                allowRetry = true
            } catch { }
        } catch MessageError.被封鎖 {
            print("無法傳遞訊息給\(other)。")
        } catch  let error as MessageError {
            print(error.localizedDescription)
        } catch {
            print(error.localizedDescription)
            fatalError("未知的錯誤，這不該發生")
        }
    } while allowRetry

    print("---------------------------------------")
}


// ⚠️ 以下為測試。
let people = ["猴子", "比莉", "安娜", "強尼", "小周", "馬克", "ERROR"]
people.forEach { sendMessage(to: $0) }

