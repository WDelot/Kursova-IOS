import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = RecipeSearchViewModel()
    
    var body: some View {
        NavigationView {
            TabView {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search recipes (e.g. Pasta)", text: $viewModel.searchText)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.recipes) { recipe in
                                NavigationLink(destination: DetailView(recipe: recipe, viewModel: viewModel)) {
                                    RecipeCardView(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top)
                    }
                }
                .navigationTitle(viewModel.searchText.isEmpty ? "Popular Now 🔥" : "Results")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
                ScrollView {
                    if viewModel.favorites.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "heart.slash")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("No favorites yet")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)
                    } else {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.favorites) { recipe in
                                NavigationLink(destination: DetailView(recipe: recipe, viewModel: viewModel)) {
                                    RecipeCardView(recipe: recipe)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top)
                    }
                }
                .navigationTitle("Favorites ❤️")
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            }
        }
        .accentColor(.orange)
    }
}
