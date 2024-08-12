import Foundation


public func printAddress<Value>(_ value: inout Value, tag: String){
    withUnsafePointer(to: &value){ [value] in
        print("\(tag) 的地址 (\(value)) : \($0)")
        
    }
}

public func printAddress<Value>(_ array: inout Array<Value>, tag: String){
    array.withUnsafeBufferPointer{
        let address = $0.baseAddress?.debugDescription ?? "找不到"
        print("\(tag) 的地址 (\(array)) : \(address)")
    }
}

