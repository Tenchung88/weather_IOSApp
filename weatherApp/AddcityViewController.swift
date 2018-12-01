//
//  AddcityViewController.swift
//  weatherApp
//
//  Created by Tenzin Chozom on 09/10/18.
//  Copyright © 2018 Tenzin Chozom. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class AddcityViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate
{
      var Myresult = [String]() //array to store the response of the cities
    @IBOutlet weak var addcitytableview: UITableView!
    var myModel:WSLookUp = WSLookUp()
    
    //method to get the current location of the user .For now the co-ordinates are set to Toronto
    @IBAction func getCurrentLocation(_ sender: Any) {
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways,.authorizedWhenInUse://checking the authorization here to get the location
                print("Authorized")
                let currentLocation = locationManager.location
                let lat = currentLocation?.coordinate.latitude
                let long = currentLocation?.coordinate.longitude
                if let newLat = lat{
                    if let newLong = long{
                let location = CLLocation(latitude: newLat,longitude: newLong)
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                    if(error != nil){
                        print("in error block")
                        return
                    }else if let country = placemarks?[0].country,
                    let userCity = placemarks?.first?.locality{
                        print("in else block country and  city")
                        print(country)
                        print(userCity)
                        self.getLocationInsertion(city: userCity, country: country)
                    }
                })
            }
                }
                break
            case .notDetermined,.restricted,.denied: //else block if user deny the app to use the location service
                print("in not determined block ")
                break
            }
            
        }
        
    }
    lazy var myAppdelegate : AppDelegate = {
        return (UIApplication.shared.delegate as! AppDelegate)
    }()
  
    //defining the rows for the tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Myresult.count
    }
    //to save the selected city and its country to core data
    @IBAction func SaveButtonPressed()
    {
        
    let p1 = NSEntityDescription.insertNewObject(forEntityName: "City", into: myAppdelegate.persistentContainer.viewContext) as! City
        //let p2 = NSEntityDescription.insertNewObject(forEntityName: "Country", into: myAppdelegate.persistentContainer.viewContext) as! Country
            let currentPath = addcitytableview.indexPathForSelectedRow
            let currentcell = addcitytableview.cellForRow(at:currentPath!)
            p1.cityName = currentcell?.textLabel?.text
            p1.country = currentcell?.detailTextLabel?.text
            myAppdelegate.saveContext()
                
        let alertcontroller = UIAlertController(title: "", message:"SELECTED CITY AND ITS COUNTRY ARE SAVED TO DATABASE", preferredStyle: .alert)
                let defaultaction = UIAlertAction(title: "close alert", style: .default, handler: nil)
                alertcontroller.addAction(defaultaction)
                self.present(alertcontroller, animated: true,completion: nil)
                
                self.dismiss(animated: true, completion: nil)
        
        
        }
    //function to add the current location city and country to core data
    func getLocationInsertion(city : String, country : String)
    {
        
        let p1 = NSEntityDescription.insertNewObject(forEntityName: "City", into: myAppdelegate.persistentContainer.viewContext) as! City
        p1.cityName = city
        p1.country = country
        myAppdelegate.saveContext()
        
        let alertcontroller = UIAlertController(title: "", message:"SELECTED CITY AND ITS COUNTRY ARE SAVED TO DATABASE", preferredStyle: .alert)
        let defaultaction = UIAlertAction(title: "close alert", style: .default, handler: nil)
        alertcontroller.addAction(defaultaction)
        self.present(alertcontroller, animated: true,completion: nil)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //title for cell for row from server
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let value = Myresult[indexPath.row]
        let array = value.split(separator: ",") //splitting the response based on the ","
        if(array.count > 1){
            cell?.textLabel?.text = "\(array[0])"
            cell?.detailTextLabel?.text = "\(array[2])"
            
            
        }
        return cell!
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    // to look up for city from server
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
     {
        if(searchText.count > 3){
            myModel.citySearch(cityName: searchText) { (myarray) in
            if let xmyarray =  myarray { //check for optional data
                DispatchQueue.main.async {
                    self.Myresult = xmyarray //populating the Myresult array with the response data from the citySearch function returened arrray
                    self.addcitytableview.reloadData()
                }}}
    }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ADD CITY"
       
    }
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
            {
                
                if let myUrwarappedpersistentContainer = self.mypersistentContainer
                {
                    
                    let p1 = NSEntityDescription.insertNewObject(forEntityName: "City", into: myUrwarappedpersistentContainer.viewContext) as! City
                    let currentPath = tableView.indexPathForSelectedRow
                    let currentcell = tableView.cellForRow(at:currentPath ?? indexPath)
                    p1.name = currentcell?.textLabel?.text
                    
                    
                    do{
                        try  myUrwarappedpersistentContainer.viewContext.save()
                    
                        let alertcontroller = UIAlertController(title: "", message: "Selected city is saved to Database", preferredStyle: .alert)
                        let defaultaction = UIAlertAction(title: "close alert", style: .default, handler: nil)
                        alertcontroller.addAction(defaultaction)
                        self.present(alertcontroller, animated: true,completion: nil)
                        
                        self.dismiss(animated: true, completion: nil)
                    }catch{
                        
                    }
                    
                    
                }
                
            }*/
            
        }






