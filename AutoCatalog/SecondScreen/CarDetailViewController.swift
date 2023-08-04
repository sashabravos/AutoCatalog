//
//  CarDetailViewController.swift
//  AutoCatalog
//
//  Created by Александра Кострова on 03.08.2023.
//

import UIKit

class CarDetailViewController: UIViewController {
    
    var userInfo: CarInfoDetail?
    var chosenCar: CarInfo?
    var posts: [PostData.Post] = []
    var currentPage = 1
    private var isLoadingData = false
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var carHeaderView: CarHeaderView = {
        let header = CarHeaderView()
        header.layer.cornerRadius = 10
        header.backgroundColor = Colors.veryLightGray
        return header
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
            let carId = chosenCar?.id ?? 0
            let carInfo: CarInfoDetail = try await RequestManager.shared.fetchCarDetailData(for: CarInfoDetail.self, with: carId)
            carHeaderView.configureHeaderView(carData: carInfo)
            
            let postArray = try await RequestManager.shared.fetchPosts(with: carId, page: currentPage)
            appendPosts(postArray)
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        print("Decoding error: \(error)")
        isLoadingData = false
    }
    
    private func appendPosts(_ newPosts: [PostData.Post]) {
        posts.append(contentsOf: newPosts)
        tableView.reloadData()
        currentPage += 1
        isLoadingData = false
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
        titleLabel.text = "\(chosenCar?.name ?? "Car's name")"
        navigationController?.navigationBar.barTintColor = Colors.veryLightGray
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
                
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.tableHeaderView = carHeaderView
        tableView.contentInset.top = 100
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.register(CarCell.self, forCellReuseIdentifier: CarCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        carHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            carHeaderView.heightAnchor.constraint(equalToConstant: 350),
            carHeaderView.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        ])
    }
}

extension CarDetailViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostCell()
        let post = posts[indexPath.row]
        let imageURL = URL(string: post.image)!
        cell.configure(imageURL: imageURL, text: post.text,
                       comments: post.commentCount,
                       likes: post.likeCount, date: post.createdAt)
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if let lastIndexPath = indexPaths.last,
           lastIndexPath.row == posts.count - 1 {
            Task {
                await loadData()
            }
        }
    }
}
