//
//  PhotoDetailViewController.swift
//  FlickrClinetAppSwift
//
//  Created by Soner Demirci on 31.08.2023.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
        
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ownerImageView.layer.cornerRadius = 24.0
        //Ekranin basligi
        title = "Photo Detail"
//        imageView.backgroundColor = .gray
//        ownerImageView.backgroundColor = .darkGray
//        ownerNameLabel.text = "Owner Name Label"
//        descriptionLabel.text = "Description Label Description Label Description Label Description Label Description Label"
        
        ownerNameLabel.text = photo?.ownername
        title = photo?.title
        
        //Profil fotografi cekme
        NetworkManager.shared.fetcImage(with:photo?.buddyIconURL ) { data in
            self.ownerImageView.image = UIImage(data: data)
        }
            
        //gonderi fotografi cekme
        NetworkManager.shared.fetcImage(with: photo?.urlN) {data in
            self.imageView.image = UIImage(data: data)
        }

        descriptionLabel.text = photo?.description?.content
    }
    
    

}
