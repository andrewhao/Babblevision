//
//  Measurement.swift
//  Babblevision
//
//  Created by Andrew Hao on 5/23/20.
//  Copyright © 2020 g9Labs. All rights reserved.
//

import Foundation

struct Measurement: Hashable, Codable, Identifiable {
  var id: String
  var device_id: String
  var table: String
  var time: String
  var field: String
  var measurement: String
  var value: String
}
