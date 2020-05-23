//
//  MeasurementGroupView.swift
//  Babblevision
//
//  Created by Andrew Hao on 6/14/20.
//  Copyright © 2020 g9Labs. All rights reserved.
//

import SwiftUI
import Charts

struct MeasurementGroupView: View {
  var model: MeasurementGroupViewModel
  
    var body: some View {
      VStack {
        Text(self.model.measurement)
        GraphView(model: self.model)
      }
    }
}

struct MeasurementGroupView_Previews: PreviewProvider {

    static var previews: some View {
      let measurementGroup = MeasurementGroup(id: "123", data: [
        Measurement(id: "123", device_id: "abc", table: "some_table", time: "2019-09-07T-15:50+00", field: "cry_detection", measurement: "is_crying", value: "2"),
        Measurement(id: "124", device_id: "abc", table: "some_table", time: "2019-09-07T-15:51+00", field: "cry_detection", measurement: "is_crying", value: "3"),
        Measurement(id: "125", device_id: "def", table: "some_table", time: "2019-09-07T-15:50+00", field: "cry_detection", measurement: "is_crying", value: "1")

      ])
      return MeasurementGroupView(model: MeasurementGroupViewModel(measurementGroup: measurementGroup))
    }
}
