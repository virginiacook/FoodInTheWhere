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
    
    func loadYelp(){
        // using the location and the keyword, find places containing the desired food item in a two mile radius to the latitude and longitude
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