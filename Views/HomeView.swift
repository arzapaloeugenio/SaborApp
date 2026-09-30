import SwiftUI

// MARK: - Pantalla: Inicio / Home (claro + oscuro con @State)
struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(CartStore.self) private var cart
    @Environment(FavoritesStore.self) private var favorites
    @State private var favoritesLocal: [Bool] = [false, false]
    @State private var darkMode = false

    var body: some View {
        @Bindable var state = appState
        ScrollView {
            VStack(spacing: 24) {
                HomeHeader(darkMode: $darkMode)
                HomeGreeting()
                HomeSearchBar(text: $state.searchText)
                PromoBanner()
                HomeCategories(selected: $state.selectedCategory)
                BestSellersRow()
                ChefRecommendation()
                SpecialOffer()
            }
            .padding(16)
            .padding(.bottom, 24)
        }
        .background(darkMode ? .black : Color(.systemGroupedBackground))
        .preferredColorScheme(darkMode ? .dark : .light)
        .navigationTitle("Inicio")
    }
}

// Componente 1: cabecera con ubicación y avisos
struct HomeHeader: View {
    @Binding var darkMode: Bool
    @State private var showNotifications = false
    var body: some View {
        HStack(spacing: 8) {
            SaborLogoView()
            Spacer()
            Label("Calle Mayor 24 • Centro", systemImage: "mappin.circle.fill")
                .font(.caption).lineLimit(1)
            Button { showNotifications.toggle() } label: {
                Image(systemName: showNotifications ? "bell.fill" : "bell")
                    .padding(8).background(Color(.secondarySystemBackground)).clipShape(Circle())
            }
            Toggle("", isOn: $darkMode).labelsHidden().tint(SaborTheme.primary)
        }
    }
}

// Componente 2: saludo + buscador
struct HomeGreeting: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("¡Hola, Valentina! 👋").font(.title2).bold()
                Text("¿Qué se te antoja degustar hoy?").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "flame.fill").padding(16).background(SaborTheme.secondaryContainer).clipShape(Circle())
        }
    }
}

struct HomeSearchBar: View {
    @Binding var text: String
    @State private var showFilter = false
    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Buscar hamburguesas, pastas, postres...", text: $text).font(.body)
                if !text.isEmpty { Button { text = "" } label: { Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary) } }
            }
            .padding(16).background(Color(.systemBackground)).clipShape(Capsule())
            Button { showFilter.toggle() } label: {
                Image(systemName: "slider.horizontal.3").padding(16).background(Color(.systemBackground)).clipShape(Circle())
            }
        }
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

// Componente 3: banner promo
struct PromoBanner: View {
    @State private var applied = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Edición Gourmet", systemImage: "sparkles").font(.caption).padding(8)
                .background(.white.opacity(0.2)).clipShape(Capsule())
            Text("Festival de Sabores de Temporada").font(.headline)
            Text("25% de descuento en platos de autor con el código SABOR25").font(.subheadline).opacity(0.9)
            Button(applied ? "¡Oferta aplicada!" : "Aprovechar oferta") { applied.toggle() }
                .font(.headline).padding(.horizontal, 16).padding(.vertical, 8)
                .background(.white).foregroundStyle(SaborTheme.primary).clipShape(Capsule())
            Text("🍷🥩🌿").font(.title)
        }
        .foregroundStyle(.white)
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [SaborTheme.primaryContainer, SaborTheme.primary], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// Componente 4: categorías horizontales
struct HomeCategories: View {
    @Binding var selected: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "Explorar Categorías", action: "Ver todo")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(DishCatalog.categories, id: \.self) { c in
                        Button { selected = c } label: { CategoryChip(title: c, isSelected: selected == c) }
                    }
                }
            }
        }
    }
}

// Componente 5: carrusel más vendidos
struct BestSellersRow: View {
    @Environment(CartStore.self) private var cart
    @Environment(FavoritesStore.self) private var favorites
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "🔥 Más Vendidos", action: "Ver carta")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(DishCatalog.all.prefix(4)) { dish in
                        DishCard(dish: dish)
                            .frame(width: 260)
                    }
                }
            }
        }
    }
}

struct DishCard: View {
    let dish: Dish
    @Environment(CartStore.self) private var cart
    @Environment(FavoritesStore.self) private var favorites
    @State private var localFav = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                DishImageView(dish: dish, height: 144).clipShape(RoundedRectangle(cornerRadius: 12))
                RatingBadge(rating: dish.rating, reviews: dish.reviews).padding(8)
            }
            .overlay(alignment: .topLeading) {
                if let tag = dish.tag {
                    Text(tag).font(.caption).bold().padding(8)
                        .background(SaborTheme.tertiaryFixed).clipShape(Capsule()).padding(8)
                }
            }
            Text(dish.name).font(.headline).lineLimit(1)
            Text(dish.description).font(.caption).foregroundStyle(.secondary).lineLimit(2)
            HStack(spacing: 8) {
                Text(dish.priceText).font(.headline).foregroundStyle(SaborTheme.primary)
                if let old = dish.oldPrice {
                    Text(String(format: "%.2f €", old)).font(.caption).strikethrough().foregroundStyle(.secondary)
                }
                Spacer()
                Button { cart.add(dish) } label: {
                    Image(systemName: cart.quantity(for: dish) > 0 ? "checkmark" : "plus")
                        .padding(8).background(SaborTheme.primary).foregroundStyle(.white).clipShape(Circle())
                }
            }
            FavoriteButton(isFavorite: $localFav)
        }
        .padding(16)
        .saborCard()
    }
}

// Componente 6: recomendado del chef
struct ChefRecommendation: View {
    @State private var ordered = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "👍 Recomendado para ti", action: "")
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12).fill(SaborTheme.secondaryContainer)
                    .frame(width: 112, height: 112)
                    .overlay(Image(systemName: "fish.fill").font(.largeTitle).foregroundStyle(SaborTheme.secondary))
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recomendado del Chef").font(.caption).bold()
                        .padding(.horizontal, 8).padding(.vertical, 8)
                        .background(SaborTheme.secondaryContainer).clipShape(Capsule())
                    Text("Salmón Glaseado al Miso").font(.headline)
                    Text("Espárragos trigueros y puré de chirivía.").font(.caption).foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        Text("18,50 €").font(.headline).foregroundStyle(SaborTheme.primary)
                        Spacer()
                        Button(ordered ? "Añadido ✓" : "Pedir") { ordered.toggle() }
                            .font(.subheadline).bold().padding(.horizontal, 16).padding(.vertical, 8)
                            .background(SaborTheme.secondary).foregroundStyle(.white).clipShape(Capsule())
                    }
                }
            }
            .padding(16).saborCard()
        }
    }
}

// Componente 7: oferta especial
struct SpecialOffer: View {
    @State private var added = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title: "🎁 Ofertas Especiales", action: "Ver 4 ofertas")
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    DishImageView(dish: DishCatalog.all[6], height: 160).clipShape(RoundedRectangle(cornerRadius: 12))
                    Text("-20% HOY").font(.caption).bold().padding(8)
                        .background(SaborTheme.error).foregroundStyle(.white).clipShape(Capsule()).padding(8)
                }
                Text("Horno de leña").font(.caption).foregroundStyle(.secondary)
                Text("Pizza Tartufata & Burrata").font(.headline)
                HStack(spacing: 8) {
                    Text("13,20 €").font(.headline).foregroundStyle(SaborTheme.primary)
                    Text("16,50 €").font(.caption).strikethrough().foregroundStyle(.secondary)
                    Spacer()
                    Button(added ? "Añadido ✓" : "Añadir") { added.toggle() }
                        .font(.subheadline).bold().padding(.horizontal, 16).padding(.vertical, 8)
                        .background(SaborTheme.primaryContainer).foregroundStyle(.white).clipShape(Capsule())
                }
            }
            .padding(16).saborCard()
        }
    }
}

#Preview { HomeView().environment(AppState()).environment(CartStore()).environment(FavoritesStore()) }
