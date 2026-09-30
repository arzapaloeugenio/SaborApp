import SwiftUI

// MARK: - 1. Botón de favorito reutilizable
struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    var body: some View {
        Button {
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.subheadline)
                .foregroundStyle(isFavorite ? SaborTheme.primary : .secondary)
                .padding(8)
                .background(Color(.systemBackground).opacity(0.9))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 2. Selector de cantidad reutilizable
struct QuantityStepper: View {
    @Binding var quantity: Int
    var body: some View {
        HStack(spacing: 8) {
            Button { if quantity > 1 { quantity -= 1 } } label: {
                Image(systemName: "minus").font(.subheadline).padding(8)
            }
            .tint(.primary)
            Text("\(quantity)").font(.headline).frame(minWidth: 24)
            Button { quantity += 1 } label: {
                Image(systemName: "plus").font(.subheadline).padding(8)
            }
            .tint(.white)
            .background(SaborTheme.primaryContainer)
            .clipShape(Circle())
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .clipShape(Capsule())
    }
}

// MARK: - 3. Insignia de rating
struct RatingBadge: View {
    let rating: Double
    let reviews: Int
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "star.fill").foregroundStyle(SaborTheme.star).font(.caption)
            Text(String(format: "%.1f (%d)", rating, reviews)).font(.subheadline).bold()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color(.systemBackground).opacity(0.92))
        .clipShape(Capsule())
    }
}

// MARK: - 4. Cabecera de sección
struct SectionHeader: View {
    let title: String
    let action: String
    var body: some View {
        HStack(spacing: 8) {
            Text(title).font(.headline)
            Spacer()
            Text(action).font(.subheadline).foregroundStyle(SaborTheme.primary)
        }
    }
}

// MARK: - 5. Imagen de plato (placeholder cálido)
struct DishImageView: View {
    let dish: Dish
    let height: CGFloat
    var body: some View {
        ZStack {
            LinearGradient(colors: [SaborTheme.primaryContainer, SaborTheme.primary], startPoint: .topLeading, endPoint: .bottomTrailing)
            Image(systemName: dish.systemImage)
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.9))
        }
        .frame(height: height)
    }
}

// MARK: - 6. Chip de categoría
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    var body: some View {
        Text(title)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? SaborTheme.secondary : Color(.secondarySystemBackground))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(Capsule())
    }
}

// MARK: - 7. Fila de resumen de precio
struct PriceRow: View {
    let title: String
    let value: String
    var bold = false
    var body: some View {
        HStack(spacing: 8) {
            Text(title).font(bold ? .headline : .subheadline).foregroundStyle(bold ? .primary : .secondary)
            Spacer()
            Text(value).font(bold ? .headline : .subheadline)
        }
    }
}
