//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ryan Harvey on 6/15/15.
//  Copyright © 2015 datascientist.guru. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, withTitle title:String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}