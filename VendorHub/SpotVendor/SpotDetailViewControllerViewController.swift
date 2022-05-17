//
//  SpotDetailViewControlle2
//
//  Created by Dimitar Krastev on 5/5/22.
//


import UIKit
import GooglePlaces
import GoogleMaps
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth

class SpotDetailViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var addressTextField: UITextField!
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    var vendorLocation: VendorLocation!
    var vendorLocations: [VendorLocation] = []
    var vendorAddress: String!
    
    
    //retrurn zero
    var lat = VendorLocation().latitude.self
    var long = VendorLocation().longitude.self

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if vendorLocation == nil{
            vendorLocation = VendorLocation()
            
        }
        
        updateUserInterface()
    }
    
    func updateUserInterface () {
        addressTextField.text = vendorLocation.address
        
    }
    
    func updateFomInterface() {
        
        vendorLocation.address = addressTextField.text ?? "No address"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationListViewController
        destination.vendorLocations = vendorLocations
        
        
    }
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationListViewController
        vendorLocations = source.vendorLocations
        vendorLocation = vendorLocations[source.selectedLocationIndex]
        updateUserInterface()
    }
    
    
    @IBAction func saveLocationButtonPressed(_ sender: UIButton) {
        
        updateFomInterface()
        
        if let currentuser = (auth.currentUser?.uid), let vendorName = nameTextField.text, let vendorAddress = addressTextField.text {
            db.collection("Vendor").document(currentuser).collection("Locations").addDocument(data: ["name": vendorName, "address": vendorAddress, "latiude": vendorLocation.latitude, "longtitude": vendorLocation.longitude]) { (error) in
                if let e = error {
                    print("For some reason the data can not be saved to the cloud! \(e)")
                } else {
                    print ("The data was saved succesfully!")
                }
            }
            
        }
        
    }
}
