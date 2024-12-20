//
//  DetalleGastoViewController.swift
//  SmartStudent
//
//  Created by user266277 on 12/19/24.
//

import UIKit

class DetalleGastoViewController: UIViewController,EditarGastoViewControllerDelegate  {

    
    @IBOutlet weak var fechaLabel: UILabel!
    
    @IBOutlet weak var horaLabel: UILabel!
    
    @IBOutlet weak var lugarLabel: UILabel!
    
    @IBOutlet weak var categoriaLabel: UILabel!
    
    @IBOutlet weak var descripcionLabel: UILabel!
    
    @IBOutlet weak var montoLabel: UILabel!
    
    @IBOutlet weak var metododepagoLabel: UILabel!
    
    // Gasto seleccionado que se recibirá al hacer la transición
       var gasto: GastoEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarDetalles()
    }
    
    
    @IBAction func eliminarGasto(_ sender: Any) {
        mostrarAlertaEliminar()
    }

    @IBAction func editarGasto(_ sender: Any) {
    }
    

    // MARK: - Mostrar Detalles del Gasto
       func mostrarDetalles() {
           guard let gasto = gasto else { return }

           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd/MM/yyyy"

           fechaLabel.text = "Fecha: \(dateFormatter.string(from: gasto.fecha ?? Date()))"
           horaLabel.text = "Hora: \(gasto.hora ?? "")"
           lugarLabel.text = "Lugar: \(gasto.lugar ?? "")"
           categoriaLabel.text = "Categoría: \(gasto.categoria ?? "")"
           descripcionLabel.text = "Descripción: \(gasto.descripcion ?? "")"
           montoLabel.text = "Monto: \(gasto.monto?.stringValue ?? "0.0")"
           metododepagoLabel.text = "Método de Pago: \(gasto.metododepago ?? "")"
       }

    
       // MARK: - Alerta de Confirmación para Eliminar
       func mostrarAlertaEliminar() {
           let alert = UIAlertController(title: "Eliminar Gasto",
                                         message: "Este gasto se eliminará permanentemente.",
                                         preferredStyle: .alert)
           
           let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
           alert.addAction(cancelarAction)
           
           let eliminarAction = UIAlertAction(title: "Eliminar", style: .destructive) { [weak self] _ in
               self?.eliminarGastoCoreData()
           }
           alert.addAction(eliminarAction)
           
           self.present(alert, animated: true, completion: nil)
       }
       
       // MARK: - Eliminar Gasto de Core Data
       func eliminarGastoCoreData() {
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           
           if let gastoAEliminar = gasto {
               context.delete(gastoAEliminar)
               do {
                   try context.save()
                   navigationController?.popViewController(animated: true)
               } catch let error as NSError {
                   print("Error al eliminar el gasto: \(error.localizedDescription)")
               }
           }
           
       }
    
    
    // MARK: - Delegate Method
        func gastoActualizado(_ gasto: GastoEntity) {
            self.gasto = gasto
            mostrarDetalles()
        }
        
        // MARK: - Preparar Segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "EditarGastoSegue",
               let destinoVC = segue.destination as? EditarGastoViewController {
                destinoVC.gasto = gasto
                destinoVC.delegate = self  // Asignar el delegado
            }
        }
    
}
