//
//  TalkViewController.swift
//  SimpleTableView
//
//  Created by David Lu on 5/24/16.
//  Copyright © 2016 Andrei Puni. All rights reserved.
//

import UIKit


class TalkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var items: [String] = ["one", "two", "three"]
    var selected = [false, false, false, false]
    
    var index = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        items.append("back")
        
        //let nib = UINib.init(nibName: "CustomCell", bundle: nil)
        //self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        //self.tableView.registerClass(CustomCell.self, forCellReuseIdentifier: "cell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    deinit {
        /*
        let audioSession = AVAudioSession.sharedInstance()
        session = nil
        do {
            audioSession.removeObserver(self, forKeyPath: "outputVolume")
            try audioSession.setActive(false)
        } catch _ {
        }
         */
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell:CustomCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as! CustomCell
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = self.items[indexPath.row]
        //cell.highlight?.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)
        //cell.highlight?.hidden = !self.selected[indexPath.row]
        //cell.highlight(self.selected[indexPath.row])
        //cell.highlight(selected[indexPath.row])
        /*
        if (selected[indexPath.row]){
            cell.selectedBackgroundView?.hidden = false//?.backgroundColor = UIColor.blueColor()
            
        } else {
            cell.selectedBackgroundView?.hidden = true//.backgroundColor = UIColor.clearColor()
            
        }*/
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        if (indexPath.row == self.items.count-1) {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("TalkViewController") as UIViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
    }
    
    // mark
    func up(){
        print("received up command")
        index -= 1
        if (index < 0){
            index = items.count-1
        }
        print(index)
        markCell()
    }
    
    func down(){
        print("received down command")
        index += 1
        if (index > items.count-1){
            index = 0
        }
        print(index)
        markCell()
    }
    
    func select(){
        print("received select")
        print(index)
        if (index < 0){
            return
        }
        if (index == self.items.count-1) {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("TalkViewController") as UIViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    func markCell(){
        if (index < 0){
            return
        }
        let ip = NSIndexPath(forRow: index, inSection: 0)
        self.tableView.selectRowAtIndexPath(ip, animated: false, scrollPosition: UITableViewScrollPosition.Middle)

    }

}
