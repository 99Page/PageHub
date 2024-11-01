//
//  ToolbarConfig.swift
//  PageHub
//
//  Created by 노우영 on 11/1/24.
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
