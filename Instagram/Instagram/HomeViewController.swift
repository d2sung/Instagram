//
//  HomeViewController.swift
//  Instagram
//
//  Created by Daniel Sung on 3/13/17.
//  Copyright © 2017 Daniel Sung. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [PFObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let query = PFQuery(className: "Post")
        query.order(byDescending: "_created_at")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            }
            else {
                print(error?.localizedDescription ?? "Error at query")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        cell.captionLabel.text = post["caption"] as! String?
        let photo = post["media"] as! PFFile
        
        photo.getDataInBackground { (data: Data?, error: Error?) in
            if let data = data {
                cell.photoView.image = UIImage(data: data)
            }
            else {
                print(error?.localizedDescription ?? "error at cell posting")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
