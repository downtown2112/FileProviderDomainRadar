//
//  ViewController.swift
//  FileProviderDomainRadar
//
//  Created by fred.a.brown on 11/8/17.
//  Copyright © 2017 Zebrasense. All rights reserved.
//

import UIKit
import FileProvider

class ViewController: UIViewController {

    @IBOutlet weak var domainTable:UITableView!
    
    var domains:[NSFileProviderDomain] = [NSFileProviderDomain]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        domainTable.dataSource = self
        
        NSFileProviderManager.getDomainsWithCompletionHandler { (existingDomains, error) in
            if let foundError = error {
                print(foundError)
            } else {
                self.domains = existingDomains
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    ///
    /// Use NSFileProviderManager to delete the the first domain from the data source
    ///
    @IBAction func deleteDomain(_ sender: Any) {
        if let domainToDelete = domains.first {
            NSFileProviderManager.remove(domainToDelete) { error in
                if let foundError = error {
                    print(foundError)
                } else {
                    DispatchQueue.main.async {
                        self.domains.removeFirst()
                        self.domainTable.reloadData()
                        print("Domain deleted: \(domainToDelete.identifier.rawValue)")
                    }
                    
                }
            }
        }
    }
    
    ///
    /// Use NSFileProviderManager to create a dummy file provider domain
    /// The identifier, display name and relative path are obtained from
    ///   a series of 5 random characters
    ///
    @IBAction func addDomain(_ sender: Any) {
        let domainID = NSFileProviderDomainIdentifier.init(randomString(length: 5))
        let domain = NSFileProviderDomain.init(identifier: domainID,
                                               displayName: domainID.rawValue,
                                               pathRelativeToDocumentStorage: domainID.rawValue)
        
        NSFileProviderManager.add(domain) { error in
            if let foundError = error {
                print(foundError)
            } else {
                DispatchQueue.main.async {
                    self.domains.append(domain)
                    self.domainTable.reloadData()
                    print("Domain added: \(domain.identifier.rawValue)")
                }
            }
        }
        
    
    }
    
    ///
    /// Use NSFileProviderManager to remove all domains
    ///
    @IBAction func deleteAllDomains(_ sender: Any) {
        NSFileProviderManager.removeAllDomains { (error) in
            if let foundError = error {
                print(foundError)
            } else {
                print("All domains removed")
                self.domains.removeAll()
                DispatchQueue.main.async {
                    self.domainTable.reloadData()
                }
                
            }
        }
    }
    
    ///
    /// Helper function to create a random string of characters
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

// MARK: UITableViewDataSource
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return domains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let foundDomain = domains[indexPath.row]
        
        cell.textLabel?.text = foundDomain.identifier.rawValue
    
        
        return cell
        
    }
    
    
}



