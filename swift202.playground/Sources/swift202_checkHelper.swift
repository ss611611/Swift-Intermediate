typealias TestData = (定存金額: Int, 年數: Int, 年利率: Double, 報酬率: Double, 期滿領回: Int)

public protocol HomeworkProtocol {
    var 金額: Int { get set }
    var 年數: Int { get set }
    var 期滿領回: Int { get }
    var 報酬率: Double { get }
    var 描述: String { get }
    
    init(_ 金額: Int, 年數: Int)
}

public func 利率檢查<T: HomeworkProtocol>(type: T.Type) {
    let testYear: [TestData] = [(10000, 6, 0.0115, 0.071, 10710), (10000, 10, 0.012, 0.1266, 11266), (10000, 11, 0.012, 0.1402, 11402), (10000, 20, 0.022, 0.5453, 15453)]
    
    func dataCheck(data: T, answer: TestData) -> Bool {
        if (data.期滿領回 != answer.期滿領回) {
            print("❌ 存款金額：\(answer.定存金額) 年數：\(answer.年數) 應領回 \(answer.期滿領回)，您的計算結果是 \(data.期滿領回)")
            return false
        }
        if (data.報酬率 != answer.報酬率) {
            print("❌ 存款金額：\(answer.定存金額) 年數：\(answer.年數) 期滿領回 \(answer.期滿領回)，報酬率應為 \(answer.報酬率)，您的計算結果是 \(data.報酬率)")
            return false
        }
        
        return true
    }
    
    
    let initTest: [TestData] = [(10000, 6, 0.0115,0.071, 10710), (19000, 12, 0.012,0.1538421052631579, 21923), (100000, 25, 0.032,1.19782, 219782), (80000, 20, 0.032,0.87755, 150204), (153000, 10, 0.022,0.2431045751633987, 190195), (250000, 6, 0.0335,0.218604, 304651), (2000000, 8, 0.0615,0.611981, 3223962), (79999, 15, 0.012,0.19592744909311366, 95673), (200000, 11, 0.034,0.444525, 288905), (1000000, 19, 0.062,2.135926, 3135926)]
    
    
    for testCase in initTest {
        let data = T(testCase.定存金額, 年數: testCase.年數)
        let isCorrect = dataCheck(data: data, answer: testCase)
        if !isCorrect { return }
    }
    print("✅ 您的資料啟動沒有問題。")
    
    var index = 0
    var testCase = testYear.first!
    var data = T(testCase.定存金額, 年數: testCase.年數)
    repeat {
        let isCorrect = dataCheck(data: data, answer: testCase)
        if !isCorrect { return }

        index += 1
        testCase = testYear[index]
        data.年數 = testCase.年數
    } while (index < testYear.count - 1)
    print("✅ 您的定存年份更新沒有問題。")
    
    let testAmount: [TestData] = [(20000, 20, 0.022, 0.5453, 30906), (80000, 20, 0.032, 0.87755, 150204), (125000, 20, 0.032, 0.87756, 234695), (200000, 20, 0.044, 1.36597, 473194), (1000000, 20, 0.072, 3.016943, 4016943)]
    
    index = 0
    testCase = testAmount.first!
    data = T(testCase.定存金額, 年數: testCase.年數)
    repeat {
        let isCorrect = dataCheck(data: data, answer: testCase)
        if !isCorrect { return }
        
        index += 1
        testCase = testAmount[index]
        data.金額 = testCase.定存金額
    } while (index < testYear.count - 1)
    print("✅ 您的定存金額更新沒有問題。")
}
