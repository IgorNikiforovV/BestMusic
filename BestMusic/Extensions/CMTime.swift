//
//  CMTime.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 31.05.2021.
//

import AVKit

extension CMTime {

    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSecond = Int(CMTimeGetSeconds(self))
        let second = totalSecond % 60
        let minutes = totalSecond / 60
        let timeFormatString = String(format: "%02d:%02d", arguments: [minutes, second])
        return timeFormatString
    }

}
