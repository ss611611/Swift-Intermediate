import Foundation

public protocol Deliverable: CustomStringConvertible {
    static var deliveryTime: TimeInterval { get }
}

public enum Food: String, CaseIterable, Deliverable {
    public static var deliveryTime: TimeInterval = 3
    
    case 薯條 = "🍟"
    case 拉麵 = "🍜"
    case 水餃 = "🥟"
    case 披薩 = "🍕"
    case 漢堡 = "🍔"
    
    public var description: String { rawValue }
}

public enum Drink: String, CaseIterable, Deliverable {
    public static var deliveryTime: TimeInterval = 2
    
    case 珍奶 = "🧋"
    case 生啤 = "🍺"
    case 果汁 = "🧃"
    case 牛奶 = "🥛"
    case 茶 = "🍵"
    
    public var description: String { rawValue }
}

public func printElapsedTime(from startTime: Date) {
    let endTime = Date.now
    let timePassed = (startTime.distance(to: endTime)).formatted()
    print("完成任務時間經過：\(timePassed) 秒")
}

extension Task where Success == Never, Failure == Never {
    public static func sleep(seconds: Double) async throws {
        let nanoseconds = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: nanoseconds)
    }
}
