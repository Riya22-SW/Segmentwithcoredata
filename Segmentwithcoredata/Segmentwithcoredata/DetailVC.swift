//
//  DetailVC.swift
//  Segmentwithcoredata
//
//  Created by admin on 13/12/24.
//

import UIKit
import CoreData

class DetailVC: UIViewController {

    @IBOutlet weak var txt4: UITextField!
    @IBOutlet weak var txt3: UITextField!
    @IBOutlet weak var txt2: UITextField!
    @IBOutlet weak var txt1: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cdaddbtn(_ sender: Any) {
        let jid=Int(txt1.text!)!
        let jtype=txt2.text!
        let jsetup=txt3.text!
        let jpunchline=txt4.text!
        
        let newjoke=JokeModel(id: jid, type: jtype, setup: jsetup, punchline: jpunchline)
        addcoredata(jokeobject: newjoke)
    }
    
    
//     joke data add in core data
    func addcoredata(jokeobject:JokeModel){
        guard let delegate=UIApplication.shared.delegate as? AppDelegate else
        {return }
        
        let managecontext=delegate.persistentContainer.viewContext
        
        guard let userEntity=NSEntityDescription.entity(forEntityName: "Jokes", in: managecontext) else{
            return
        }
        
        let joke=NSManagedObject(entity: userEntity, insertInto: managecontext)
        
        joke.setValue(jokeobject.id, forKey:"id")
        joke.setValue(jokeobject.type, forKey: "type")
        joke.setValue(jokeobject.setup, forKey: "setup")
        joke.setValue(jokeobject.punchline, forKey: "punchline")
        
        
        do{
            try
            managecontext.save()
            debugPrint("Core data saved")
        }
        catch let err as NSError {
                    debugPrint("could not save to CoreData. Error: \(err)")
        }
    }

}
