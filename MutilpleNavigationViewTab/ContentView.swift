//
//  ContentView.swift
//  MutilpleNavigationViewTab
//
//  Created by wonki on 2023/04/13.
//

import SwiftUI
import Combine

// https://stackoverflow.com/questions/58444689/swiftui-hide-tabbar-in-subview

struct ContentView: View {
    enum Tab: Int {
        case tab1 = 1
        case tab2 = 2
    }
    
    @State private var previous = Tab.tab1.rawValue
    @State private var now = Tab.tab1.rawValue
    
    @State private var selected = Tab.tab1.rawValue
    @State private var retouched = false
    
    var body: some View {
        VStack {
            if retouched {
                Text("retouched")
            }
            
            TabView(selection: $selected) {
                NavigationView {
                    FirstView()
                }
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Home")
                }
                .tag(Tab.tab1.rawValue)
                
                NavigationView {
                    SecondView()
                }
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("SecondView")
                }
                .tag(Tab.tab2.rawValue)
            }
            
            .onChange(of: selected) { value in
                now = value
                if now == previous {
                    retouched = true
                } else {
                    retouched = false
                }
                previous = value
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FirstView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("FirstView")
                .navigationBarTitle("Home")
            Spacer()
            NavigationLink(destination: ThirdView()) {
                Text("Third View")
            }
            Spacer()
        }
        .showTabBar()
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("SecondView")
                .navigationBarTitle("Home")
            Spacer()
            NavigationLink(
                "Third View",
                destination: ThirdView())
            Spacer()
        }
        .showTabBar()
    }
}

struct ThirdView: View {
    var body: some View {
        VStack {
            Text("ThirdView")
        }
        .hiddenTabBar()
    }
}

extension UIApplication {
    var key: UIWindow? {
        self.connectedScenes
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?
            .windows
            .filter { $0.isKeyWindow }
            .first
    }
}

extension UIView {
    func allSubviews() -> [UIView] {
        var subs = self.subviews
        for subview in self.subviews {
            let rec = subview.allSubviews()
            subs.append(contentsOf: rec)
        }
        return subs
    }
}

struct TabBarModifier {
    static func showTabBar() {
        UIApplication.shared.key?.allSubviews().forEach { subView in
            if let view = subView as? UITabBar {
                view.isHidden = false
            }
        }
    }

    static func hideTabBar() {
        UIApplication.shared.key?.allSubviews().forEach { subView in
            if let view = subView as? UITabBar {
                view.isHidden = true
            }
        }
    }
}

struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.showTabBar()
        }
    }
}

struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.hideTabBar()
        }
    }
}

extension View {
    func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }

    func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }
}
