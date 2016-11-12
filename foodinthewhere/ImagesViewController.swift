//
//  ImagesViewController.swift
//  foodinthewhere
//
//  Created by Virginia Cook on 11/9/16.
//  Copyright © 2016 Virginia Cook. All rights reserved.
//

import Foundation
import UIKit

class ImagesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = NSMutableArray()
    var collectionView: UICollectionView!
    var jsonResponse = [String: AnyObject]()
    var imageUrls = [String]()
    let inset:CGFloat = 20
    var findMeButton: UIButton!
    var header: UIButton!
    var foodName: String
    var foodSearch: String

    init(foodName:String, foodSearch:String) {
        self.foodName = foodName
        self.foodSearch = foodSearch
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.itemSize = CGSize(width: (self.view.frame.width-(80))/3, height: (self.view.frame.width-(80))/3)
        
        header = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        header.backgroundColor = UIColor.redColor()
        header.setTitle(foodName, forState: .Normal)
        self.view.addSubview(header)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height-140), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
        findMeButton = UIButton(frame: CGRect(x: 0, y: self.view.frame.height-60, width: self.view.frame.width, height: 60))
        findMeButton.setTitle("Find Me!", forState: .Normal)
        findMeButton.backgroundColor = UIColor.redColor()
        self.view.addSubview(findMeButton)
    }
    
    func getPhotos(){
        let url = NSURL(string: "https://api.tumblr.com/v2/tagged?tag=rainbow_bagel&api_key=Gdqv3hsXMAPnckNADy6TVLfeUiXh4M1a56jddqL3NRdaC9qeUc")

        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            // put json into an array of image urls
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let posts = json["response"] as? [[String: AnyObject]] {
                    for photos in posts {
                        if let photo = photos["photos"] as? [[String: AnyObject]] {
                            for info in photo {
                                if let links = info["alt_sizes"] as? [[String: AnyObject]] {
                                    if let imageLink = links.last!["url"] as? String {
                                        self.imageUrls.append(imageLink)
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
            
            
            self.collectionView.reloadData()
            
            
        }
        task.resume()
    }
    
//	func getPhotos(onCompletion: (JSON) -> Void) {
//		let route = baseURL
//		makeHTTPGetRequest(route, onCompletion: { json, err in
//			onCompletion(json as JSON)
//		})
//	}
//	
//	func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
//		let request = NSMutableURLRequest(URL: NSURL(string: path)!)
//		
//		let session = NSURLSession.sharedSession()
//		
//		let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//			let json:JSON = JSON(data: data)
//			onCompletion(json, error)
//		})
//		task.resume()
//	}
//	
//	func addDummyData() {
//		RestApiManager.sharedInstance.getRandomUser { json in
//			let results = json["results"]
//			for (index: String, subJson: JSON) in results {
//				let user: AnyObject = subJson["user"].object
//				self.items.addObject(user)
//				dispatch_async(dispatch_get_main_queue(),{
//					collectionView?.reloadData()
//				})
//			}
//		}
//	}
	
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		self.collectionView.registerClass(ImageCell.self, forCellWithReuseIdentifier:"Cell")
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImageCell
//		let user:JSON =  JSON(self.items[indexPath.row])
//		cell.textLabel.text = user["username"].string
//        cell.backgroundColor = UIColor.orangeColor()
        
        if let data = NSData(contentsOfURL: NSURL(string:imageUrls[indexPath.item])!) {
            cell.imageView.image = UIImage(data: data)
        }
        
        return cell
    }
}
