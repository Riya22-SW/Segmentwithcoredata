//
//  UpdateVC.swift
//  Segmentwithcoredata
//
//  Created by admin on 13/12/24.
//

import UIKit
import CoreData

class UpdateVC: UIViewController {

    var getjoke:JokeModel!
    
    @IBOutlet weak var typetxt: UITextField!
    @IBOutlet weak var idtxt: UITextField!
    
    @IBOutlet weak var punchlinetxt: UITextField!
    @IBOutlet weak var setuptxt: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setdata()
        
    }
    
    func setdata()
    {
        idtxt.text=String(getjoke.id)
        typetxt.text=getjoke.type
        setuptxt.text=getjoke.setup
        punchlinetxt.text=getjoke.punchline
        
    }
    
    //update coredata in tablevc2
    
    func updatecd(atId:Int32,updatejoke:JokeModel){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managecontext = delegate.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Jokes")
        
        fetchrequest.predicate = NSPredicate(format: "id = %d", atId)
        
        do {
            let rawdata = try managecontext.fetch(fetchrequest)
            
            let updatedata = rawdata[0] as! NSManagedObject
            updatedata.setValue(updatejoke.id, forKey: "id")
            updatedata.setValue(updatejoke.type, forKey: "type")
            updatedata.setValue(updatejoke.setup, forKey: "setup")
            updatedata.setValue(updatejoke.punchline, forKey: "punchline")
            
            try managecontext.save()
            
        } catch let err as NSError {
            debugPrint("Something went wrong while updating \(err)")
        }
    }
    
    @IBAction func updatebtn(_ sender: Any) {
        
        var upid = idtxt.text!
        var uptype = typetxt.text!
        var upsetup = setuptxt.text!
        var uppunchline = punchlinetxt.text!
        
        updatecd(atId: Int32(getjoke.id), updatejoke: JokeModel(id: getjoke.id, type: uptype, setup: upsetup, punchline: uppunchline))
    }
    
    

}
