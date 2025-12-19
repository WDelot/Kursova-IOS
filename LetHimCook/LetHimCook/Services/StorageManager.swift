import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let key = "favorite_recipes"
    
    func saveAll(recipes: [Recipe]) {
        if let data = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func load() -> [Recipe] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let recipes = try? JSONDecoder().decode([Recipe].self, from: data) else {
            return []
        }
        return recipes
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        return load().contains(where: { $0.id == recipe.id })
    }
}
