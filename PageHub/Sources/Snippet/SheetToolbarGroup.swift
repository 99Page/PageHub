//
//  SheetToolbarGroup.swift
//  PageHub
//
//  Created by 노우영 on 11/5/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

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
