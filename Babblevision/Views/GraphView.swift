//
//  GraphView.swift
//  Babblevision
//
//  Created by Andrew Hao on 8/16/20.
//  Copyright © 2020 g9Labs. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Charts

struct GraphView: UIViewRepresentable {
  var model: MeasurementGroupViewModel
  var chart = LineChartView()
  
  func updateUIView(_ uiView: UIView, context: Context) {
    self.chart.invalidateIntrinsicContentSize()
  }
  
  func makeUIView(context: Context) -> UIView {

    self.chart.xAxis.valueFormatter = TimeXAxisValueFormatter()
    
    let groups = Dictionary<String, [MeasurementViewModel]>(grouping: model.data,
                                                            by: { $0.device_id })
    let lineChartData: [LineChartDataSet] = groups
      .map { k, v in
        let dataEntries = v.map(self.mapPointToChartDataEntry)
        let dataSet = LineChartDataSet(entries: dataEntries, label: k)
        dataSet.axisDependency = .left
        return dataSet
      }
    self.chart.data = LineChartData(dataSets: lineChartData)
    return self.chart
  }
  
  func mapPointToChartDataEntry(point: MeasurementViewModel) -> ChartDataEntry {
    switch(point.value) {
    case .number(let rawNumber):
      return ChartDataEntry(x: Double(point.time.timeIntervalSince1970),
                            y: rawNumber,
                            data: point)
    case .string(let stringValue):
      let strToBool = stringValue == "true" ? 1 : 0
      return ChartDataEntry(x: Double(point.time.timeIntervalSince1970),
                            y: Double(strToBool),
                            data: point)
    }
  }
}

class TimeXAxisValueFormatter: IAxisValueFormatter {
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:MM:SS"
    let ts = Date(timeIntervalSince1970: value)
    return dateFormatter.string(from: ts)
  }
}

struct GraphView_Previews: PreviewProvider {
  static var previews: some View {
    let measurementGroup = MeasurementGroup(id: "123", data: [
      Measurement(id: "123", device_id: "abc", table: "some_table", time: "2019-09-07T-15:50+00", field: "cry_detection", measurement: "is_crying", value: "2"),
      Measurement(id: "124", device_id: "abc", table: "some_table", time: "2019-09-07T-15:51+00", field: "cry_detection", measurement: "is_crying", value: "3"),
      Measurement(id: "125", device_id: "def", table: "some_table", time: "2019-09-07T-15:50+00", field: "cry_detection", measurement: "is_crying", value: "1")

    ])
    let model = MeasurementGroupViewModel(measurementGroup: measurementGroup)
    return GraphView(model: model)
  }
}
