import Foundation

// 1️⃣ 第一題的相關 function
public func getUsername() async -> String {
    try! await Task.sleep(seconds: 1)
    return "Jane"
}

public func getAllMovies() async -> [String] {
    try! await Task.sleep(seconds: 2)
    return ["捍衛戰士:獨行俠", "侏羅紀世界：統霸天下", "雷神索爾：愛與雷霆", "貓王艾維斯", "巴斯光年"]
}

// 2️⃣ 第二題的相關 funciton、類型
public func helloDataToString(_ data: Data) -> String? {
    try? JSONDecoder().decode(HelloResult.self, from: data).string
}

enum LoginError: Error {
    case invalidAccountOrPassword
}

public struct User {
    public let name: String
    public let location: String
    
    public init(account: String, password: String) async throws {
        try await Task.sleep(seconds: 1)
        guard let user = User.users[account], password == "pass" else {
            throw LoginError.invalidAccountOrPassword
        }
        
        self.name = user.0
        self.location = user.1
    }
    
    private static let users = [
        "chaocode": ("Jane", "tw"),
        "aragakiyui": ("結衣", "jp"),
        "thinkaboutzu": ("子瑜", "kr"),
        "emilyinparis": ("艾蜜莉", "fr"),
        "lepetitprince": ("小王子", "b612"),
    ]
}

enum WeatherAPIError: Error {
    case locationNotFound(location: String)
}

public func getWeather(for location: String) async throws -> Double {
    try await Task.sleep(seconds: 1)
    guard let temperature = ["tw": 33.6, "kr": 24.1, "jp": 26, "fr": 28.2][location] else {
        throw WeatherAPIError.locationNotFound(location: location)
    }
    
    return temperature
}

/// 只在無法連上網站時使用這個方式取得翻譯好的 Hello。可以上網時請練習使用 URLSession。
public func getLocalizedHello(of location: String) async throws -> String? {
    try await Task.sleep(seconds: 1)
    return ["kr": "안녕하세요", "fr": "Salut", "tw": "你好", "jp": "こんにちは"][location]
}


// 通用 function
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

// 以下只是轉換 Hello Data 的 function。不需要閱讀。
struct HelloResult: Codable {
    let code: String
    let hello: String
    
    var string: String {
        if !hello.contains(";") { return hello }
        return hello.replacingOccurrences(of: "&#", with: "").split(separator: ";").compactMap{ String(Int($0)!, radix: 16).unicode }.joined()
    }
}

extension String {
    var unicode: String? {
        if let charCode = UInt32(self, radix: 16),
           let unicode = UnicodeScalar(charCode) {
            let str = String(unicode)
            return str
        }
        return nil
    }
}
