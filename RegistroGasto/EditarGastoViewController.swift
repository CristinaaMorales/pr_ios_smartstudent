//
//  EditarGastoViewController.swift
//  SmartStudent
//
//  Created by user266277 on 12/20/24.
//

import UIKit

// MARK: - Protocolo para Actualizar Datos
protocol EditarGastoViewControllerDelegate: AnyObject {
    func gastoActualizado(_ gasto: GastoEntity)
}

class EditarGastoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    
    @IBOutlet weak var lugarTxt: UITextField!
    
    @IBOutlet weak var categoriaTxt: UITextField!
    
    @IBOutlet weak var descripcionTxt: UITextField!
    
    @IBOutlet weak var montoTxt: UITextField!
    
    @IBOutlet weak var metododepagoTxt: UITextField!
    
    var gasto: GastoEntity?
    weak var delegate: EditarGastoViewControllerDelegate?
    
    let categorias = ["Comida", "Transporte", "Estudios", "Ocio", "Otros"]
    let metodosdepago = ["Efectivo", "Tarjeta", "Yape", "Plin"]

    var categoriaPicker = UIPickerView()
    var metododepagoPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurarPickers()
        cargarDatos()
    }
    
    // MARK: - Configurar Pickers
    func configurarPickers() {
        categoriaPicker.delegate = self
        categoriaPicker.dataSource = self
        metododepagoPicker.delegate = self
        metododepagoPicker.dataSource = self
        
        categoriaTxt.inputView = categoriaPicker
        metododepagoTxt.inputView = metododepagoPicker
        
        // Agregar Toolbar con botón "Done" para cerrar pickers
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        toolbar.setItems([doneButton], animated: false)
        
        categoriaTxt.inputAccessoryView = toolbar
        metododepagoTxt.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        view.endEditing(true)  // Cerrar el picker
    }
    
    // MARK: - Cargar Datos del Gasto Seleccionado
    func cargarDatos() {
        guard let gasto = gasto else { return }
        
        lugarTxt.text = gasto.lugar
        categoriaTxt.text = gasto.categoria
        descripcionTxt.text = gasto.descripcion
        montoTxt.text = gasto.monto?.stringValue
        metododepagoTxt.text = gasto.metododepago
    }
    
    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoriaPicker {
            return categorias.count
        } else {
            return metodosdepago.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoriaPicker {
            return categorias[row]
        } else {
            return metodosdepago[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoriaPicker {
            categoriaTxt.text = categorias[row]
        } else {
            metododepagoTxt.text = metodosdepago[row]
        }
    }
    
    // MARK: - Guardar Cambios en Core Data
    @IBAction func guardarCambios(_ sender: Any) {
        guard let gasto = gasto else { return }
          
          // Actualizar los valores del gasto
          gasto.lugar = lugarTxt.text ?? ""
          gasto.categoria = categoriaTxt.text ?? ""
          gasto.descripcion = descripcionTxt.text ?? ""
          gasto.monto = Decimal(string: montoTxt.text ?? "0") as NSDecimalNumber?
          gasto.metododepago = metododepagoTxt.text ?? ""
          
          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          
          do {
              try context.save()
              delegate?.gastoActualizado(gasto) // Notificar al delegado que el gasto fue actualizado
              mostrarAlertaExito()
          } catch let error as NSError {
              print("Error al guardar los cambios: \(error.localizedDescription)")
          }
    }
    
    // MARK: - Mostrar Alerta de Éxito
    func mostrarAlertaExito() {
        let alert = UIAlertController(title: "Éxito", message: "Gasto actualizado correctamente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    

}
