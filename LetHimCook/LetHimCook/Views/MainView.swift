import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = RecipeSearchViewModel()
    
    // Виносимо градієнт в окрему змінну, щоб використовувати всюди
    let backgroundGradient = LinearGradient(
        colors: [
            Color("AppBackgroundStart"), // Можна створити в Assets, або використати системні
            Color.orange.opacity(0.15),
            Color.red.opacity(0.1)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        TabView {
            // --- ВКЛАДКА ПОШУКУ ---
            NavigationStack {
                ZStack {
                    // 1. Наш красивий фон
                    backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Кастомний пошуковий рядок
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.orange)
                            TextField("Search recipes...", text: $viewModel.searchText)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(.ultraThinMaterial) // Ефект матового скла
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                        .padding()
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                                .tint(.orange)
                        }
                        
                        ScrollView {
                            LazyVStack(spacing: 25) {
                                ForEach(viewModel.recipes) { recipe in
                                    NavigationLink(destination: DetailView(recipe: recipe, viewModel: viewModel)) {
                                        RecipeCardView(recipe: recipe)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .id(recipe.id)
                                }
                            }
                            .padding(.top)
                            .padding(.bottom, 20) // Відступ, щоб не перекривалось TabBar-ом
                        }
                        .scrollIndicators(.hidden) // Ховаємо скроллбар для чистоти
                    }
                }
                .navigationTitle("") // Прибираємо стандартний заголовок, щоб було більше місця
                .toolbarBackground(.hidden, for: .navigationBar) // Прозорий навбар
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            NavigationStack {
                ZStack {
                    backgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        if viewModel.favorites.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "frying.pan.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.orange.opacity(0.5))
                                Text("No favorites yet")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                Text("Time to cook something tasty!")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 150)
                        } else {
                            LazyVStack(spacing: 25) {
                                ForEach(viewModel.favorites) { recipe in
                                    NavigationLink(destination: DetailView(recipe: recipe, viewModel: viewModel)) {
                                        RecipeCardView(recipe: recipe)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .id(recipe.id)
                                }
                            }
                            .padding(.top)
                        }
                    }
                }
                .navigationTitle("Favorites ❤️")
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
        .accentColor(.orange)
    }
}
