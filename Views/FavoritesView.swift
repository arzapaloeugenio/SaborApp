import SwiftUI

// MARK: - Pantalla: Favoritos
struct FavoritesView: View {
    @Environment(CartStore.self) private var cart
    @State private var query = ""
    @State private var filter = "Todos"
    @State private var showEmpty = false
    @State private var toast: String?

    var body: some View {
        VStack(spacing: 16) {
            FavoritesHeader(count: 4)
            FavoritesSegment(showEmpty: $showEmpty)
            FavoritesSearch(query: $query)
            FavoritesChips(filter: $filter)
            if showEmpty {
                FavoritesEmptyState()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(DishCatalog.all.prefix(4)) { dish in
                            FavoriteCard(dish: dish, toast: $toast)
                        }
                    }
                }
            }
            if let toast {
                Label(toast, systemImage: "checkmark.circle.fill")
                    .font(.subheadline).padding(16)
                    .background(Color(.label)).foregroundStyle(Color(.systemBackground)).clipShape(Capsule())
            }
        }
        .padding(16)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Mis Favoritos")
    }
}

// Componente 1: cabecera con limpiar
struct FavoritesHeader: View {
    let count: Int
    @State private var cleared = false
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("Mis Favoritos").font(.title2).bold()
                    Text("\(cleared ? 0 : count)").font(.caption).bold().padding(8)
                        .background(SaborTheme.primary).foregroundStyle(.white).clipShape(Circle())
                }
                Text("Tus elecciones gastronómicas predilectas").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Button(cleared ? "Listo" : "Limpiar") { cleared.toggle() }
                .font(.subheadline).tint(SaborTheme.primary)
        }
    }
}

// Componente 2: segmented guardados / vacío
struct FavoritesSegment: View {
    @Binding var showEmpty: Bool
    var body: some View {
        HStack(spacing: 8) {
            Button { showEmpty = false } label: {
                Label("Guardados (4)", systemImage: "heart.fill").font(.subheadline)
                    .frame(maxWidth: .infinity).padding(8)
                    .background(!showEmpty ? Color(.systemBackground) : .clear).clipShape(Capsule())
            }
            Button { showEmpty = true } label: {
                Label("Ver estado vacío", systemImage: "heart").font(.subheadline)
                    .frame(maxWidth: .infinity).padding(8)
                    .background(showEmpty ? Color(.systemBackground) : .clear).clipShape(Capsule())
            }
        }
        .padding(8).background(Color(.secondarySystemBackground)).clipShape(Capsule())
        .tint(.primary)
    }
}

// Componente 3: búsqueda + chips
struct FavoritesSearch: View {
    @Binding var query: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Buscar en mis favoritos...", text: $query).font(.body)
        }
        .padding(16).background(Color(.systemBackground)).clipShape(Capsule())
    }
}

struct FavoritesChips: View {
    @Binding var filter: String
    let items = ["Todos (4)", "Principales (2)", "Postres (1)", "Ofertas (1)"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { f in
                    Button { filter = f } label: { CategoryChip(title: f, isSelected: filter == f) }
                }
            }
        }
    }
}

// Componente 4: tarjeta de favorito
struct FavoriteCard: View {
    let dish: Dish
    @Binding var toast: String?
    @Environment(CartStore.self) private var cart
    @State private var isFav = true
    @State private var added = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                DishImageView(dish: dish, height: 176).clipShape(RoundedRectangle(cornerRadius: 12))
                FavoriteButton(isFavorite: $isFav).padding(8)
            }
            .overlay(alignment: .topLeading) {
                Text(dish.tag ?? "").font(.caption).bold().padding(8).background(.ultraThinMaterial).clipShape(Capsule()).padding(8)
            }
            HStack(spacing: 8) {
                Text(dish.name).font(.headline)
                Spacer()
                Text(dish.priceText).font(.headline).foregroundStyle(SaborTheme.primary)
            }
            Text(dish.description).font(.caption).foregroundStyle(.secondary).lineLimit(2)
            HStack(spacing: 8) {
                Label(String(format: "%.1f", dish.rating), systemImage: "star.fill").font(.caption)
                Label(dish.time, systemImage: "clock").font(.caption).foregroundStyle(.secondary)
                Spacer()
                Button(added ? "Agregado ✓" : "Agregar") {
                    added = true; cart.add(dish); toast = "Plato agregado a tu pedido"
                }
                .font(.subheadline).bold().padding(.horizontal, 16).padding(.vertical, 8)
                .background(SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
            }
        }
        .padding(16).saborCard()
    }
}

// Componente 5: estado vacío + recomendados
struct FavoritesEmptyState: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Image(systemName: "room.service.fill").font(.system(size: 56)).foregroundStyle(SaborTheme.primary.opacity(0.3))
                Image(systemName: "heart").font(.title).foregroundStyle(SaborTheme.primary)
            }
            Text("Aún no tienes platos favoritos").font(.headline)
            Text("Explora nuestra carta y pulsa el corazón de los platos que más te gusten.").font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Button { } label: {
                Label("Explorar la carta completa", systemImage: "fork.knife").saborPrimaryButton()
            }
            SectionHeader(title: "Recomendados por el Chef", action: "Populares hoy")
            HStack(spacing: 16) {
                MiniRecommend(name: "Ramen Tonkotsu", price: "13,90 €")
                MiniRecommend(name: "Gyozas de Ibérico", price: "9,80 €")
            }
        }
        .padding(16).saborCard()
    }
}

struct MiniRecommend: View {
    let name: String; let price: String
    @State private var fav = false
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12).fill(SaborTheme.secondaryContainer).frame(height: 96)
                FavoriteButton(isFavorite: $fav).padding(8)
            }
            Text(name).font(.subheadline).bold()
            Text(price).font(.subheadline).foregroundStyle(SaborTheme.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview { FavoritesView().environment(CartStore()) }
