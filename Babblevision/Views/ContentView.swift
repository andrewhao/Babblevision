//
//  ContentView.swift
//  Babblevision
//
//  Created by Andrew Hao on 5/22/20.
//  Copyright © 2020 g9Labs. All rights reserved.
//

import SwiftUI
import SwiftDate

struct ContentView: View {
  @ObservedObject var model = GraphListViewModel(influxService: FetchDataService())


  var body: some View {
    NavigationView {
      List(model.dataSource) { m in
        NavigationLink(destination: MeasurementGroupView(model: m)) {
          return MeasurementGroupSummaryRowView(model: m)
        }
      }
      .navigationBarTitle(
        Text("Babblevision")
          .font(.title)
      )
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
