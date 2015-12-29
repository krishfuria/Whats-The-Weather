//
//  ViewController.swift
//  Whats the Weather
//
//  Created by Krish Furia on 12/28/15.
//  Copyright © 2015 Krish Furia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var result: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var findWeatherButtonOutlet: UIButton!
    
    @IBAction func findWeatherButton(sender: AnyObject) {
        
        findWeatherButtonOutlet.enabled = false
        
        var wasSuccessful = false
        
        var city = cityTextField.text!
        
        city = city.stringByReplacingOccurrencesOfString(" ", withString: "-")

        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + city + "/forecasts/latest")
        
        if let url = attemptedUrl {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                if let urlContent = data {
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    if websiteArray.count > 1 {
                        let summaryArray = websiteArray[1].componentsSeparatedByString("</span>")
                        if summaryArray.count > 1 {
                            var summary = String(summaryArray[0])
                            summary = summary.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            wasSuccessful = true
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.result.text = summary
                                self.result.textColor = UIColor.greenColor()
                            })
                        }
                    }
                }
                if let urlError = error {
                    print("Error: \(urlError)")
                }
                else {
                    print("Response: \(response!)")
                }
                if wasSuccessful == false {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.result.text = "Could not find weather for that city - Please try again!"
                        self.result.textColor = UIColor.redColor()
                    })
                }
            }
            task.resume()
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.result.text = "Could not find weather for that city - Please try again!"
                self.result.textColor = UIColor.redColor()
            })
        }
        findWeatherButtonOutlet.enabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

