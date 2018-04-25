//
//  DetailViewController.swift
//  ANZAssignment
//
//  Created by Ravi Mishra on 24/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var detailModal:ListDetails?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = detailModal?.title
        detailedLabel.text = detailModal?.imageDescription
        if(detailModal?.imageUrlRefrence != nil){
            let docUmentDirectoryPath = FileManager.documentsDir()
            let getImagePath = (docUmentDirectoryPath as String)+"/"+(detailModal?.title!)!
            let checkValidation = FileManager.default
            if (checkValidation.fileExists(atPath: "\(getImagePath)")) {
                imageView.image = UIImage(contentsOfFile: getImagePath)! as UIImage
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
