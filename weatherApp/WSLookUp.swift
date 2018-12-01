//
//  WSLookUp.swift
//  weatherApp
//
//  Created by Tenzin Chozom on 09/10/18.
//  Copyright © 2018 Tenzin Chozom. All rights reserved.
//

import Foundation


class WSLookUp
{
    
    //performing weather search on openWeathermap API to get the weather info
func weathersearch(searchString: String,complition :  @escaping (([Any])->()))
{
    let newstring = searchString.replacingOccurrences(of: " ", with: "+")
    let str = NSString.init(format: "https://samples.openweathermap.org/data/2.5/forecast?q=%@&appid=b6907d289e10d714a6e88b30761fae22", newstring)
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let myUrl = URL(string : str as String)
    
    let task = session.dataTask(with: myUrl!) {(data, response, error) in
        if(error == nil){
            
            if let xData = data{
                let myStr = String(data: xData, encoding: .utf8)!
                let xnewData = myStr.data(using: .utf8)
                do {
                    let myJson =  try JSONSerialization.jsonObject(with: xnewData!, options: []) as? NSDictionary
                    let resultSet = myJson?.value(forKeyPath: "list.main")
                  //  let result2Set = myJson?.value(forKeyPath: "list.weather")
                
                   // if let result = resultSet  {
                    complition(resultSet as! [Any])
                    //}
                }catch{
                    
                }
                
            }
        }
        
    }
    task.resume()
    }
  /*  var str = NSString.init(format: "https://samples.openweathermap.org/data/2.5/forecast?q=%@&appid=b6907d289e10d714a6e88b30761fae22", searchString)

    let url = NSURL.fileURL(withPath:(str as String))
    let myQ:DispatchQueue = DispatchQueue.init(label: "myqueue")
    myQ.async {
       //var err:NSError? = nil
        do{
           var str1 = try NSString.init(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
            
            let data:NSData = try NSData.init(contentsOf: url)
            let json:NSDictionary = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String: AnyObject] as NSDictionary
            //var weatherset:NSArray = json.
        }catch
        {}
     }}
   */
   


    //permorming the city search to get the  user entered City
    func citySearch(cityName : String, complition :  @escaping (([String]?)->()))
        {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let newCityName = cityName.replacingOccurrences(of: " ", with: "+")//replacing "space" in city name with "+"
        let myUrl = URL(string : "http://gd.geobytes.com/AutoCompleteCity?callback=?&q=\(newCityName)")
        
        let task = session.dataTask(with: myUrl!) { (data, response, error) in
            if(error == nil){
                
                if let xData = data{
                    var myStr = String(data: xData, encoding: .utf8)!
                    myStr = String(myStr.dropFirst(2)) //dropping the first and last 2 characters to get a valid data
                    myStr = String(myStr.dropLast(2))
                    let xnewData = myStr.data(using: .utf8)
                    do {
                        let myJson =  try JSONSerialization.jsonObject(with: xnewData!, options: []) as? [String]
                        
                        complition(myJson)
                        
                    }catch{
                        
                    }
                    
                }
            }
            
        }
        task.resume()
    }
        
        
        
        /*let str = "http://gd.geobytes.com/AutoCompleteCity?callback=?&q=\(cityName)"
        
        var myUrl = URL(string: str1)
      //  let myurl = NSURL.fileURL(withPath:(str as String))
        let citySearchQ:DispatchQueue = DispatchQueue.init(label: "citySearchQueue")
        citySearchQ.async (execute: {
            let err:NSError? = nil
            //let _: NSError?
            do{
                //print(myUrl!)
                //let mydata = try Data.init(contentsOf: myUrl!);
               
                let str1: NSString = try NSString.init(contentsOf: myUrl!, encoding: String.Encoding.utf8.rawValue)
               var mystring = str.dropFirst(2)
                mystring = str.dropLast(2)
                
                var myData : Data = mystring.data(using: String.Encoding.utf8)!
               // let mydata:Data = self.strFormat(strToFormat: str1)
                //let data: NSData = ...some data loaded...
                
                let json = try JSONSerialization.jsonObject(with: myData as Data, options:[]) as! [String]
                if((self.delegate) != nil)
                {
                    self.delegate?.weathersearchDidFinishWithData(data: json)
                }
                }
        catch
            {
                
            }
           
        })
        */
}
