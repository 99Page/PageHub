//
//  SheetToolbar.swift
//  PageHub
//
//  Created by 노우영 on 10/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct SheetToolbarViewModifier<Sheet: View, Toolbar: View>: ViewModifier {
    
    @State var coffeeViewSize: CGSize = .zero
    @Binding var presentationSelection: PresentationDetent
    
    @ViewBuilder var sheet: Sheet
    @ViewBuilder var toolbar: Toolbar
    
    
    let presentationCandidates: Set<PresentationDetent> = [.fraction(0.1), .medium, .fraction(0.8)]
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .presentationDetents(presentationCandidates, selection: $presentationSelection)
                .trackSize { size in
                    coffeeViewSize = size
                }
                .presentationBackgroundInteraction(.enabled)
            
            
            ForEach(sections: toolbar) { section in
                let values = section.containerValues
                let alignment = values.alignment
                let hStackAlignment: Alignment = alignment == .trailing ? .trailing : .leading
                
                HStack {
                    if hStackAlignment == .leading {
                        Spacer()
                    }
                    
                    section.content
                    
                    if hStackAlignment == .leading {
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: hStackAlignment)
                .offset(y: -coffeeViewSize.height)
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
