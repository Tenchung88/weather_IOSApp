//
//  ViewController.swift
//  weatherApp
//
//  Created by Tenzin Chozom on 09/10/18.
//  Copyright © 2018 Tenzin Chozom. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UISearchBarDelegate,NSFetchedResultsControllerDelegate,UITableViewDelegate,UITableViewDataSource
{
  
    var mymodel = WSLookUp()
    var myweather:WeatherInfoViewController = WeatherInfoViewController()//outlet
    lazy var myAppdelegate : AppDelegate = {
        return (UIApplication.shared.delegate as! AppDelegate)//create object of APPdelegate
    }()
    
    
    @IBOutlet weak var MytableView: UITableView!
    
    //fetch controller to get the data from coredata
    lazy var fetchcontroller : NSFetchedResultsController<City> =
        
        {
            let fetch = NSFetchRequest<City>(entityName: "City") //creating fetch request object on the entity "City"
            
            
            let sort1 = NSSortDescriptor(key: "cityName", ascending: true)//sorting on the basis of city
            let sort2 = NSSortDescriptor(key: "country", ascending: true)//sorting on the basis of country
            
            fetch.sortDescriptors = [sort1,sort2] //providing sort descriptors in an array
            
            
            let tempFetch =  NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: myAppdelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            tempFetch.delegate = self;
            return tempFetch
            
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performFetchfucntion()
        self.title = "WEATHER:Select the City"// set the title for view controller
        //MytableView.reloadData()
    }
    
    //making the number of rows dynamic on the basis of sections.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
       return (fetchcontroller.sections![section]).numberOfObjects
        
    }
    
    //displaying the city name and country on the cell of the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let p = fetchcontroller.object(at: indexPath)
        cell?.textLabel?.text = p.cityName
        cell?.detailTextLabel?.text = p.country
        
        return cell!
        
    }
    
    //to get the delete option for the city when the user swipe on the row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //deciding the editing style to be delete
        if(editingStyle == .delete){
            
            let toDelteObj = fetchcontroller.object(at: indexPath); myAppdelegate.persistentContainer.viewContext.delete(toDelteObj)
            myAppdelegate.saveContext()
        }
        
    }
    
    //to confirm the delete
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "DELETE"
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        MytableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            MytableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            MytableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            MytableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
           MytableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            MytableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            MytableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        MytableView.endUpdates()
    }
  /*  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myindexpath = tableView.indexPathForSelectedRow
        let mycell = tableView.cellForRow(at: myindexpath!)
        mymodel.weathersearch(searchString: (mycell?.textLabel?.text)!) { (myarray) in
            if let xmyarray =  myarray {
                DispatchQueue.main.async {
                    self.myweatherarray = xmyarray
                    if(self.delegate != nil)
                    {
                        
                    }
                }}}
    }*/
    
    //prepare for seque-method to pass the city name to WeatherInfoViewController
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "weather"){
            let WVC:WeatherInfoViewController = segue.destination as! WeatherInfoViewController
            let myindexpath = MytableView.indexPathForSelectedRow
            let mycell = MytableView.cellForRow(at: myindexpath!)
            let mystring:String = (mycell?.textLabel?.text)!
        WVC.StringfromVC = mystring
           
           // mymodel.weathersearch(searchString: (mycell?.textLabel?.text)!) { (myarray) in
            //if let xmyarray =  myarray {
              //  DispatchQueue.main.async {
            
    }
    
    }
    
    // to look up for city from core data
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
   
        let myPredicate : NSPredicate?
        
        if(searchText.count > 0){
            
            myPredicate =  NSPredicate(format: "cityName Contains[c] %@", searchText)
        }
        else{
            myPredicate = nil
        }
        fetchcontroller.fetchRequest.predicate = myPredicate;
        
        performFetchfucntion()
        
        MytableView.reloadData()
    }
    
    func performFetchfucntion() {
        do
        {
            
            try  fetchcontroller.performFetch()
        }catch{
            
        }
    }
    /* func fetch()
    {
        //fetching all cities from database
        // no predicate
        let myFetrequest :NSFetchRequest<City> = City.fetchRequest()
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        myFetrequest.sortDescriptors = [sorter]
        
        
        do
        {
            myFetresult =  try mypersistentContainer?.viewContext.fetch(myFetrequest)
            
        }
        catch {}
        }*/
}

