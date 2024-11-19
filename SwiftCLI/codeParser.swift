import Foundation

struct Response: Codable {
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let name: String
    let fields: Fields?
    let createTime, updateTime: String
}

// MARK: - Fields
struct Fields: Codable {
    let code: Code?
    let arrayField: ArrayField?
}

// MARK: - ArrayField
struct ArrayField: Codable {
    let arrayValue: ArrayValue
}

// MARK: - ArrayValue
struct ArrayValue: Codable {
    let values: [Code]
}

// MARK: - Code
struct Code: Codable {
    let stringValue: String
}

func processJSONString(_ jsonString: String) -> String {
    return jsonString.replacingOccurrences(of: "\n", with: "\\n")
}


/// JSON 파일에서 name과 code를 추출하여 출력합니다.
/// - Parameter filePath: JSON 파일 경로
func parseJSONFile(at filePath: String) {
    do {
        // 파일 읽기
        let fileURL = URL(fileURLWithPath: filePath)
        let response = try String(contentsOf: fileURL, encoding: .utf8)
        let replacedString = response.replacingOccurrences(of: "\n", with: "\\n")
        let jsonData = replacedString.data(using: .utf8)!
        
        // JSON 디코딩
        let decodedData = try JSONDecoder().decode(Response.self, from: jsonData)
        
        print(String(data: jsonData, encoding: .utf8)!)
        
        print(decodedData)
        
//        // documents 배열에서 name과 code 추출
//        for document in decodedData.documents {
//            let name = document.name
//            let code = document.fields.code?.stringValue ?? "N/A"
//            print("Name: \(name)")
//            print("Code: \(code)\n")
//        }
    } catch {
        print("❌ JSON 파싱 오류: \(error.localizedDescription)")
    }
}

/// CLI 실행
func main(arguments: [String]) {
    guard arguments.count > 1 else {
        print("❌ 사용법: json_parser <JSON 파일 경로>")
        return
    }
    
    let filePath = arguments[1]
    parseJSONFile(at: filePath)
}

main(arguments: CommandLine.arguments)
