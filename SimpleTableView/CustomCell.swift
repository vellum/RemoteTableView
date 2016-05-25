//
//  CustomCell.swift
//  SimpleTableView
//
//  Created by David Lu on 5/24/16.
//  Copyright © 2016 Andrei Puni. All rights reserved.
//

import UIKit

class CustomCell : UITableViewCell {
    @IBOutlet var highlight: UIView?
    
    func highlight(shouldHighlight: Bool){
        print(shouldHighlight)
        if ( shouldHighlight ){
            highlight?.alpha = 0.5
        } else {
            
            highlight?.alpha = 0
        }
    }
}
