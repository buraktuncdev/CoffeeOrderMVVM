//
//  AdOrderViewController.swift
//  MvvmCoffeeOrderApp
//
//  Created by Burak Tunc on 18.07.2020.
//  Copyright © 2020 Burak Tunç. All rights reserved.
//

import UIKit


protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var addCoffeeOrderViewModel = AddCoffeeOrderViewModel()

    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    
    var delegate: AddCoffeeOrderDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
         
        self.ordersTableView.delegate = self
        self.ordersTableView.dataSource = self
    }
    
  private func setupUI(){
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: self.addCoffeeOrderViewModel.sizes)
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.coffeeSizesSegmentedControl.selectedSegmentTintColor = #colorLiteral(red: 0.9719236493, green: 0.4874661565, blue: 0.4658593535, alpha: 1)
        self.view.addSubview(self.coffeeSizesSegmentedControl)
        
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.ordersTableView.bottomAnchor, constant: 20).isActive = true
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addCoffeeOrderViewModel.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.addCoffeeOrderViewModel.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ordersTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        ordersTableView.cellForRow(at: indexPath)?.accessoryType = .none
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        
        let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
        
        guard let indexPath = self.ordersTableView.indexPathForSelectedRow else {
            fatalError("Error in selecting coffee!")
        }
        
        self.addCoffeeOrderViewModel.name = name
        self.addCoffeeOrderViewModel.email = email
        self.addCoffeeOrderViewModel.selectedSize = selectedSize
        self.addCoffeeOrderViewModel.selectedType = self.addCoffeeOrderViewModel.types[indexPath.row]
        
        Webservice().load(resource: Order.create(vm: self.addCoffeeOrderViewModel)){ result in
            
            switch result {
                case .success(let order):
                    
                    if let order = order, let delegate = self.delegate {
                        DispatchQueue.main.async {
                            delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                        }
                    }
                case .failure(let error):
                    print(error)
            }
            
        }
        
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControllerDidClose(controller: self)
        }
    }
    
}


