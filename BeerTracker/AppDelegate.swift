//
//  AppDelegate.swift
//  BeerTracker
//
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    MagicalRecord.setupCoreDataStackWithStoreNamed("Beer")
    // NOTE: If the data model filename (Beer) is identical to the Project name (BeerTracker), the following convenience method can be used instead.  Since they are different, the line above must be used.
    //MagicalRecord.setupCoreDataStack()
   
    //------------------------------------------
    // Prepopulate Beer
    
    // This prevents the default data from getting loaded more than once.
    let preloadKey = NSUserDefaults.standardUserDefaults().objectForKey("MR_HasPrefilledBeers") as? String
    
    //--------------------
    if let preloadKey = preloadKey {
      // Defaults have already been loaded.
      
      // OPTION 2: UNCOMMENT THIS LINE TO FORCE PREPOPULATING BEERS EVEN IF THEY HAVE ALREADY BEEN LOADED ONCE BEFORE.
      //populateBeers()
      
    } else {
      // Defaults have NOT been loaded.
      
      // OPTION 1: UNCOMMENT THIS LINE TO PREPOPULATE BEERS ONLY ONCE.
      //populateBeers()
    }
    //------------------------------------------
    return true
  }
  //#####################################################################
  // MARK: - Prepopulate Data
  
  private func populateBeers() {
    
    //--------------------
    // Blond Ale
    
    let blondAle = Beer.createEntity() as! Beer
    blondAle.name = "Blond Ale"
    
    blondAle.beerDetails = BeerDetails.createEntity() as! BeerDetails
    blondAle.beerDetails.rating = 4
    
    ImageSaver.saveImageToDisk(UIImage(named: "blond.jpg")!, andToBeer: blondAle)
    
    //--------------------
    // Wheat Beer
    
    let wheatBeer = Beer.createEntity() as! Beer
    wheatBeer.name = "Wheat Beer"
    
    wheatBeer.beerDetails = BeerDetails.createEntity() as! BeerDetails
    wheatBeer.beerDetails.rating = 2
    
    ImageSaver.saveImageToDisk(UIImage(named: "wheat.jpg")!, andToBeer: wheatBeer)
    
    //--------------------
    // Pale Lager
    
    let paleLager = Beer.createEntity() as! Beer
    paleLager.name = "Pale Lager"
    
    paleLager.beerDetails = BeerDetails.createEntity() as! BeerDetails
    paleLager.beerDetails.rating = 3
    
    ImageSaver.saveImageToDisk(UIImage(named: "pale.jpg")!, andToBeer: paleLager)
    
    //--------------------
    // Stout
    
    let stout = Beer.createEntity() as! Beer
    stout.name = "Stout"
    
    stout.beerDetails = BeerDetails.createEntity() as! BeerDetails
    stout.beerDetails.rating = 5
    
    ImageSaver.saveImageToDisk(UIImage(named: "stout.jpg")!, andToBeer: stout)
    
    //--------------------
    // Save
    
    NSManagedObjectContext.defaultContext().saveToPersistentStoreWithCompletion(nil)
    
    //--------------------
    // Set User Default to Prevent Subsequent Preloads on startup.
    
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "MR_HasPreFilledBeers")
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  //#####################################################################

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

