//
//  GastoViewController.swift
//  SmartStudent
//
//  Created by user266277 on 12/19/24.
//

import UIKit

class GastoViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var gastosTableView: UITableView!
    
    var gastoList: [GastoEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gastosTableView.dataSource = self
        listCoreData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listCoreData() 
    }

    
    // MARK: - UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return gastoList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "gastoCell", for: indexPath) as! GastoTableViewCell
            let gasto = gastoList[indexPath.row]
            
            cell.horaLabel.text = "Hora: \(gasto.hora ?? "")"
            cell.categoriaLabel.text = "Categoría: \(gasto.categoria ?? "")"
            cell.descripcionLabel.text = "Descripción: \(gasto.descripcion ?? "")"
            cell.montoLabel.text = "Monto: \(gasto.monto?.stringValue ?? "0.0")"
            
            return cell
        }
        

        // MARK: - Core Data Fetch
        
        func listCoreData() {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            do {
                let gastos = try context.fetch(GastoEntity.fetchRequest())
                self.gastoList = gastos
                print("Gastos cargados: \(gastoList)")
            } catch let error as NSError {
                print("Error al cargar los gastos: \(error.localizedDescription)")
            }
            
            self.gastosTableView.reloadData()
        }
        
    // MARK: - UITableViewDelegate
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "DetalleGastoSegue", sender: indexPath)
       }
    
    // MARK: - Preparar Segue
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "DetalleGastoSegue",
               let destinoVC = segue.destination as? DetalleGastoViewController,
               let indexPath = gastosTableView.indexPathForSelectedRow {
                
                let selectedGasto = gastoList[indexPath.row]
                
                // Refrescar el gasto si es un fault
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                context.refresh(selectedGasto, mergeChanges: true)
                
                destinoVC.gasto = selectedGasto
            }
        }
    

}
