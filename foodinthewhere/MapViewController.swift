//
//  MapViewController.swift
//  foodinthewhere
//
//  Created by Virginia Cook on 11/6/16.
//  Copyright © 2016 Virginia Cook. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    override func loadView() {
        // set the camera and map position
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
        // create markers
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        //new idea, food trends
        //sushiritto, cronut, avocado toast,
        
        //tumblr
        //Gdqv3hsXMAPnckNADy6TVLfeUiXh4M1a56jddqL3NRdaC9qeUc
        //create gridview
        //curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://api.tumblr.com/v2/tagged?tag=sushiritto&api_key=Gdqv3hsXMAPnckNADy6TVLfeUiXh4M1a56jddqL3NRdaC9qeUc"
        
        //instagram token
        //4125010399.1677ed0.37f19313de9e4c9fa0808dcd0896a61a
        //food in the air instagram id
        //492065208
        //https://api.instagram.com/v1/users/{user-id}/media/recent/?access_token=ACCESS-TOKEN
        //curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://api.instagram.com/v1/users/492065208/media/recent/?access_token=4125010399.1677ed0.37f19313de9e4c9fa0808dcd0896a61a&scope=public_content"
        
        //curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://api.instagram.com/v1/users/self/?access_token=4125010399.1677ed0.37f19313de9e4c9fa0808dcd0896a61a"
        
        //meetup
        //food and drink id -> 10
        //curl -X GET -H "Content-type: application/json" -H "Accept: application/json"  "https://api.meetup.com/find/groups?category=10&zip=10022"
        //meetup api key
        //5c374a3e58f244291ba44633c4044

    }
}