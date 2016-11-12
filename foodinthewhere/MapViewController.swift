//
//  MapViewController.swift
//  foodinthewhere
//
//  Created by Virginia Cook on 11/6/16.
//  Copyright © 2016 Virginia Cook. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var userLocation:CLLocation?
    var center:CLLocationCoordinate2D?
    var camera:GMSCameraPosition?
    var mapView:GMSMapView?
    var markersInfo:[Marker] = []
    var markersLoaded = false
    
    override func loadView() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self

        if CLLocationManager.locationServicesEnabled() {
            //locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // set the camera and map position
        
        //default zoom is to empire state building in NYC
        
        userLocation = CLLocation(latitude: 40.75, longitude: -73.99)
        
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.cameraWithLatitude(userLocation!.coordinate.latitude,
                                                          longitude: userLocation!.coordinate.longitude, zoom: 14.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = center
        marker.map = mapView
        loadYelp()
        // since the map api cannot be called on the main thread, this is a workaround
        var loadMapWithResults = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(MapViewController.loadMarkers), userInfo: nil, repeats: true)
        //new idea, food trends
        //sushiritto, cronut, avocado toast,
        
        //tumblr
        //Gdqv3hsXMAPnckNADy6TVLfeUiXh4M1a56jddqL3NRdaC9qeUc
        //create gridview
        //curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://api.tumblr.com/v2/tagged?tag=sushiritto&api_key=Gdqv3hsXMAPnckNADy6TVLfeUiXh4M1a56jddqL3NRdaC9qeUc"
        
        //yelp
        
        //curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://api.yelp.com/v2/search?term=food&location=San+Francisco&oauth_consumer_key=-_1KpAEOaNwru8fE66TbcQ&oauth_token=wEHDFLc4Mw9OUYgG9CoA1NH2Q4hLyjN_&oauth_signature_method=HMAC-SHA1&oauth_signature=uuUPP1-W01p0igV0NngEBNMd8qU&oauth_timestamp=1478862392&oauth_nonce=e23ke2390wd"
        
        
        //instagram token
        //4125010399.1677ed0.37f19313de9e4c9fa0808dcd0896a61a
        //food in the air instagram id
        //492065208
        //https://api.instagram.com/v1/users/{user-id}/media/recent/?access_token=ACCESS-TOKEN
        //curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://api.instagram.com/v1/users/492065208/media/recent/?access_token=4125010399.1677ed0.37f19313de9e4c9fa0808dcd0896a61a&scope=public_content"
        
        //curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyCQqxSAR8sjmLsij-sVI5X2sf9YBB99bi0&location=40.75,-73.99&radius=10000&keyword=cronut"
        
        //meetup
        //food and drink id -> 10
        
        //AIzaSyCQqxSAR8sjmLsij-sVI5X2sf9YBB99bi0
        //curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://api.meetup.com/find/groups?category=10&zip=10022"
        //meetup api key
        //5c374a3e58f244291ba44633c4044
        
        //https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAQaoVp-sYpNU0iRPi8pf2_7Wm6ljBsYcE&location=40.75,-73.99&radius=10000&keyword=cronut


    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error" + error.description)
    }
    
    func loadYelp() {
        // using the location and the keyword, find places containing the desired food item in a two mile radius to the latitude and longitude
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyCQqxSAR8sjmLsij-sVI5X2sf9YBB99bi0&location=40.75,-73.99&radius=10000&keyword=cronut")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            // parse json to add a marker for each relevant restaurant
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let places = json["results"] as? [[String: AnyObject]] {
                    // create new array
                    var newMarkersInfo:[Marker] = []
                    // get name and geometry
                    for place in places {
                        let marker = Marker()
                        if let geometry = place["geometry"] as? [String: AnyObject] {
                            if let location = geometry["location"] as? [String: AnyObject] {
                                if let latitude = location["lat"] as? Double {
                                    // set latitude
                                    marker.latitude = latitude
                                }
                                if let longitude = location["lng"] as? Double {
                                    // set longitude
                                    marker.longitude = longitude
                                }
                            }
                        }
                        if let name = place["name"] as? String {
                            marker.name = name
                        }
                        
                        // add the new marker to the new array
                        newMarkersInfo.append(marker)
                    }
                    // set the old marker values array to the new values array
                    self.markersInfo = newMarkersInfo
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func loadMarkers() {
        if (markersInfo.count == 0 || markersLoaded) {
            return
        }
        for markerInfo in markersInfo {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: markerInfo.latitude!, longitude: markerInfo.longitude!)
            marker.snippet = markerInfo.name!
            marker.map = self.view as? GMSMapView
        }
        markersLoaded = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        camera = GMSCameraPosition.cameraWithLatitude(userLocation!.coordinate.latitude,
                                                          longitude: userLocation!.coordinate.longitude, zoom: 8)
        mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera!)
        mapView!.myLocationEnabled = true
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = center!
        marker.map = mapView
        
        locationManager.stopUpdatingLocation()
    }
}