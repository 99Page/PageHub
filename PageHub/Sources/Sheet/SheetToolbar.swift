//
//  SheetToolbar.swift
//  PageHub
//
//  Created by 노우영 on 10/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ToolbarConfig: Equatable {
    static func == (lhs: ToolbarConfig, rhs: ToolbarConfig) -> Bool {
        lhs.presentationDedents == rhs.presentationDedents
        && lhs.selection == rhs.selection
    }
    
    let presentationDedents: Set<PresentationDetent>
    var selection: PresentationDetent
    let backgroundInteraction: PresentationBackgroundInteraction
    
    init(presentationDedents: Set<PresentationDetent>, selection: PresentationDetent, backgroundInteraction: PresentationBackgroundInteraction) {
        var adjustivePresentationDedents: Set<PresentationDetent> = [.fraction(0.01)]
        adjustivePresentationDedents.formUnion(presentationDedents)
        
        self.presentationDedents = adjustivePresentationDedents
        self.selection = selection
        self.backgroundInteraction = backgroundInteraction
    }
}

struct SheetToolbarViewModifier<Item: Identifiable, Sheet: View, Toolbar: View>: ViewModifier {
    
    @Binding var item: Item?
    @Binding var config: ToolbarConfig
    
    @ViewBuilder var sheet: (Binding<Item>) -> Sheet
    @ViewBuilder var toolbar: Toolbar
    
    @State var coffeeViewSize: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .sheet(item: $item) { item in
                sheet(item)
                    .presentationDetents(config.presentationDedents, selection: $config.selection)
                    .trackSize { size in
                        coffeeViewSize = size
                    }
                    .presentationBackgroundInteraction(config.backgroundInteraction)
            }
            .overlay(alignment: .bottom) {
                ForEach(sections: toolbar) { section in
                    let values = section.containerValues
                    let alignment = values.alignment
                    let hStackAlignment: Alignment = alignment == .trailing ? .trailing : .leading
                    
                    HStack {
                        if hStackAlignment == .trailing {
                            Spacer()
                        }
                        
                        section.content
                        
                        if hStackAlignment == .leading {
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: hStackAlignment)
                    .offset(y: -coffeeViewSize.height)
                    .animation(.easeInOut(duration: 0.2), value: coffeeViewSize.height)
                }
            }
            .onChange(of: config.selection) { oldValue, newValue in
                if newValue == .fraction(0.01) {
                    item = nil
                    config.selection = oldValue
                }
            }
    }
}

/// section 전체에 적용할 수도 있고
/// 개별 subview 하나에 적용할 수도 있다.
/// ContainerView, SectionContainerView에서 어떻게 사용하고 있는지 비교해보자.
extension ContainerValues {
    @Entry var alignment: HorizationAlignment = .trailing
}

extension View {
    func containerForegroundColor(_ alignment: HorizationAlignment) -> some View {
        containerValue(\.alignment, alignment)
    }
}

enum HorizationAlignment {
    case leading
    case trailing
}

struct SheetToobarView<Content: View>: View {
    
    let sheetToolbarGroup: () -> SheetToolbarGroup<Content>
    
    var body: some View {
        sheetToolbarGroup()
    }
}

struct SheetToolbarGroup<Content: View>: View {
    
    let alignment: HorizationAlignment
    let content: () -> Content
    
    var body: some View {
        Section {
            content()
        }
        .containerForegroundColor(alignment)
    }
}
