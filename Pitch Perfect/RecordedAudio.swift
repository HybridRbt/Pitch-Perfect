//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jianfeng Yang on 2/1/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
 
    init(url: NSURL, title: String) {
        self.filePathUrl = url
        self.title = title
    }
}
