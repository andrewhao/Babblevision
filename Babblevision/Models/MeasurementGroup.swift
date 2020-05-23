//
//  MeasurementGroup.swift
//  Babblevision
//
//  Created by Andrew Hao on 6/13/20.
//  Copyright © 2020 g9Labs. All rights reserved.
//

import Foundation

struct MeasurementGroup: Hashable, Codable, Identifiable {
  var id: String
  var data: [Measurement]
}
