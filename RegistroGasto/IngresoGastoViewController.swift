//
//  IngresoGastoViewController.swift
//  SmartStudent
//
//  Created by user266277 on 12/19/24.
//

import UIKit
import CoreData

class IngresoGastoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var lugarTxt: UITextField!
    
    @IBOutlet weak var descripcionTxt: UITextField!
    
    @IBOutlet weak var montoTxt: UITextField!
    
    @IBOutlet weak var categoriaTxt: UITextField!
    
    @IBOutlet weak var metododepagoTxt: UITextField!
    
    let categorias = ["Comida", "Transporte", "Estudios", "Ocio", "Otros"]
    let metododepago = ["Efectivo", "Tarjeta", "Yape", "Plin"]

    var categoriaPicker = UIPickerView()
    var metododepagoPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configurar los pickers
        categoriaPicker.delegate = self
        categoriaPicker.dataSource = self
        metododepagoPicker.delegate = self
        metododepagoPicker.dataSource = self

        // Configurar el teclado numérico para montoTxt
        montoTxt.keyboardType = .decimalPad
        montoTxt.delegate = self

        // Agregar una barra de herramientas para cerrar el picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        toolbar.setItems([doneButton], animated: false)

        // Asignar pickers y toolbar a los text fields
        categoriaTxt.inputView = categoriaPicker
        categoriaTxt.inputAccessoryView = toolbar

        metododepagoTxt.inputView = metododepagoPicker
        metododepagoTxt.inputAccessoryView = toolbar

        montoTxt.inputAccessoryView = toolbar
    }

    // MARK: - Cerrar Picker
        @objc func donePicker() {
            view.endEditing(true)  // Cerrar el picker
        }

        // MARK: - UITextFieldDelegate
        func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField == categoriaTxt {
                textField.inputView = categoriaPicker
            } else if textField == metododepagoTxt {
                textField.inputView = metododepagoPicker
            } else {
                textField.inputView = nil
            }
        }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Validación para montoTxt: permitir solo números y un punto decimal
        if textField == montoTxt {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
            let characterSet = CharacterSet(charactersIn: string)

            if !allowedCharacters.isSuperset(of: characterSet) {
                return false
            }

            // Permitir solo un punto decimal
            if string == "." && textField.text?.contains(".") == true {
                return false
            }
        }
        return true
    }

    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoriaPicker {
            return categorias.count
        } else {
            return metododepago.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoriaPicker {
            return categorias[row]
        } else {
            return metododepago[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoriaPicker {
            categoriaTxt.text = categorias[row]
        } else {
            metododepagoTxt.text = metododepago[row]
        }
    }

    // MARK: - Acción del botón Registrar
    @IBAction func registrar(_ sender: Any) {
        let lugar = lugarTxt.text ?? ""
         let descripcion = descripcionTxt.text ?? ""
         let monto = Decimal(string: montoTxt.text ?? "") ?? 0.0
         let categoria = categoriaTxt.text ?? ""
         let metododepago = metododepagoTxt.text ?? ""
         let fecha = Date()
         let hora = getCurrentTime()

         registerCoreData(lugar: lugar, descripcion: descripcion, monto: monto, categoria: categoria, metododepago: metododepago, fecha: fecha, hora: hora)
         clearFields()
        
    }


    // MARK: - Función para obtener la hora actual
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }

    // MARK: - Limpiar campos
    func clearFields() {
        lugarTxt.text = ""
        descripcionTxt.text = ""
        montoTxt.text = ""
        categoriaTxt.text = ""
        metododepagoTxt.text = ""
    }

    // MARK: - Registrar en Core Data
    func registerCoreData(lugar: String, descripcion: String, monto: Decimal, categoria: String, metododepago: String, fecha: Date, hora: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Validar campos vacíos
        guard !lugar.isEmpty, !descripcion.isEmpty, monto != 0.0, !categoria.isEmpty, !metododepago.isEmpty else {
            showAlert(title: "Error", message: "Por favor, completa todos los campos.")
            return
        }

        let nuevoGasto = GastoEntity(context: context)
        nuevoGasto.lugar = lugar
        nuevoGasto.descripcion = descripcion
        nuevoGasto.monto = monto as NSDecimalNumber
        nuevoGasto.categoria = categoria
        nuevoGasto.metododepago = metododepago
        nuevoGasto.fecha = fecha
        nuevoGasto.hora = hora

        do {
            try context.save()
            showAlert(title: "Éxito", message: "Gasto registrado correctamente.")
        } catch let error as NSError {
            showAlert(title: "Error", message: "No se pudo guardar el gasto: \(error.localizedDescription)")
        }
    }

    // MARK: - Mostrar alerta
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

