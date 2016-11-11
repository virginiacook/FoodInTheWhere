//
//  ImageCell.swift
//  foodinthewhere
//
//  Created by Virginia Cook on 11/9/16.
//  Copyright © 2016 Virginia Cook. All rights reserved.
//

import UIKit
class ImageCell: UICollectionViewCell {
	var textLabel: UILabel!
	var imageView: UIImageView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*2/3))
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		contentView.addSubview(imageView)
		
		textLabel = UILabel(frame: CGRect(x: 0, y: imageView.frame.size.height, width: frame.size.width, height: frame.size.height/3))
		textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
		textLabel.textAlignment = .Center
		contentView.addSubview(textLabel)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

