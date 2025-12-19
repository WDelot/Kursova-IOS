import SwiftUI

struct DetailView: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeSearchViewModel
    
    // Стан для показу повідомлення
    @State private var showToast: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Image
                    AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle().fill(Color.gray.opacity(0.3))
                    }
                    .frame(height: 250)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            Text(recipe.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(
                                    LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing)
                                )
                                .layoutPriority(1)
                            
                            Spacer()
                            
                            Button {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred()
                                
                                viewModel.toggleFavorite(recipe)
                                
                                if viewModel.isFavorite(recipe) {
                                    withAnimation {
                                        showToast = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            showToast = false
                                        }
                                    }
                                }
                                
                            } label: {
                                Image(systemName: viewModel.isFavorite(recipe) ? "heart.fill" : "heart")
                                    .font(.system(size: 28))
                                    .foregroundColor(viewModel.isFavorite(recipe) ? .red : .gray)
                                    .padding(10)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        Divider()
                        
                        if let summary = recipe.summary {
                            Text("Summary")
                                .font(.headline)
                            Text(summary.strippedHTML)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        
                        if let instructions = recipe.instructions {
                            Text("Instructions")
                                .font(.headline)
                                .padding(.top, 10)
                            Text(instructions.strippedHTML)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                    .padding()
                    .padding(.bottom, 60)
                }
            }
            
            if showToast {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Recipe saved successfully!")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(25)
                .padding(.bottom, 30) // Відступ від нижнього краю екрану
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .zIndex(1) // Гарантує, що воно буде поверх усього
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: URL(string: "https://spoonacular.com/recipes/\(recipe.title.replacingOccurrences(of: " ", with: "-"))-\(recipe.id)")!) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
