//
//  ViewController.swift
//  Segmentwithcoredata
//
//  Created by admin on 12/12/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var jokearr:[JokeModel]=[]
    var jokearr1:[JokeModel]=[]
    
    var selectedjoke:JokeModel!
    
   

    @IBOutlet weak var tablevc2: UITableView!
    @IBOutlet weak var tablevc1: UITableView!
    
    @IBOutlet weak var tbsegment: UISegmentedControl!
    
    
    override func viewWillAppear(_ animated: Bool) {
        readfromcoredata()
        tablevc2.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        callJokeApi()
        reloadUI()
       
    }

    @IBAction func addbtn(_ sender: Any) {
        performSegue(withIdentifier: "GoToNext", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToUpdate"{
            if let update = segue.destination as? UpdateVC{
                update.getjoke=selectedjoke
            }
        }
    }
    
    
    func callJokeApi(){
        ApiManager().fetchJokes{ result in
            switch result {
                
            case.success(let data):
                self.jokearr.append(contentsOf: data)
                print(self.jokearr)
                self.tablevc1.reloadData()
                
                
            case.failure(let failure):
                debugPrint("something went wrong in calling API")
                
            }
        }
    }
    
    func reloadUI() {
            DispatchQueue.main.async {
                
                if self.tbsegment.selectedSegmentIndex == 0 {
                    
                    self.tablevc1.isHidden = false
                    self.tablevc2.isHidden = true
                    self.tablevc1.reloadData()

                } else if self.tbsegment.selectedSegmentIndex == 1 {
                    
                    
                    self.tablevc2.isHidden = false
                    self.tablevc1.isHidden = true
                    self.readfromcoredata()
                    self.tablevc2 .reloadData()

                }
            }
        }
    
    func setup()
    {
        tablevc1.dataSource=self
        tablevc1.delegate=self
        tablevc1.register(UINib(nibName: "Jokecell", bundle: nil), forCellReuseIdentifier: "Jokecell")
        
        tablevc2.dataSource=self
        tablevc2.delegate=self
        tablevc2.register(UINib(nibName: "Jokecell", bundle: nil), forCellReuseIdentifier: "Jokecell")
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbsegment.selectedSegmentIndex == 0 ? jokearr.count:jokearr1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Jokecell", for: indexPath) as? Jokecell else {
                       return UITableViewCell()
               }
                   
               let currSeg = tbsegment.selectedSegmentIndex
               
               switch currSeg {
               case 0:
                   guard indexPath.row < jokearr.count else {
                       print("Index out of bounds for JokeArr")
                       return cell
                   }
                   let joke = jokearr[indexPath.row]
                   cell.lbl1.text=String(joke.id)
                   cell.lbl2.text=joke.type
                   cell.lbl3.text=joke.setup
                   cell.lbl4.text=joke.punchline
                   
               case 1:
                   guard indexPath.row < jokearr1.count else {
                       print("Index out of bounds for jokearr")
                       return cell
                   }
                   let joke = jokearr1[indexPath.row]
                   cell.lbl1.text=String(joke.id)
                   cell.lbl2.text=joke.type
                   cell.lbl3.text=joke.setup
                   cell.lbl4.text=joke.punchline
                   
                   
               default:
                   break
               }
               
               return cell
    }

    @IBAction func changesegment(_ sender: Any) {
        print("current selected segment: \(tbsegment.selectedSegmentIndex)")
              reloadUI()
    
    }
    
//    jokearr(api) data add to core data
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let joke = jokearr[indexPath.row]
        DetailVC().addcoredata(jokeobject: JokeModel(id: joke.id, type: joke.type, setup: joke.setup, punchline: joke.punchline))
        
    }
    
    
//    Swipe delete
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == tablevc2{
            let delete=UIContextualAction(style: .destructive, title: "delete"){action,source,completion in
                
                let jokeToDelete = self.jokearr1[indexPath.row]
                self.deletecd(Jokes: jokeToDelete)
                self.jokearr1.remove(at: indexPath.row)
                self.tablevc2.reloadData()
            }
            let configure=UISwipeActionsConfiguration(actions: [delete])
            configure.performsFirstActionWithFullSwipe=false
            return configure
        }else {
            
            let configure=UISwipeActionsConfiguration(actions: [])
            configure.performsFirstActionWithFullSwipe=false
            return configure
        }
    }
    
    //Swipe update
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == tablevc2{
            let update = UIContextualAction(style: .normal, title: "update"){(action,view,completionHandler)in
                self.selectedjoke = self.jokearr1[indexPath.row]
                self.performSegue(withIdentifier: "GoToUpdate", sender: self)
                
                completionHandler(true)
            }
            update.backgroundColor = .systemBlue
            
            let updateAction=UISwipeActionsConfiguration(actions: [update])
            return updateAction
        }else{
            let updateAction=UISwipeActionsConfiguration(actions: [])
            return updateAction
        }
    }
    
    
    
    
    
    
    
    
    
    
//    Read user data in tablevc2
    func readfromcoredata(){
        guard let delegate=UIApplication.shared.delegate as? AppDelegate else
        {return }
        
        let managecontext=delegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Jokes")
        
        do{
            let res = try managecontext.fetch(fetchRequest)
            debugPrint("fetch from CD sucessfully")
            jokearr1 = []

            for data in res as! [NSManagedObject]{
                
                let jid=data.value(forKey: "id") as! Int32
                let jtype=data.value(forKey: "type") as! String
                let jsetup=data.value(forKey: "setup") as! String
                let jpunchline=data.value(forKey: "punchline") as! String
                jokearr1.append(JokeModel(id:Int(jid), type: jtype, setup: jsetup, punchline: jpunchline))
            }
            
        }
        catch let err as NSError {
            debugPrint("could not save to CoreData. Error: \(err)")
        }
        
    }
    
    
//    delete coredata from tablevc2
    
    func deletecd(Jokes:JokeModel){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return  }
        
        let managecontext=delegate.persistentContainer.viewContext
        let fetchrequest=NSFetchRequest<NSFetchRequestResult>(entityName: "Jokes")
        
        fetchrequest.predicate=NSPredicate(format: "id = %d", Jokes.id)
        
        
        do {
            let fetchres=try managecontext.fetch(fetchrequest)
            let objToDelete=fetchres[0] as! NSManagedObject
            managecontext.delete(objToDelete)
            
            try managecontext.save()
            print("user deleted successfully")
            
        } catch let err as NSError {
            print("Somthing went wrong while deleting \(err)")
        }
        
    }
}

