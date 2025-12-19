import Foundation

struct RecipeResponse: Codable {
    let results: [Recipe]
}

struct Recipe: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let image: String?
    let summary: String?
    let instructions: String?
}
