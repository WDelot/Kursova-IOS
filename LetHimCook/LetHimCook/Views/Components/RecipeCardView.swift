import SwiftUI

struct RecipeCardView: View {
    let recipe: Recipe
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Картинка
            AsyncImage(url: URL(string: recipe.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 220) // Трохи збільшили висоту
                        .clipped()
                case .empty:
                    Color.gray.opacity(0.3).frame(height: 220)
                default:
                    Color.gray.opacity(0.3).frame(height: 220)
                }
            }
            
            // Затемнення знизу для тексту (Гарніший градієнт)
            LinearGradient(
                colors: [.black.opacity(0.8), .transparent],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 100)
            
            // Текст та інформація
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded)) // Округлий шрифт
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .shadow(radius: 2) // Тінь для тексту, щоб читалось на будь-якому фоні
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text("Tap to cook")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .textCase(.uppercase)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(UIColor.systemBackground)) // Адаптується під темну/світлу тему
        .cornerRadius(20)
        // Магічна тінь (Glow effect)
        .shadow(color: Color.orange.opacity(0.3), radius: 15, x: 0, y: 10)
        .overlay(
            // Тонка рамка-градієнт навколо картки
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [.orange.opacity(0.5), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .padding(.horizontal)
    }
}

// Допоміжний розширення для прозорого кольору
extension Color {
    static let transparent = Color.white.opacity(0)
}
