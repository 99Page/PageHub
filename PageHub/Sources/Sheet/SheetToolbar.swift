//
//  SheetToolbar.swift
//  PageHub
//
//  Created by 노우영 on 10/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

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
