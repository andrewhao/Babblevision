//
//  MeasurementGroupSummaryRowView.swift
//  Babblevision
//
//  Created by Andrew Hao on 8/16/20.
//  Copyright © 2020 g9Labs. All rights reserved.
//

import SwiftUI

struct MeasurementGroupSummaryRowView: View {
  var model: MeasurementGroupViewModel

  var body: some View {
    VStack(alignment: .leading) {
      Text("measurement: \(self.model.measurement)")
      Text("field: \(self.model.field)")
      Text("device_id: \(self.model.device_id)")
      Text("rawValue: \(self.model.rawValue)")
      Text("time toString: \(self.model.time.toString())")
    }
  }
}

struct MeasurementGroupSummaryRowView_Previews: PreviewProvider {
    static var previews: some View {
          let measurementGroup = MeasurementGroup(id: "123", data: [
          Measurement(id: "123", device_id: "abc", table: "some_table", time: "2019-09-07T-15:50+00", field: "cry_detection", measurement: "is_crying", value: "2"),
          Measurement(id: "124", device_id: "abc", table: "some_table", time: "2019-09-07T-15:51+00", field: "cry_detection", measurement: "is_crying", value: "3"),
          Measurement(id: "125", device_id: "def", table: "some_table", time: "2019-09-07T-15:50+00", field: "cry_detection", measurement: "is_crying", value: "1")

        ])
        return MeasurementGroupSummaryRowView(model: MeasurementGroupViewModel(measurementGroup: measurementGroup))
    }
}
