//
//  ViewController.swift
//  Segmentwithcoredata
//
//  Created by admin on 12/12/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var jokearr:[JokeModel]=[]
    var userarr:[UserModel]=[]

    @IBOutlet weak var tablevc2: UITableView!
    @IBOutlet weak var tablevc1: UITableView!
    
    @IBOutlet weak var tbsegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        callJokeApi()
        reloadUI()
       
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
        return tbsegment.selectedSegmentIndex == 0 ? jokearr.count:userarr.count
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
                   
               case 1:
                   guard indexPath.row < userarr.count else {
                       print("Index out of bounds for CatArr")
                       return cell
                   }
                   let user = userarr[indexPath.row]
                   
                   cell.lbl1.text=user.name
                   cell.lbl2.text=user.email
                   
               default:
                   break
               }
               
               return cell
    }

    @IBAction func changesegment(_ sender: Any) {
        print("current selected segment: \(tbsegment.selectedSegmentIndex)")
              reloadUI()
    
    }
}

