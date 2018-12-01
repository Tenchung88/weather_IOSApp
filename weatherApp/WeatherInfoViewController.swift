//
//  WeatherInfoViewController.swift
//  weatherApp
//
//  Created by Tenzin Chozom on 09/10/18.
//  Copyright © 2018 Tenzin Chozom. All rights reserved.
//

import UIKit

class WeatherInfoViewController: UIViewController
{
    public var StringfromVC : String? //getting the city string from first controller
    @IBOutlet weak var Citynametodisplay: UILabel!
    var myresultarray = [NSArray]()
    var mymodel1:WSLookUp = WSLookUp()
    @IBOutlet weak var myhumid: UILabel!
    @IBOutlet weak var mylabeltemp: UILabel!
    @IBOutlet weak var mytemp: UILabel!
    
    @IBOutlet weak var celcius: UILabel!
    @IBOutlet weak var myimage: UIImageView!
    //on view did load load the text labels with the weather data
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WEATHER INFO"
        self.Citynametodisplay.text = self.StringfromVC?.uppercased()
       // self.celcius.text = "F"
        if let s = StringfromVC{
        mymodel1.weathersearch(searchString: s) {(myarray ) in
            
            DispatchQueue.main.async {
                let firstElement = myarray[0] as! NSDictionary
              //  let otherelement = myarray1[0]
           
                self.mytemp.text = String(firstElement.value(forKey: "temp") as! Double )
                self.myhumid.text = String(firstElement.value(forKey: "humidity") as! Int)
               // self.Description.text = String(otherelement.value(forKey: "description") as!String)
                }}}
        
    }
}


