import SwiftUI

// MARK: - Pantalla: Detalle del plato
struct DishDetailView: View {
    let dish: Dish = DishCatalog.all[0]
    @Environment(CartStore.self) private var cart
    @State private var isFavorite = true
    @State private var quantity = 1
    @State private var meatPoint = "Al punto"
    @State private var side = "Patatas gajo al romero"
    @State private var extras: Set<String> = []
    @State private var showNutrition = false

    var extrasPrice: Double {
        (extras.contains("Bacon") ? 1.50 : 0) + (extras.contains("Huevo") ? 1.20 : 0) + (extras.contains("Trufa") ? 1.00 : 0)
    }
    var total: Double { (dish.price + extrasPrice) * Double(quantity) }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    DishHero(isFavorite: $isFavorite, dish: dish)
                    DishTitlePrice(dish: dish)
                    DishMetaRow()
                    DishDescription()
                    IngredientsList()
                    NutritionAccordion(expanded: $showNutrition)
                    CustomizationSection(meatPoint: $meatPoint, side: $side, extras: $extras)
                }
                .padding(16)
                .padding(.bottom, 100)
            }
            DishBottomBar(quantity: $quantity, total: total)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Detalle del Plato")
    }
}

// Componente 1: hero con favorito
struct DishHero: View {
    @Binding var isFavorite: Bool
    let dish: Dish
    var body: some View {
        ZStack(alignment: .topTrailing) {
            DishImageView(dish: dish, height: 320).clipShape(RoundedRectangle(cornerRadius: 16))
            FavoriteButton(isFavorite: $isFavorite).padding(16)
        }
        .overlay(alignment: .bottomLeading) {
            Label("Plato de Autor", systemImage: "flame.fill").font(.caption).bold()
                .padding(8).background(.ultraThinMaterial).clipShape(Capsule()).padding(16)
        }
    }
}

// Componente 2: título + precio
struct DishTitlePrice: View {
    let dish: Dish
    var body: some View {
        HStack(spacing: 8) {
            Text(dish.name).font(.title2).bold()
            Spacer()
            Text(dish.priceText).font(.title3).bold().foregroundStyle(SaborTheme.primary)
        }
    }
}

// Componente 3: meta pills
struct DishMetaRow: View {
    var body: some View {
        HStack(spacing: 8) {
            Label("4.9 (428)", systemImage: "star.fill").font(.caption)
            Label("20-25 min", systemImage: "clock").font(.caption)
            Label("680 kcal", systemImage: "flame").font(.caption)
        }
        .foregroundStyle(.secondary)
        .padding(8).background(Color(.systemBackground)).clipShape(Capsule())
    }
}

// Componente 4: descripción + ingredientes
struct DishDescription: View {
    var body: some View {
        Text("Nuestra creación estrella: 180g de carne de ternera madurada 45 días a la brasa, queso brie fundido, cebolla caramelizada al vino tinto y mahonesa artesanal de trufa negra en pan brioche artesano.")
            .font(.body).foregroundStyle(.primary)
    }
}

struct IngredientsList: View {
    let items = ["Ternera madurada 100%", "Queso Brie AOC", "Pan brioche mantequilla", "Trufa negra de verano", "Cebolla dulce pochada"]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredientes seleccionados").font(.headline)
            ForEach(items, id: \.self) { i in
                Label(i, systemImage: "checkmark.seal.fill").font(.subheadline).foregroundStyle(SaborTheme.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16).saborCard()
    }
}

// Componente 5: acordeón nutricional
struct NutritionAccordion: View {
    @Binding var expanded: Bool
    var body: some View {
        VStack(spacing: 8) {
            Button { expanded.toggle() } label: {
                HStack(spacing: 8) {
                    Label("Información nutricional y Alérgenos", systemImage: "info.circle").font(.headline)
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down").foregroundStyle(.secondary)
                }
            }
            .tint(.primary)
            if expanded {
                Text("Alérgenos: Lácteos, Gluten").font(.subheadline).foregroundStyle(SaborTheme.error)
                HStack(spacing: 16) {
                    NutrientBox(value: "42g", label: "Proteínas")
                    NutrientBox(value: "36g", label: "Grasas")
                    NutrientBox(value: "48g", label: "Carbohidratos")
                }
            }
        }
        .padding(16).saborCard()
    }
}

struct NutrientBox: View {
    let value: String; let label: String
    var body: some View {
        VStack(spacing: 8) {
            Text(value).font(.headline)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(8).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// Componente 6: personalización
struct CustomizationSection: View {
    @Binding var meatPoint: String
    @Binding var side: String
    @Binding var extras: Set<String>
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Text("Personaliza tu plato").font(.headline)
                Text("A tu gusto").font(.caption).padding(8).background(SaborTheme.tertiaryFixed).clipShape(Capsule())
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Punto de la carne · Obligatorio").font(.subheadline).bold()
                ForEach(["Al punto", "Poco hecha", "Muy hecha"], id: \.self) { o in
                    Button { meatPoint = o } label: {
                        HStack(spacing: 8) {
                            Image(systemName: meatPoint == o ? "checkmark.circle.fill" : "circle").foregroundStyle(SaborTheme.primary)
                            Text(o).font(.body)
                            if o == "Al punto" { Text("Recomendado").font(.caption).padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule()) }
                        }
                    }
                    .tint(.primary)
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Guarnición incluida · Obligatorio").font(.subheadline).bold()
                ForEach(["Patatas gajo al romero (Incluido)", "Boniato crujiente (+1,00 €)", "Ensalada verde (Incluido)"], id: \.self) { o in
                    Button { side = o } label: {
                        HStack(spacing: 8) {
                            Image(systemName: side == o ? "checkmark.circle.fill" : "circle").foregroundStyle(SaborTheme.primary)
                            Text(o).font(.body)
                        }
                    }
                    .tint(.primary)
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("Extras recomendados · Opcional").font(.subheadline).bold()
                ExtraToggle(title: "Bacon ahumado crujiente +1,50 €", key: "Bacon", selected: $extras)
                ExtraToggle(title: "Huevo campero a la plancha +1,20 €", key: "Huevo", selected: $extras)
                ExtraToggle(title: "Extra salsa de trufa +1,00 €", key: "Trufa", selected: $extras)
            }
        }
        .padding(16).saborCard()
    }
}

struct ExtraToggle: View {
    let title: String; let key: String; @Binding var selected: Set<String>
    var body: some View {
        Button { selected.contains(key) ? selected.remove(key) : selected.insert(key) } label: {
            HStack(spacing: 8) {
                Image(systemName: selected.contains(key) ? "checkmark.square.fill" : "square").foregroundStyle(SaborTheme.primary)
                Text(title).font(.body)
            }
        }
        .tint(.primary)
    }
}

// Componente 7: barra inferior
struct DishBottomBar: View {
    @Binding var quantity: Int
    let total: Double
    var body: some View {
        HStack(spacing: 16) {
            QuantityStepper(quantity: $quantity)
            Button { } label: {
                Label(String(format: "Agregar · %.2f €", total).replacingOccurrences(of: ".", with: ","), systemImage: "shopping.bag")
                    .font(.headline).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(16)
                    .background(SaborTheme.primary).clipShape(Capsule())
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
    }
}

#Preview { DishDetailView().environment(CartStore()) }
