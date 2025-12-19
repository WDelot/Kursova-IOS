import Foundation

class APIService {
    static let shared = APIService()
    
    func fetchRecipes(query: String, sort: String = "relevance") async throws -> [Recipe] {
        var urlString = "\(Constants.baseURL)?addRecipeInformation=true&number=20&apiKey=\(Constants.apiKey)&sort=\(sort)"
        
        if !query.isEmpty {
            urlString += "&query=\(query)"
        }
        
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return decodedResponse.results
    }
}
