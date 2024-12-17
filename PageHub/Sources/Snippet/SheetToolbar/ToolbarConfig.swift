//
//  ToolbarConfig.swift
//  PageHub
//
//  Created by 노우영 on 11/1/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct ToolbarConfig: Equatable {
    let presentationDedents: Set<PresentationDetent>
    var selection: PresentationDetent
    let backgroundInteraction: PresentationBackgroundInteraction
    let alignment: Alignment
    let toolbarHiddenPresentationDedents: Set<PresentationDetent>
    
    /// 툴바가 따라갈 수 있는 최소 높이로 설정된 프랙션 값
    private let minimumToolbarHeightFraction: PresentationDetent = .fraction(0.01)
    
    static func == (lhs: ToolbarConfig, rhs: ToolbarConfig) -> Bool {
        lhs.presentationDedents == rhs.presentationDedents
        && lhs.selection == rhs.selection
        && lhs.alignment == rhs.alignment
        && lhs.toolbarHiddenPresentationDedents == rhs.toolbarHiddenPresentationDedents
        // backgroundInteraction은 비교하지 않음
    }
    
    init(presentationDedents: Set<PresentationDetent>, selection: PresentationDetent, backgroundInteraction: PresentationBackgroundInteraction, alignment: Alignment,
         toolbarHiddenPresentationDedents: Set<PresentationDetent> = []) {
        
        self.presentationDedents = Self.computeAdjustedPresentationDedents(
            presentationDedents,
            minimumToolbarHeightFraction: minimumToolbarHeightFraction
        )
        
        self.selection = selection
        self.backgroundInteraction = backgroundInteraction
        self.toolbarHiddenPresentationDedents = toolbarHiddenPresentationDedents
        self.alignment = alignment == .leading ? .leading : .trailing
    }
    
    private static func computeAdjustedPresentationDedents(
        _ presentationDedents: Set<PresentationDetent>,
        minimumToolbarHeightFraction: PresentationDetent
    ) -> Set<PresentationDetent> {
        var adjustedDedents: Set<PresentationDetent> = [minimumToolbarHeightFraction]
        adjustedDedents.formUnion(presentationDedents)
        return adjustedDedents
    }
    
    var isAtMinimumHeightFraction: Bool {
        self.selection == self.minimumToolbarHeightFraction
    }
    
    var isToolbarPresented: Bool {
        !toolbarHiddenPresentationDedents.contains(selection)
    }
}
