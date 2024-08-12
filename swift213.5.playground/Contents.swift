// Copy-on-write

//var value = 1
//var value2 = value
//print("＊\(type(of: value))")
//printAddress(&value, tag: "value1")
//printAddress(&value2, tag: "value2")
//print(">> 更新 value2...")
//value2 = 2
//printAddress(&value2, tag: "value2")
//
//
//print("-------------------------")
//
//var array = [1]
//var array2 = array
//print("📦 \(type(of: array))")
//printAddress(&array, tag: "array")
//printAddress(&array2, tag: "array2")
//print(">>>更新 Array2 ...")
//array2 = []
//printAddress(&array2, tag: "array2")
//
//print("-------------------------")
//
//final class Refernce<T> {
//    var value: T
//    
//    init(_ value: T) { self.value = value }
//}
//
//struct CopyOnWriteWrapper<T> {
//    var reference: Refernce<T>
//    
//    var value: T {
//        get { reference.value }
//        set {
//            if isKnownUniquelyReferenced(&reference) {
//                print("沒有其他強連結")
//                reference.value = newValue
//                return
//            }
//            print("還有其他強連結")
//            reference = Refernce(newValue)
//        }
//    }
//    
//    init(_ value: T) {
//        self.reference = Refernce(value)
//    }
//}
//
//
//var cow = CopyOnWriteWrapper(1)
//var cow2 = cow
//print("📦 \(type(of: cow))")
//printAddress(&cow.reference.value, tag: "cow")
//printAddress(&cow2.reference.value, tag: "cow2")
//print(">>>更新 cow2 ...")
//cow2.value = 2
//printAddress(&cow2.reference.value, tag: "cow2")
//cow2.value = 3
//printAddress(&cow2.reference.value, tag: "cow2")



// inout

//func square(_ number: inout Int) {
//    number = number * number
//}
//
//var number = 3 {
//    didSet { print("> 數字從 \(oldValue) 更新為 \(number)") }
//}
//
//square(&number)

//extension String {
//    static func *(string: String, count: Int) -> String {
//        Array.init(repeating: string, count: count).joined()
//    }
//
//    static func *=(string: inout String, count: Int) {
//        string = string * count
//    }
//}
//
//var string = "Hello~"
//string *= 3
//print(string)
//
//var a = 1
//var b = 2
//print(a, b)
//swap(&a, &b)
//print(a, b)





//【ChaoCode】 Swift 中級篇 13.5 Copy-on-write & inout 實作作業


// 這次作業只有一題，請幫下面這個 Bag 類型新增兩個靜態方法。
// 1️⃣ 用 += 搭配 Bag 和 Int，直接更新包包裡的 money。（加上收到的 Int 數值）
// 2️⃣ 用 += 搭配 Bag 和 String，直接新增包包中的 items。（加上收到的 String 數值）

struct Bag {
    var money: Int
    var items: [String]
    
    static func +=(bag: inout Bag, amount: Int) {
        bag.money += amount
    }
    
    static func +=(bag: inout Bag, item: String) {
        bag.items.append(item)
    }
}


// 只要能讓下面的 code 順利執行，在執行時印出「Bag(money: 200, items: ["巧克力", "玫瑰花"])」即可。
var myBag = Bag(money: 100, items: ["巧克力"])
myBag += 100
myBag += "玫瑰花"
print(myBag)




// 💡 下面是示範中用的印位址的方法，你可以自己玩看看。
func printAddress<Value>(_ value: inout Value, tag: String){
    withUnsafePointer(to: &value) { [value] in
        print("\(tag) 的地址（\(value)）： \($0)")
    }
}

func printAddress<Value>(_ array: inout Array<Value>, tag: String) {
    array.withUnsafeBufferPointer {
        let address = $0.baseAddress?.debugDescription ?? "找不到"
        print("\(tag) 的地址（\(array)： \(address)")
    }
}
