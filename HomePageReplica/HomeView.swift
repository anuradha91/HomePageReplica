//
//  HomeView.swift
//  HomePageReplica
//
//  Created by Anuradha Sharma on 10/28/18.
//  Copyright © 2018 Anuradha Sharma. All rights reserved.
//

import UIKit

class HomeView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    //MARK:- Variables
    var detailsArray = [[String : Any]]()
    var storedOffsets = [Int: CGFloat]()
    let titleArray = ["Hope", "Happy", "Beautiful", "Festival", "Christmas"]
    let headerImages = ["Landscape", "Landscape-1", "Landscape-2"]
    
    //MARK:- Overriden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "Title")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        for title in titleArray{
            fetchPhotos(text: title, onCompletion: {(photosArray : [Photo]) -> Void in
                self.detailsArray.append(["title" : title, "photos" : photosArray])
            })
        }
    }
    
    //MARK:- Fetch Images from API
     func fetchPhotos(text : String,onCompletion: @escaping ([Photo]) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        API.fetchPhotos(searchText: text, onCompletion: { (error: NSError?, flickrPhotos: [Photo]?) -> Void in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if error == nil {
                onCompletion(flickrPhotos!)
                
            } else {
                if (error!.code == API.Errors.invalidAccessErrorCode) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.showErrorAlert()
                    })
                }
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        })
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "", message: "Not able to fetch data", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCategoryCell",for: indexPath) as! HomeCategoryCell
        cell.titleLabel.text = detailsArray[indexPath.row]["title"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView,willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HomeCategoryCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? HomeCategoryCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryDetailCell", for: indexPath) as! CategoryDetailCell
        if collectionView == headerCollectionView{
            cell.imageView.image = UIImage(named: headerImages[indexPath.row])
            return cell
        }else{
            let value = detailsArray[collectionView.tag]
            let photoArray = value["photos"] as! [Photo]
            cell.imageView.sd_setImage(with: photoArray[indexPath.row].photoUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView{
          return headerImages.count
        }else{
            let value = detailsArray[collectionView.tag]
            let photoArray = value["photos"] as! [Photo]
            return photoArray.count
        }
    }
}
