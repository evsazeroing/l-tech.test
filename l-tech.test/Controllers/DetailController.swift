//
//  DetailController.swift
//  l-tech.test
//
//  Created by Евгений on 21/06/2019.
//  Copyright © 2019 Евгений. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailController: UIViewController {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textFieldInfo: UITextView!
    @IBOutlet weak var navigationTittle: UINavigationItem!
    
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPost()
    }
    
    func setPost(){
        
        labelTitle.text = post.title
        textFieldInfo.text = post.info
        navigationTittle.title = post.title
        
        let imgURL = post.pictureURL
        Alamofire.request(imgURL).response { (response) in
            
            self.picture.image = UIImage(data: response.data!)
            
        }
    }
    
}
