//
//  ImagesViewController.swift
//  foodinthewhere
//
//  Created by Virginia Cook on 11/9/16.
//  Copyright © 2016 Virginia Cook. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = NSMutableArray()
    var collectionView: UICollectionView!
	let baseURL = "http://api.randomuser.me/"
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
    }
	
	func getPhotos(onCompletion: (JSON) -> Void) {
		let route = baseURL
		makeHTTPGetRequest(route, onCompletion: { json, err in
			onCompletion(json as JSON)
		})
	}
	
	func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
		let request = NSMutableURLRequest(URL: NSURL(string: path)!)
		
		let session = NSURLSession.sharedSession()
		
		let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
			let json:JSON = JSON(data: data)
			onCompletion(json, error)
		})
		task.resume()
	}
	
	func addDummyData() {
		RestApiManager.sharedInstance.getRandomUser { json in
			let results = json["results"]
			for (index: String, subJson: JSON) in results {
				let user: AnyObject = subJson["user"].object
				self.items.addObject(user)
				dispatch_async(dispatch_get_main_queue(),{
					collectionView?.reloadData()
				})
			}
		}
	}
	
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		self.collectionView.registerClass(ImageCell.self, forCellWithReuseIdentifier:"Cell")
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImageCell
		let user:JSON =  JSON(self.items[indexPath.row])
		cell.textLabel.text = user["username"].string
//        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
}
