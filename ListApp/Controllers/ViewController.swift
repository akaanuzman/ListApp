
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cars = CarModel.cars
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell",
            for: indexPath)
        cell.textLabel?.text = "\(cars[indexPath.row].name) \(cars[indexPath.row].model)"
        return cell
    }

    @IBAction func addCar(_ sender: Any) {

        let alertController = UIAlertController(title: "Add Car",
            message: nil,
            preferredStyle: .alert)
        let addButton = UIAlertAction(title: "Add", style: .default) {
            _ in
            let nameText = alertController.textFields?.first?.text!
            let modelText = alertController.textFields?[1].text!
            let priceText = alertController.textFields?.last?.text!
            if nameText != "" && modelText != "" && priceText != "" {
                self.cars.append(CarModel(name: nameText!,
                    model: modelText!, price: Double(priceText!)!))
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Error Message",
                    message: "You must enter all parameters. \n Please, try again!",
                    preferredStyle: .alert)
                let addButton = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(addButton)
                self.present(alertController, animated: true)
            }
        }

        let cancelButton = UIAlertAction(title: "Cancel",
            style: .destructive)

        alertController.addAction(addButton)
        alertController.addAction(cancelButton)

        addTextFieldFromAlert(alertController: alertController,
            placeHolder: "Please enter car name.")
        addTextFieldFromAlert(alertController: alertController,
            placeHolder: "Please enter car's model.")
        addTextFieldFromAlert(alertController: alertController,
            placeHolder: "Please enter car's price.",
            keyBoardType: UIKeyboardType.decimalPad)

        present(alertController, animated: true)


    }

    // TextField is added by this method in alertController
    func addTextFieldFromAlert(alertController: UIAlertController,
        placeHolder: String, keyBoardType: UIKeyboardType? = nil) {
        alertController.addTextField { (textField) -> Void in
            textField.attributedPlaceholder = NSAttributedString(
                string: placeHolder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
            )
            // You can change keyboardType dynamically.
            if let keyBoardType {
                textField.keyboardType = keyBoardType
            }
        }
    }

}

