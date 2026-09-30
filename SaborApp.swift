import SwiftUI

@main
struct SaborApp: App {
    @State private var appState = AppState()
    @State private var cart = CartStore()
    @State private var favorites = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(cart)
                .environment(favorites)
        }
    }
}

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State private var showOnboarding = true

    var body: some View {
        @Bindable var state = appState
        Group {
            if showOnboarding {
                OnboardingView(isPresented: $showOnboarding)
            } else {
                MainTabView(selection: $state.selectedTab)
            }
        }
    }
}

struct MainTabView: View {
    @Binding var selection: Int
    var body: some View {
        TabView(selection: $selection) {
            HomeView().tabItem { Label("Inicio", systemImage: "house") }.tag(0)
            MenuView().tabItem { Label("Menú", systemImage: "fork.knife") }.tag(1)
            FavoritesView().tabItem { Label("Favoritos", systemImage: "heart") }.tag(2)
            HistoryView().tabItem { Label("Pedidos", systemImage: "receipt") }.tag(3)
            ProfileView().tabItem { Label("Perfil", systemImage: "person.circle") }.tag(4)
        }
        .tint(SaborTheme.primary)
    }
}
