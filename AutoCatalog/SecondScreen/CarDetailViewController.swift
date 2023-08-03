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
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
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
            print(carInfo.car.brandName, carInfo.user.username)
            
            let postArray = try await RequestManager.shared.fetchPosts(with: carId, page: currentPage)
            for post in postArray {
                print(post.text)
                print(post.likeCount)
                print(post.createdAt)
                print(post.commentCount)
                print(post.image)
            }
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        print("Decoding error: \(error)")
        isLoadingData = false
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
        titleLabel.text = "\(chosenCar?.name ?? "Car's name")"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = Colors.veryLightBlue
    }
}

