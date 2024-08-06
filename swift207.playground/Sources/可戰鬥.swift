import Foundation

public protocol 可戰鬥 {
    associatedtype Level: Strideable where Level.Stride == Int
    
    var name: String{ get }
    var hp: Int{ get set }
    var 最大hp: Int{ get set }
    var 攻擊力: Int{ get set }
    var 等級: Level { get set }
    
    init()
    
        
}

extension 可戰鬥 {
    public mutating func 休息() {
        hp = 最大hp
        print("😴 \(name) 睡飽了，HP 補滿！")
    }
    
    public mutating func 升級() {
        最大hp = Int(Double(最大hp) * 1.1)
        hp = 最大hp
        攻擊力 = Int(Double(攻擊力) * 1.2)
        等級 = 等級.advanced(by: 1)
        print("✨\(name) 升至 \(等級) 級了，現在 hp 為 \(hp)：攻擊力為 \(攻擊力)。")
    }
    
    public func 攻擊<T: 可戰鬥>(on target: inout T) {
        target.hp -= self.攻擊力
        print("⚔️ \(name) 對 \(target.name) 造成 \(攻擊力) 點傷害，\(target.name) 剩下 \(target.hp) 點 HP。")
    }
}
