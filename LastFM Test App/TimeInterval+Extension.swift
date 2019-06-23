//
//  TimeInterval+Extension.swift
//  LastFM Test App
//
//  Created by Artem Podustov on 6/23/19.
//  Copyright © 2019 podustov. All rights reserved.
//

import  UIKit

extension TimeInterval {
    func time() -> String {
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.unitsStyle = .positional
        timeFormatter.allowedUnits = [.minute, .second]
        timeFormatter.zeroFormattingBehavior = [.pad]

        return timeFormatter.string(from: self) ?? "0:00"
    }
}
