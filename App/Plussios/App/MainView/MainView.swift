//
//  MainView.swift
//  Plussios
//
//  Created by Stan Sidel on 08.01.2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject
    var viewModel: MainViewModel

    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
//                .onAppear {
//                    viewModel.loadData()
//                }
        case .data:
            Text("TODO")
        case .error(let error):
            Text("Error: \(error?.localizedDescription ?? "unknown")")
        }
    }
}

//#Preview {
//    MainView()
//}
