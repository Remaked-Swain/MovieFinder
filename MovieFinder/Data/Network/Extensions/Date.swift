import Foundation

extension Date {
    var asEightPlace: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let formatted = formatter.string(from: self)
        return formatted
    }
}
