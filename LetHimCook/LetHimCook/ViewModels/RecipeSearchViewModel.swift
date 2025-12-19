import Foundation
import Combine
import SwiftUI

@MainActor
class RecipeSearchViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var favorites: [Recipe] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        favorites = StorageManager.shared.load()
        
        Task {
            await loadPopularRecipes()
        }
        
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                if text.isEmpty {
                    Task { await self?.loadPopularRecipes() }
                } else {
                    Task { await self?.searchRecipes(query: text) }
                }
            }
            .store(in: &cancellables)
    }
    
    func loadPopularRecipes() async {
        isLoading = true
        do {
            let results = try await APIService.shared.fetchRecipes(query: "", sort: "popularity")
            self.recipes = results
        } catch {
            print("Error loading popular: \(error)")
        }
        isLoading = false
    }
    
    func searchRecipes(query: String) async {
        isLoading = true
        do {
            let results = try await APIService.shared.fetchRecipes(query: query, sort: "relevance")
            self.recipes = results
        } catch {
            print("Error searching: \(error)")
        }
        isLoading = false
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        if let index = favorites.firstIndex(where: { $0.id == recipe.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(recipe)
        }
        
        let recipesToSave = favorites
        
        Task.detached(priority: .background) {
            StorageManager.shared.saveAll(recipes: recipesToSave)
        }
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        return favorites.contains(where: { $0.id == recipe.id })
    }
}
