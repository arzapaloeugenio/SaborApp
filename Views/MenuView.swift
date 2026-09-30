import SwiftUI

// MARK: - Pantalla: Menú completo (claro/oscuro)
struct MenuView: View {
    @Environment(AppState.self) private var appState
    @State private var sortPopular = true
    @State private var quickFilter = "Más de 4.8"
    @State private var cartCount = 2

    var body: some View {
        @Bindable var state = appState
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    MenuSearchBar(text: $state.searchText)
                    MenuToolbar(sortPopular: $sortPopular)
                    MenuCategories(selected: $state.selectedCategory)
                    QuickFilters(selected: $quickFilter)
                    ResultsBanner()
                    LazyVStack(spacing: 16) {
                        ForEach(filtered) { dish in MenuDishRow(dish: dish) }
                    }
                }
                .padding(16)
                .padding(.bottom, 80)
            }
            CartStickyBar(total: "29,10 €", count: cartCount)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Menú de Temporada")
    }

    var filtered: [Dish] {
        if appState.selectedCategory == "Todas" { return DishCatalog.all }
        return DishCatalog.all.filter { $0.category == appState.selectedCategory }
    }
}

// Componente 1: buscador con mic
struct MenuSearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Buscar por plato o ingrediente...", text: $text).font(.body)
            Image(systemName: "mic.fill").foregroundStyle(.secondary)
        }
        .padding(16).background(Color(.systemBackground)).clipShape(Capsule())
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// Componente 2: ordenar + filtrar
struct MenuToolbar: View {
    @Binding var sortPopular: Bool
    @State private var filterCount = 2
    var body: some View {
        HStack(spacing: 8) {
            Button { sortPopular.toggle() } label: {
                Label(sortPopular ? "Ordenar: Popularidad" : "Ordenar: Precio", systemImage: "arrow.up.arrow.down")
                    .font(.subheadline)
            }
            .padding(.horizontal, 16).padding(.vertical, 8)
            .background(Color(.systemBackground)).clipShape(Capsule())
            Spacer()
            Button { filterCount = (filterCount + 1) % 4 } label: {
                Label("Filtrar (\(filterCount))", systemImage: "slider.horizontal.3").font(.subheadline)
            }
            .padding(.horizontal, 16).padding(.vertical, 8)
            .background(SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
        }
        .tint(.primary)
    }
}

// Componente 3: categorías
struct MenuCategories: View {
    @Binding var selected: String
    let items = ["Hamburguesas Gourmet", "Entrantes", "Pastas Frescas", "Carnes & Pescados", "Vegetarianas", "Postres Artesanales"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { c in
                    Button { selected = c == "Hamburguesas Gourmet" ? "Hamburguesas" : c } label: {
                        CategoryChip(title: c, isSelected: selected == c || (selected == "Hamburguesas" && c == "Hamburguesas Gourmet") || (selected == "Todas" && c == items[0]))
                    }
                }
            }
        }
    }
}

// Componente 4: filtros rápidos
struct QuickFilters: View {
    @Binding var selected: String
    let items = ["🌿 Vegano", "🌾 Sin Gluten", "★ Más de 4.8", "⚡ Menos de 30 min"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { f in
                    Button { selected = f } label: {
                        Text(f).font(.caption)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(selected == f ? SaborTheme.tertiaryFixed : Color(.systemBackground))
                            .clipShape(Capsule())
                    }
                    .tint(.primary)
                }
            }
        }
    }
}

// Componente 5: banner resultados
struct ResultsBanner: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Menú de Temporada").font(.headline)
                Text("34 platos artesanos disponibles hoy").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Label("Cocina activa", systemImage: "circle.fill").font(.caption)
                .padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule())
        }
        .padding(16).saborCard()
    }
}

// Componente 6: fila de plato del menú
struct MenuDishRow: View {
    let dish: Dish
    @Environment(CartStore.self) private var cart
    @State private var isFav = false
    @State private var added = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                DishImageView(dish: dish, height: 176).clipShape(RoundedRectangle(cornerRadius: 12))
                FavoriteButton(isFavorite: $isFav).padding(8)
            }
            .overlay(alignment: .topLeading) {
                if let tag = dish.tag { Text(tag).font(.caption).bold().padding(8).background(.ultraThinMaterial).clipShape(Capsule()).padding(8) }
            }
            HStack(spacing: 8) {
                Text(dish.name).font(.headline)
                Spacer()
                Image(systemName: "star.fill").foregroundStyle(SaborTheme.star).font(.caption)
                Text(String(format: "%.1f (%d)", dish.rating, dish.reviews)).font(.caption)
            }
            Text(dish.description).font(.subheadline).foregroundStyle(.secondary).lineLimit(2)
            HStack(spacing: 8) {
                Text(dish.priceText).font(.headline).foregroundStyle(SaborTheme.primary)
                Spacer()
                Button(added ? "Añadido ✓" : "Añadir +") {
                    added.toggle(); cart.add(dish)
                }
                .font(.subheadline).bold().padding(.horizontal, 16).padding(.vertical, 8)
                .background(added ? SaborTheme.secondary : SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
            }
        }
        .padding(16).saborCard()
    }
}

// Componente 7: barra sticky cesta
struct CartStickyBar: View {
    let total: String
    let count: Int
    var body: some View {
        HStack(spacing: 16) {
            Label("Mi Selección · \(total)", systemImage: "shopping.bag.fill").font(.headline)
            Spacer()
            ZStack(alignment: .topTrailing) {
                Text("Ver Cesta →").font(.subheadline).bold()
                    .padding(.horizontal, 16).padding(.vertical, 8)
                    .background(.white).foregroundStyle(SaborTheme.primary).clipShape(Capsule())
                Text("\(count)").font(.caption).bold().padding(8)
                    .background(SaborTheme.error).foregroundStyle(.white).clipShape(Circle())
                    .offset(x: 8, y: -8)
            }
        }
        .foregroundStyle(.white)
        .padding(16)
        .background(SaborTheme.primary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(16)
    }
}

#Preview { MenuView().environment(AppState()).environment(CartStore()).environment(FavoritesStore()) }
