//
//  View_extension_containerForegroundColor_alignment_view.swift
//  PageHub
//
//  Created by 노우영 on 11/5/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

extension View {
    func containerForegroundColor(_ alignment: HorizationAlignment) -> some View {
        containerValue(\.alignment, alignment)
    }
}
