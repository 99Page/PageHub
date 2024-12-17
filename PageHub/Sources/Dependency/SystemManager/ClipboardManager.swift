//
//  ClipboardManager.swift
//  PageHub
//
//  Created by 노우영 on 12/17/24.
//  Copyright © 2024 Page. All rights reserved.
//

import Foundation
import Dependencies
import UIKit

struct ClipboardManager {
    var copyToClipboard: (String) -> ()
}

extension ClipboardManager: DependencyKey {
    static var liveValue: ClipboardManager {
        ClipboardManager { string in
            UIPasteboard.general.string = string
        }
    }
}

extension DependencyValues {
    var clipboardManager: ClipboardManager {
        get { self[ClipboardManager.self] }
        set { self[ClipboardManager.self] = newValue }
    }
}

