//
//  CountrySearchhViewController.swift
//  Countries
//
//  Created by admin on 22/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import SVGKit

class CountrySearchhViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet var searchbarView : UISearchBar!
    @IBOutlet var countrieslistTbv : UITableView!
   
    var countrydetailsArray = [CountriesdataModel]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.countrieslistTbv.separatorStyle = UITableViewCell.SeparatorStyle.none
        configureNavBar()
    }
    
    func configureNavBar()
    {
        self.title = "Countries Search"
    }
    
    func getcontries(str : String)
    {
        if ConnectionCheck.isConnectedToNetwork()
        {
            var urlToRequest = "https://restcountries.eu/rest/v2/name/" as String
            urlToRequest = urlToRequest + str
            let url4 = URL(string: urlToRequest)!
            let session4 = URLSession.shared
            let request = NSMutableURLRequest(url: url4)
            request.httpMethod = "GET"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
                guard let _: Data = data, let _: URLResponse = response, error == nil else {

                    print("*****error")
                    return
                }
                
                let jwt = String(data: data!, encoding: .utf8)!
                if jwt.contains("Not Found")
                {
                     self.countrydetailsArray = [CountriesdataModel]()
                }
                else
                {
                    let jsonData = jwt.data(using: .utf8)!
                    do
                    {
                        let decodeJson  = JSONDecoder()
                        decodeJson.keyDecodingStrategy = .convertFromSnakeCase
                        self.countrydetailsArray = try decodeJson.decode([CountriesdataModel].self, from: jsonData)
                    }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
                if(self.countrydetailsArray.count>0)
                {
                    DispatchQueue.main.async
                    {
                        self.countrieslistTbv.isHidden = false
                        self.countrieslistTbv.reloadData()
                    }
                }
                else
                {
                    DispatchQueue.main.async
                    {
                        self.countrieslistTbv.isHidden = true
                        self.countrieslistTbv.reloadData()
                    }
                }
            }
            task.resume()
        }
        else
        {
            let alert = UIAlertController(title: "Countries!", message: "Please check your Internet Connection.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Searchbar delegates
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        print(searchBar.text!)
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        countrydetailsArray = [CountriesdataModel]()
        let str = searchBar.text! as NSString
        let textafterupdate = str.replacingCharacters(in: range, with: text)
        if(textafterupdate.contains("\n"))
        {

        }
        else
        {
            if(textafterupdate.count > 0)
            {
                DispatchQueue.global().async
                    {
                        self.getcontries(str: textafterupdate)
                }
            }
            else
            {
                self.countrieslistTbv.isHidden = true
                self.countrydetailsArray = [CountriesdataModel]()
            }
        }
        return true
    }


    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.countrieslistTbv.isHidden = false
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if(searchText == "")
        {
            countrydetailsArray = [CountriesdataModel]()
        }
        if(countrydetailsArray.count>0)
        {
            self.countrieslistTbv.isHidden = false
            self.countrieslistTbv.reloadData()
        }
        else
        {
            self.countrieslistTbv.isHidden = true
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    // Tableview Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return countrydetailsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryListCell") as! CountryListTableViewCell
        if (countrydetailsArray.count > 0)
        {
            cell.countrynameLbl.text = countrydetailsArray[indexPath.row].name
            var svgurl = String()
            cell.countryflagIV.image = UIImage(named: "download_placeholder")
            if (countrydetailsArray[indexPath.row].flag == "https://restcountries.eu/data/shn.svg")
            {
            svgurl = ""
            }
            else
            {
                svgurl = countrydetailsArray[indexPath.row].flag
            }
            if (svgurl == "")
            {
                
            }
            else
            {
                if let image = cacheHandler.shared.imageForKey(svgurl  as String)
                {
                    cell.countryflagIV.image = image
                }
                else
                {
                cell.countryflagIV.downloadImageFrom(link: svgurl, contentMode: UIView.ContentMode.scaleAspectFit)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(identifier: "countrydetails")
        UserDefaults.standard.set(countrydetailsArray[indexPath.row].capital, forKey: "countryDetcapital")
        UserDefaults.standard.set(countrydetailsArray[indexPath.row].name, forKey: "countryDetname")
        UserDefaults.standard.set(countrydetailsArray[indexPath.row].flag, forKey: "countryDetflag")
        let cc = countrydetailsArray[indexPath.row].callingCodes.joined(separator: ",")
        UserDefaults.standard.set(cc, forKey: "countryDetcallingcode")
        UserDefaults.standard.set(countrydetailsArray[indexPath.row].region, forKey: "countryDetregion")
        UserDefaults.standard.set(countrydetailsArray[indexPath.row].subregion, forKey: "countryDetsubregion")
        let languages = countrydetailsArray[indexPath.row].languages.map { $0.name }.joined(separator: ", ")
        UserDefaults.standard.set(languages, forKey: "countryDetlanguages")
        
        let currencies = countrydetailsArray[indexPath.row].currencies.compactMap { $0.code ?? $0.name }.joined(separator: ", ")
        UserDefaults.standard.set(currencies, forKey: "countryDetcurrencies")
        let timezones = countrydetailsArray[indexPath.row].timezones.joined(separator: ", ")
        UserDefaults.standard.set(timezones, forKey: "countryDettimezones")
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}

extension UIImageView {
    
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data {
                    let anSVGImage: SVGKImage = SVGKImage(data: data)
                    self.image = anSVGImage.uiImage
                    cacheHandler.shared.setImage(image: self.image!, forKey: link as String)
                }
            }
        }).resume()
    }
}

