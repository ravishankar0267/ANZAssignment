//
//  ListViewController.swift
//  ANZAssignment
//
//  Created by Ravi Mishra on 23/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UIViewController {
    private let kCornerRadius:CGFloat = 6.0
    private let itemPerRow: CGFloat = 3
    private let borderSpace: CGFloat = 20
    private let sectInset = UIEdgeInsets(top: 30.0, left: 10.0, bottom: 30.0, right: 10.0)
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionDatasource = [ListDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let requestResponseManager = RequestResponseManager()
        requestResponseManager.delegate = self
        requestResponseManager.getSereverResponse(url: urlString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = sender as! IndexPath
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.detailModal = collectionDatasource[indexPath.row]
    }
}

// MARK: - UICollectionViewDelegate
extension ListViewController :UICollectionViewDataSource{
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDatasource.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.titlelabel.text = nil
        cell.imageView.image = nil
        populateCell(cell: cell, withIndexPath: indexPath)
        return cell
    }
    
    func populateCell(cell:CollectionViewCell, withIndexPath indexPath:IndexPath)  {
        let  model =  collectionDatasource[indexPath.row]
        let docUmentDirectoryPath = FileManager.documentsDir()
        if(model.imageUrlRefrence != nil){
            let getImagePath = (docUmentDirectoryPath as String)+"/"+model.title!
            let checkValidation = FileManager.default
            if (checkValidation.fileExists(atPath: "\(getImagePath)")) {
                cell.imageView.image = UIImage(contentsOfFile: getImagePath)! as UIImage
            }
            else{
                cell.imageView.image = #imageLiteral(resourceName: "No_Image_Available.jpg")
            }
            
           
        }
        else{
            cell.imageView.image = #imageLiteral(resourceName: "No_Image_Available.jpg")
        }
         cell.titlelabel.text = model.title
    }
    
   
}

// MARK: - UICollectionViewDelegate
extension ListViewController :UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailViewSegue", sender: indexPath)
    }
}

//MARK:- UICollectionViewDelegateFlowLayout: set the dynamic cell as per the image size
extension ListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectInset.left * (itemPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemPerRow
        //If image in Document - use height & width
        let  model =  collectionDatasource[indexPath.row]
        let docUmentDirectoryPath = FileManager.documentsDir()
        if(model.imageUrlRefrence != nil){
            let getImagePath = (docUmentDirectoryPath as String)+"/"+model.title!
            let checkValidation = FileManager.default
        // Check whther the image is saved in document directory, if not download the image
            if (checkValidation.fileExists(atPath: "\(getImagePath)")) {
                let image =  UIImage(contentsOfFile: getImagePath)! as UIImage
                let width = (UIScreen.main.bounds.size.width-borderSpace > (image.size.width)) ? (image.size.width) : UIScreen.main.bounds.size.width-borderSpace
                return CGSize(width: width, height: image.size.height)
            }
            else
            {
                downloadImageIfNotExist(indexPath: indexPath)
            }
        }
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectInset
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectInset.left
    }
}

extension ListViewController:RequestResponseProtocol{
    func getResponse(result:[ListDetails])
    {
        collectionDatasource = result
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func getErrorResponse(error:NSString)
    {
    }
}



