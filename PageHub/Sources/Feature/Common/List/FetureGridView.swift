//
//  FeatureGridView.swift
//  PageHub
//
//  Created by 노우영 on 11/26/24.
//  Copyright © 2024 Page. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct FeatureGridView: View {
    var body: some View {
        List {
            NavigationLink(state: ContentFeature.Path.State.sheetToolbar(SheetToolbarReducer.State())) {
                Text("SheetToolbar")
            }
        }
        .navigationTitle("Features")
    }
}

#Preview {
    FeatureGridView()
}
