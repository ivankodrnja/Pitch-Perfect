//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ivan Kodrnja on 14/03/15.
//  Copyright (c) 2015 2plus2. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: URL!
    var title: String!
    
    init(filePathUrlTemp: URL, titleTemp: String) {
        filePathUrl = filePathUrlTemp
        title = titleTemp
    }
        
    
    
}
