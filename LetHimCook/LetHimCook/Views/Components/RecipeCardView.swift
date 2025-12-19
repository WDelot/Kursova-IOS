import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: recipe.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .empty:
                    Color.gray.opacity(0.3)
                default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(height: 200)
            
            VStack(alignment: .leading) {
                Spacer()
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)
                .overlay(
                    Text(recipe.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .padding(),
                    alignment: .bottomLeading
                )
            }
        }
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}
