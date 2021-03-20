//
//  ViewController.swift
//  Access2
//
//  Created by Akanksha Trivedi on 28/10/20.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore


class ViewController: UIViewController {
    
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createData()
        read()
    }
    
    @IBAction func newDBPressed(_ sender: UIButton) {
        
        newDatabase()
        
    }
    @IBAction func pushNavPressed(_ sender: UIButton) {
        
        pushNav()
        
    }
    @IBAction func presentNavPressed(_ sender: UIButton) {
        
        presentNav()
        
    }
    
    
    func presentNav() {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        //        self.present(vc, animated: true, completion: nil)
        
        // Safe Present
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondPresent") as? SecondDataBaseVC
        {
            present(vc, animated: true, completion: nil)
        }
    }
    
    func pushNav() {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        //        navigationController?.pushViewController(vc, animated: true)
        
        // Safe Push VC
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThirdPush") as? ThirdVC {
            if let navigator = navigationController
            {
                navigator.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    
    // create data for Realtime database
    func createData() {
        
        
        //method1
        let ref = Database.database().reference()
        ref.child("Chat_room1").setValue(["message":"hey you"])
        ref.child("players/Mohan").setValue(["name":"marry","ID":"1234"])
        ref.child("players/henna").setValue(["name":"rajnikant","ID":"007"])
        
        //method2
        let playersRef = ref.child("players/henna")
        playersRef.setValue(["name":"marry","ID":"123456"])
        
        //method3
        let object: [String:Int] = [
            "name":12,
            "Youtube":34
        ]
        ref.child("somethingAdded").setValue(object) {
            (error, reference) in
            if error != nil{
                print(error!)
            }else {
                print("Data saved successfully!")
            }
        }
    }
   
    //reading data from realtime database
    func read() {
        
        let ref = Database.database().reference()
        
        ref.child("somethingAdded").observe(.value) { (snapshot) in
            if let value = snapshot.value as? Dictionary<String,Int> {
                let username = value["Youtube"]
                let userID = value["name"]
                print("I am fine.")
                print("user::::::::::\(username), ID::::::::\(userID)")
                
                
                
                ref.child("players/Mohan").observe(.value) { (snapshot) in
                    if let value = snapshot.value as? Dictionary<String,String>  {
                        let username = value["name"]
                        let userID = value["ID"]
                        print("I am grt.")
                        print("user::::::\(username), ID::::::\(userID)")
                    }
                }}}}
    
  
    // data storing into Cloud Firestore
    func newDatabase() {
        
        
        let db = Firestore.firestore()
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        
        // Add a second document with a generated ID.
        ref = db.collection("users").addDocument(data: [
            "first": "Alan",
            "middle": "Mathison",
            "last": "Turing",
            "born": 1912
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        
        // Reading document from Cloud Firestore
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("userIDDetails:::::\(document.documentID) => userDetails::::\(document.data())")
                }
            }
        }
        
        
        //Security rules
        // Allow read/write access on all documents to any user signed in to the application
        //    service cloud.firestore {
        //      match /databases/{database}/documents {
        //        match /{document=**} {
        //          allow read, write: if request.auth != null;
        //        }
        //      }
        //    }
        //
        
        
    }
    
}
