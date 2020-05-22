//
//  CountrydetailsViewController.swift
//  Countries
//
//  Created by admin on 21/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

var countrydetailsArray = [CountriesdataModel]()
class CountrydetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var countrydetailsIv:UIImageView!
    @IBOutlet var countrydetailsTbv:UITableView!
    
    var titlearray = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titlearray = ["Capital", "Calling Code", "Region", "Sub Region", "Languages", "Currencies", "Time Zone"]
        self.countrydetailsTbv.layer.borderWidth = 0.5
        self.countrydetailsTbv.estimatedRowHeight = 30
        self.countrydetailsTbv.rowHeight = UITableView.automaticDimension
        self.countrydetailsTbv.separatorStyle = UITableViewCell.SeparatorStyle.none
        updateImage()
        countrydetailsTbv.reloadData()
        configureNavBar()
    }
    
    func configureNavBar()
    {
        self.title = (UserDefaults.standard.value(forKey: "countryDetname") as! String)
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "back"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(backButtonPressed), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 10, height: 10)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backButtonPressed()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateImage()
    {
        var svgurl = (UserDefaults.standard.value(forKey: "countryDetflag") as! String)
        if (svgurl == "https://restcountries.eu/data/shn.svg")
        {
            svgurl = ""
        }
        if (svgurl == "")
        {
        
        }
        else
        {
            if let image = cacheHandler.shared.imageForKey(svgurl  as String)
            {
                self.countrydetailsIv.image = image
            }
            else
            {
                self.countrydetailsIv.downloadImageFrom(link: svgurl, contentMode: UIView.ContentMode.scaleAspectFit)
            }
        }
    }
    
    //Tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titlearray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countrydetailscell") as! CountrydetailsTableViewCell
        cell.cdtitleLbl.text = (titlearray[indexPath.row] as! String)
        if (indexPath.row == 0)
        {
            cell.cddataLbl.text = (UserDefaults.standard.value(forKey: "countryDetcapital") as! String)
        }
        else if (indexPath.row == 1)
        {
            cell.cddataLbl.text = (UserDefaults.standard.value(forKey: "countryDetcallingcode") as! String)
        }
        else if (indexPath.row == 2)
        {
            cell.cddataLbl.text = (UserDefaults.standard.value(forKey: "countryDetregion") as! String)
        }
        else if (indexPath.row == 3)
        {
            cell.cddataLbl.text = (UserDefaults.standard.value(forKey: "countryDetsubregion") as! String)
        }
        else if (indexPath.row == 4)
        {
            cell.cddataLbl.text = (UserDefaults.standard.value(forKey: "countryDetlanguages") as! String)
        }
        else if (indexPath.row == 5)
        {
            cell.cddataLbl.text = (UserDefaults.standard.value(forKey: "countryDetcurrencies") as! String)
        }
        else if (indexPath.row == 6)
        {
            cell.cddataLbl.text = (UserDefaults.standard.value(forKey: "countryDettimezones") as! String)
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }

}
