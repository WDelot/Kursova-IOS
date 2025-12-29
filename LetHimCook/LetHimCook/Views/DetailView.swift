import SwiftUI

struct DetailView: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeSearchViewModel
    @State private var showToast: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [Color(UIColor.systemBackground), Color.orange.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 300)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.black.opacity(0.6), .clear],
                            startPoint: .bottom,
                            endPoint: .center
                        )
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            Text(recipe.title)
                                .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing)
                                )
                                .layoutPriority(1)
                            
                            Spacer()
                            
                            FavoriteButton(recipe: recipe, viewModel: viewModel)
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        if let summary = recipe.summary {
                            Text("Summary")
                                .font(.system(.headline, design: .rounded))
                            Text(summary.strippedHTML)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(6)
                        }
                        
                        if let instructions = recipe.instructions {
                            Text("Instructions")
                                .font(.system(.headline, design: .rounded))
                                .padding(.top, 10)
                            Text(instructions.strippedHTML)
                                .font(.body)
                                .lineSpacing(6)
                        }
                    }
                    .padding(24)
                    .padding(.bottom, 60)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .offset(y: -40)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            if showToast {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Saved to favorites!")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Material.ultraThin)
                .background(Color.black.opacity(0.8))
                .cornerRadius(25)
                .shadow(radius: 10)
                .padding(.bottom, 30)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: URL(string: "https://spoonacular.com/recipes/\(recipe.title.replacingOccurrences(of: " ", with: "-"))-\(recipe.id)")!) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .foregroundColor(.primary)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.favorites) { _ in
            if viewModel.isFavorite(recipe) {
                withAnimation { showToast = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { showToast = false }
                }
            }
        }
    }
}

struct FavoriteButton: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeSearchViewModel
    
    var body: some View {
        Button {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            viewModel.toggleFavorite(recipe)
        } label: {
            Image(systemName: viewModel.isFavorite(recipe) ? "heart.fill" : "heart")
                .font(.system(size: 24))
                .foregroundColor(viewModel.isFavorite(recipe) ? .red : .gray)
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                .animation(.default, value: viewModel.favorites)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
