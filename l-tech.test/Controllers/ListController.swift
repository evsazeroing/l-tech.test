//
//  ListController.swift
//  l-tech.test
//
//  Created by Евгений on 20/06/2019.
//  Copyright © 2019 Евгений. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ListController: UITableViewController {
    
    @IBOutlet weak var scSort: UISegmentedControl!
    
    var posts: [Post] = []
    
    var serverSort = 0
    var byDateSort = 1
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd.MM.YYY, HH:mm:ss"
        
        updatePosts()
        
        setUpdateTamer()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshPosts), for: .valueChanged)
        self.refreshControl = refreshControl
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        
        
        if posts.count > 0{
            
            cell.labelTitle.text = posts[indexPath.row].title
            cell.labelInfo.text = posts[indexPath.row].info
            
            
            let date = posts[indexPath.row].date
            let dateString = dateFormatter.string(from: date)
            cell.labelDate.text = dateString
            
            let imgURL = posts[indexPath.row].pictureURL
            
            Alamofire.request(imgURL).responseImage { (response) in
                
                cell.picture.image = response.value
        
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //Вызов после получения постов с сервера
    func getPostAfter(postsFromServer: [Post]){
        posts = postsFromServer
        sortPosts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetalied" {
            
            let detail = segue.destination as! DetailController
            let index = self.tableView.indexPathForSelectedRow!.row
            detail.post = posts[index]
            
        }
        
    }
    
    @objc func updatePosts(){
        ServerRequest.standard.getPosts(getPostAfter: getPostAfter)
    }
    
    func sortPosts(){
        
        if scSort.selectedSegmentIndex == serverSort{
            
            posts.sort { (post1, post2) -> Bool in
                return post1.date > post2.date
            }
            
        }else if scSort.selectedSegmentIndex == byDateSort{
            
            posts.sort { (post1, post2) -> Bool in
                return post1.sort < post2.sort
            }
        }
        
        tableView.reloadData()
    }
    
    @IBAction func tapRefreshButton(_ sender: Any) {
        updatePosts()
    }
    
    @IBAction func changedSortValue(_ sender: Any) {
        sortPosts()
    }
    
    func setUpdateTamer(){
        Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { (timer) in
            self.updatePosts()
        }
    }
    
    @objc func refreshPosts(refreshControl: UIRefreshControl){
        updatePosts()
        refreshControl.endRefreshing()
    }
    
}
