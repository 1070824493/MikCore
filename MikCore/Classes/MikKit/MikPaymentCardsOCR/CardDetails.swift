import Foundation

public struct CardDetails: Codable {
    
    public var cardNumber: String?
    public var cardName: String?
    public var cardExpiry: String?
      
    subscript(key: String) -> String? {
        get {
          switch key {
          case "cardNumber": return self.cardNumber
          case "cardName": return self.cardName
          case "cardExpiry": return self.cardExpiry
          default: fatalError("Invalid key")
          }
        }set {
          switch key {
          case "cardNumber": self.cardNumber = newValue
          case "cardName": self.cardName = newValue
          case "cardExpiry": self.cardExpiry = newValue
          default: fatalError("Invalid key")
          }
        }
    }
    
}

extension CardDetails: CustomStringConvertible {
    
    public var description: String {
        return "name: \(String(describing: self.cardName)), number: \(self.cardNumber ?? ""), expiry: \(self.cardExpiry ?? "")"
    }
    
}
