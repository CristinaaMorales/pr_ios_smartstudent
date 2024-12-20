//
//  GastoTableViewCell.swift
//  SmartStudent
//
//  Created by user266277 on 12/19/24.
//

import UIKit

class GastoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var categoriaLabel: UILabel!
    
    @IBOutlet weak var montoLabel: UILabel!
    
    @IBOutlet weak var descripcionLabel: UILabel!
    
    @IBOutlet weak var horaLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
