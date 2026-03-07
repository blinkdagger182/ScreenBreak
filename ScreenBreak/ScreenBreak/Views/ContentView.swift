//
//  ContentView.swift
//  ScreenBreak
//
//  Created by Christian Pichardo on 2/26/23.
//

import SwiftUI
import CoreData
import FamilyControls
import RiveRuntime
import ManagedSettings


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("selectedTab") var selectedTab: Tab = .star
    @AppStorage("showOnboarding") var showOnboarding = true
    @AppStorage("firstTime") var firstTime = true
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    @State private var isPressed = false

    var body: some View {
        ZStack{
            Color("backgroundColor")
                .ignoresSafeArea()
            tabContent
            TabBar()
            
        }
        .fullScreenCover(isPresented:$showOnboarding){
            OnboardingView()
        }
        .onAppear{
            if !showOnboarding{
                DispatchQueue
                    .main
                    .asyncAfter(deadline:.now() + 5){
                        launchScreenManager.dismiss()
                    }
            }

        }
        
    }
}

private extension ContentView {
    var tabContent: some View {
        ZStack {
            HomeView()
                .opacity(selectedTab == .home ? 1 : 0)
                .allowsHitTesting(selectedTab == .home)
            AppsView()
                .opacity(selectedTab == .star ? 1 : 0)
                .allowsHitTesting(selectedTab == .star)
            ConfigRestrictionsView()
                .opacity(selectedTab == .timer ? 1 : 0)
                .allowsHitTesting(selectedTab == .timer)
            MoreInsightsView()
                .opacity(selectedTab == .search ? 1 : 0)
                .allowsHitTesting(selectedTab == .search)
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).environmentObject(LaunchScreenManager())
    }
}
