//
//  CarsViewController.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import UIKit

class CarsViewController: UIViewController {
    
    private lazy var cars: [Car] = []
    private lazy var currentPage = 1
    private lazy var isLoadingData = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.veryLightBlue
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        Task {
            await loadData()
        }
    }
    
    private func loadData() async {
        
        guard !isLoadingData else { return }
        isLoadingData = true
        
        do {
            let newCars = try await RequestManager.shared.fetchCars(page: currentPage)
            appendCars(newCars)
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        print("Decoding error: \(error.localizedDescription)")
        isLoadingData = false
    }
    
    private func appendCars(_ newCars: [Car]) {
        cars.append(contentsOf: newCars)
        tableView.reloadData()
        currentPage += 1
        isLoadingData = false
    }
    
    private func setupNavigationBar() {
        self.title = "Auto Catalog 🚗"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = Colors.veryLightBlue
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(CarCell.self, forCellReuseIdentifier: CarCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension CarsViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CarCell()
        let car = cars[indexPath.row]
        let imageURL = URL(string: car.image)!
        cell.configure(imageURL: imageURL, title: car.name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenCar = cars[indexPath.row]
        print(chosenCar.name)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let lastIndexPath = indexPaths.last,
           lastIndexPath.row == cars.count - 1 {
            Task {
                await loadData()
            }
        }
    }
}

