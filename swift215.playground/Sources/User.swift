import Foundation

public enum AccountError: LocalizedError {
    case 信箱未認證, 使用者名稱已被使用, 名稱過短
    
    public var errorDescription: String? {
        switch self {
            case .信箱未認證:
                return "請完成信箱認證以開啟社交功能。"
            case .使用者名稱已被使用:
                return "此名稱已被使用，請換一個名稱。"
            case .名稱過短:
                return "使用者名稱最少需要兩個字。"
        }
        
    }
}

public enum MessageError: LocalizedError {
    case 找不到使用者(String), 被封鎖, 僅接收好友訊息, 已追蹤(String)
    
    public var errorDescription: String? {
        switch self {
            case .找不到使用者(let username):
                return "找不到使用者\(username)。"
            case .被封鎖:
                return "您在對方的封鎖名單中。"
            case .僅接收好友訊息:
                return "對方僅接受好友訊息。"
            case .已追蹤(let username):
                return "您已追蹤\(username)"
        }
    }
}

public final class User {
    var username: String
    var hasValidMail = true
    var allowStrangerMessaging = false
    var followedList: [String] = []
    var blockedList: [String]  = []
    
    /// 建立新的使用者。
    public init(_ username: String) throws {
        guard username.count >= 2 else { throw AccountError.名稱過短 }
        if let _ = try? User.getUser(username) {
            throw AccountError.使用者名稱已被使用
        }
        self.username = username
        self.hasValidMail = false
    }
    
    /// 認證信箱。
    public func validateMail() {
        hasValidMail = true
        print("您已完成信箱認證。")
    }
    
    /// 追蹤另一位使用者。
    public func follow(username other: String) throws {
        guard !followedList.contains(other) else {
            throw MessageError.已追蹤(other)
        }
        
        try getConnection(with: other)
        followedList.append(other)
        print("✅ 開始追蹤\(other)。")
    }
    
    /// 發送訊息給另一位使用者。
    public func send(message: String, to username: String) throws {
        let receiver = try getConnection(with: username)
        
        guard receiver.allowStrangerMessaging || isFriend(with: receiver) else {
            throw MessageError.僅接收好友訊息
        }
        
        print("💌 您已成功發送訊息給\(username)。")
    }
    
    /// 從現有使用者中搜尋，沒有找到話會報錯。
    public static func getUser(_ username: String) throws -> User {
        guard let targetUser = allUser.first(where: { $0.username == username }) else {
            throw MessageError.找不到使用者(username)
        }
        return targetUser
    }
    
    // 👆 看到這裡即可，後面為內部方法。
    
    private init(username: String, hasValidMail: Bool = true, allowStrangerMessaging: Bool = false, followedList: [String] = [], blockedList: [String] = []) {
        self.username     = username
        self.hasValidMail = hasValidMail
        self.followedList = followedList
        self.blockedList  = blockedList
        self.allowStrangerMessaging = allowStrangerMessaging
    }
}

enum ForcedError: Error {
    case forcedError
}


extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.username == rhs.username
    }
}

extension User {
    private func isFriend(with target: User) -> Bool {
        followedList.contains(target.username) && target.followedList.contains(username)
    }
    
    @discardableResult
    private func getConnection(with other: String) throws -> User {
        if other == "ERROR" { throw ForcedError.forcedError }
        guard hasValidMail else { throw AccountError.信箱未認證 }
        let targetUser = try User.getUser(other)
        guard !targetUser.blockedList.contains(username) else { throw MessageError.被封鎖 }
        
        return targetUser
    }
    
    private static let allUser: [User] = [ .init(username: "Jane", hasValidMail: false, followedList: ["猴子"]),
                                           .init(username: "強尼"),
                                           .init(username: "比莉", followedList: ["Jane"]),
                                           .init(username: "安娜", allowStrangerMessaging: true),
                                           .init(username: "猴子"),
                                           .init(username: "小周", allowStrangerMessaging: true, blockedList: ["Jane"])]
}

