//
//  CarsViewController.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import UIKit

class CarsViewController: UIViewController {
    
    var cars: [Car] = []
    var currentPage = 1
    var isLoadingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        
        guard !isLoadingData else { return }
        isLoadingData = true
        
        do {
            let newCars = try await RequestManager.shared.fetchCars(page: currentPage)
            print("success")
        } catch {
            handleError(error)
        }
    }
    
    func handleError(_ error: Error) {
        print("Decoding error: \(error.localizedDescription)")
        isLoadingData = false
    }
}
