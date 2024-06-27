//
//  BasketDetail.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import UIKit
import RxSwift
import Alamofire
import Kingfisher
import UserNotifications

class BasketDetail: UIViewController {
    
   
    @IBOutlet weak var basketTableView: UITableView!
    var basketList = [BasketFood]()
    var viewModel = BasketDetailViewModel()
    var food:Food?
    var permissionControl = false
    @IBOutlet weak var basketTotalPrice: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self  
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler:{ granted, error in
            self.permissionControl = granted
        })
      

        
        basketTableView.delegate = self
        basketTableView.dataSource = self
        
        viewModel.frepo.getBasket(kullanici_adi: "abdulkadir_aktar")
        
        _ = viewModel.basketList.subscribe(onNext: { list in
            
            self.basketList = list
            //self.foodList = list
            DispatchQueue.main.async {
                self.basketTableView.reloadData()
            }
           
            
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.frepo.getBasket(kullanici_adi: "abdulkadir_aktar")
        if basketList.count == 0 {
            basketTotalPrice.text = String(0)
        }
    }
    
   
    @IBAction func basketConfirmButton(_ sender: Any) {
        
        if permissionControl {
            let content = UNMutableNotificationContent()
            content.title = "HUNGRY"
            content.subtitle = "SİPARİŞ DETAYI"
            content.body = "Siparişiniz onaylandı."
            content.badge = 1
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
       
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            
    }
}

extension BasketDetail : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound,.badge])
    }
    
   
}


extension BasketDetail : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell") as! BasketCell
        let basket = basketList[indexPath.row]
        
        cell.labelFood.text = basket.yemek_adi
        cell.labelPrice.text = "₺ \(basket.yemek_fiyat!)"
        cell.labelPiece.text = basket.yemek_siparis_adet!
        if let foodPrice = basket.yemek_fiyat, let foodPiece = basket.yemek_siparis_adet, let fp = Int(foodPrice), let pi = Int(foodPiece) {
            let result = fp * pi
            cell.labelFoodPrice.text = "₺\(result)"
        }
        let total = basketList.reduce(0) {
            $0 + Int(Double($1.toplam_fiyat ?? "0") ?? 0)
        }
        basketTotalPrice.text = "₺\(total)"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(basket.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.imageViewFood.kf.setImage(with: url)
            }
        }
        
        
        return cell
    }
    
    
 
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil"){contextualAction,view,bool in
            let food = self.basketList[indexPath.row]
            
            let alert = UIAlertController(title: "Silme İşlemi", message: "\(food.yemek_adi!) silinsin mi?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(cancelAction)
            
            let yesAction = UIAlertAction(title: "Evet", style: .destructive){ action in
                self.viewModel.frepo.delete(sepet_yemek_id: Int(food.sepet_yemek_id!)!, kullanici_adi: "abdulkadir_aktar")
                self.basketList.remove(at: indexPath.row)
                self.basketTableView.deleteRows(at: [indexPath], with: .automatic)
                let total = self.basketList.reduce(0) {
                        $0 + Int(Double($1.toplam_fiyat ?? "0") ?? 0)
                    }
                    self.basketTotalPrice.text = "₺\(total)"
               
            }
            alert.addAction(yesAction)
            
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
