//
//  PhotosViewController.swift
//  TumblrClient
//
//  Created by Audrey Chaing on 10/13/16.
//  Copyright © 2016 Audrey Chaing. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    var posts: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 320
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    self.posts = responseDictionary.value(forKeyPath: "response.posts") as! Array
                    NSLog(self.posts.description)
                    
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "com.codepath.DemoPrototypeCell", for: indexPath) as! TumblrUITableViewCell
        
        let photos = posts[indexPath.row]["photos"] as! [NSDictionary]
        let url = photos[0].value(forKeyPath: "original_size.url") as! String
        
        cell.tumblrImageView.setImageWith(URL(string: url)!)
        
        // cell.tumblrImageV
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
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
