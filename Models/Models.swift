import SwiftUI
import Observation

struct Dish: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let price: Double
    let oldPrice: Double?
    let rating: Double
    let reviews: Int
    let time: String
    let tag: String?
    let category: String
    let systemImage: String

    var priceText: String {
        String(format: "%.2f €", price).replacingOccurrences(of: ".", with: ",")
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let dish: Dish
    var quantity: Int
    var note: String
}

struct OrderInfo: Identifiable {
    let id: String
    let date: String
    let status: String
    let dishesText: String
    let total: Double
    let isActive: Bool
    let rating: Double?
}

struct AppNotification: Identifiable {
    let id = UUID()
    let group: String
    let badge: String
    let time: String
    let title: String
    let body: String
}

struct AddressItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let street: String
    let notes: String
    let phone: String
    let isDefault: Bool
}

@Observable
final class CartStore {
    var items: [CartItem] = []
    var coupon: String = "SABOR25"
    var couponApplied: Bool = true
    var cutlery: Bool = true

    var subtotal: Double { items.reduce(0) { $0 + $1.dish.price * Double($1.quantity) } }
    var delivery: Double { 2.50 }
    var service: Double { 0.90 }
    var discount: Double { couponApplied ? 8.00 : 0 }
    var total: Double { max(0, subtotal + delivery + service - discount) }

    func quantity(for dish: Dish) -> Int {
        items.first(where: { $0.dish.id == dish.id })?.quantity ?? 0
    }

    func add(_ dish: Dish) {
        if let i = items.firstIndex(where: { $0.dish.id == dish.id }) {
            items[i].quantity += 1
        } else {
            items.append(CartItem(dish: dish, quantity: 1, note: "Receta original"))
        }
    }

    func sampleData() {
        if items.isEmpty {
            let d = DishCatalog.all
            items = [
                CartItem(dish: d[0], quantity: 1, note: "Al punto • Bacon ahumado • Patatas gajo"),
                CartItem(dish: d[1], quantity: 1, note: "Receta original • Sin modificaciones"),
                CartItem(dish: d[4], quantity: 2, note: "7,50 € cada unidad")
            ]
        }
    }
}

@Observable
final class FavoritesStore {
    var ids: Set<UUID> = []
    func toggle(_ dish: Dish) {
        if ids.contains(dish.id) { ids.remove(dish.id) } else { ids.insert(dish.id) }
    }
    func isFavorite(_ dish: Dish) -> Bool { ids.contains(dish.id) }
}

@Observable
final class AppState {
    var selectedTab: Int = 0
    var searchText: String = ""
    var selectedCategory: String = "Todas"
    var showDarkHome: Bool = false
    var userName: String = "Valentina González"
    var userEmail: String = "valentina@correo.com"
    var userPhone: String = "+34 612 345 678"
    var points: Int = 840
}

enum DishCatalog {
    static let all: [Dish] = [
        Dish(name: "Hamburguesa Trufada Sabor", description: "Carne madurada 180g, queso brie fundido, cebolla caramelizada y mahonesa de trufa negra.", price: 14.50, oldPrice: nil, rating: 4.9, reviews: 428, time: "15-20 min", tag: "Plato de Autor", category: "Hamburguesas", systemImage: "takeoutbox.fill"),
        Dish(name: "Tagliatelle al Pesto de Pistacho", description: "Pasta fresca al huevo con pesto de pistacho, albahaca genovesa y parmesano.", price: 15.20, oldPrice: nil, rating: 4.8, reviews: 215, time: "15-25 min", tag: "Vegetariano", category: "Pastas", systemImage: "fork.knife"),
        Dish(name: "Costillar Ibérico a Baja Temperatura", description: "Cocinado 24 horas a baja temperatura, glaseado de miel y romero.", price: 19.50, oldPrice: 22.90, rating: 4.9, reviews: 380, time: "20-30 min", tag: "-15% Oferta", category: "Carnes", systemImage: "flame.fill"),
        Dish(name: "Bowl Mediterráneo de Burrata", description: "Tomates cherry, higos caramelizados, piñones y burrata fresca de Puglia.", price: 12.80, oldPrice: nil, rating: 4.7, reviews: 190, time: "10-15 min", tag: "Vegetariano", category: "Ensaladas", systemImage: "leaf.fill"),
        Dish(name: "Cheesecake de Queso Manchego", description: "Textura fluida, base de galleta artesana y coulis de frutos rojos.", price: 7.50, oldPrice: nil, rating: 4.9, reviews: 640, time: "Listo para servir", tag: "Premio Repostería", category: "Postres", systemImage: "birthday.cake.fill"),
        Dish(name: "Salmón Glaseado al Miso", description: "Espárragos trigueros y puré de chirivía.", price: 18.50, oldPrice: nil, rating: 5.0, reviews: 120, time: "20 min", tag: "Chef", category: "Pescados", systemImage: "fish.fill"),
        Dish(name: "Pizza Tartufata & Burrata", description: "Con trufa negra y burrata fresca de Puglia. Horno de leña.", price: 13.20, oldPrice: 16.50, rating: 4.8, reviews: 260, time: "15 min", tag: "-20% HOY", category: "Pizza", systemImage: "pizza.fill"),
        Dish(name: "Raviolis de Boletus y Foie", description: "Pasta fresca rellena con salsa de salvia suave y avellanas tostadas.", price: 16.90, oldPrice: nil, rating: 4.8, reviews: 310, time: "20 min", tag: "Top Ventas", category: "Pastas", systemImage: "carrot.fill")
    ]

    static let categories = ["Todas", "Hamburguesas", "Pastas", "Pizza", "Ensaladas", "Postres", "Bebidas"]
}
