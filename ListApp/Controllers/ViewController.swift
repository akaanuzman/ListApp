import UIKit

class ViewController: UIViewController {

    private var cars = CarModel.cars
    private let stringConstants = StringContants.instance
    private var alertController = UIAlertController()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction private func addCar(_ sender: Any) {
        presentAddAlert()
    }

    @IBAction private func deleteAllCar(_ sender: Any) {
        presentDeleteAllAlert()
    }

    /// [A new car is added by this method in car list]
    private func presentAddAlert() {
        presentAlert(
            title: stringConstants.addCarAlertTitle,
            message: nil,
            cancelButtonTitle: stringConstants.cancelButton,
            defaultButtonTitle: stringConstants.addButton,
            defaultButtonHandler: {
                _ in
                let nameText = self.alertController.textFields?.first?.text!
                let modelText = self.alertController.textFields?[1].text!
                let priceText = self.alertController.textFields?.last?.text!
                if nameText != "" && modelText != "" && priceText != "" {
                    self.cars.append(
                        CarModel(
                            name: nameText!,
                            model: modelText!,
                            price: Double(priceText!) ?? Double(0)
                        )
                    )
                    self.tableView.reloadData()
                } else {
                    self.presentErrorAlert()
                }
            },
            isUseTextField: true,
            textFieldLenght: stringConstants.fieldsPlaceHolder.count,
            textFieldsPlaceholder: stringConstants.fieldsPlaceHolder
        )
    }

    /// [The all cars are deleted from list.]
    private func presentDeleteAllAlert() {
        if cars.isEmpty {
            presentAlert(
                title: stringConstants.errorAlertTitle,
                message: stringConstants.deleteEmptyAlertMessage,
                cancelButtonTitle: stringConstants.okButton
            )
        } else {
            presentAlert(
                title: stringConstants.deleteAlertTitle,
                message: stringConstants.deleteAlertMessage,
                cancelButtonTitle: stringConstants.cancelButton,
                defaultButtonTitle: stringConstants.okButton,
                defaultButtonHandler: {
                    _ in
                    self.cars.removeAll()
                    self.tableView.reloadData()
                }
            )
        }
    }

    /// [Alert is created by this method optionally.]
    private func presentAlert(
        title: String?,
        message: String?,
        alertStyle: UIAlertController.Style = .alert,
        cancelButtonTitle: String?,
        defaultButtonTitle: String? = nil,
        defaultButtonHandler: ((UIAlertAction) -> Void)? = nil,
        isUseTextField: Bool = false,
        textFieldLenght: Int = 1,
        textFieldsPlaceholder: [String]? = nil,
        textFieldKeyBoardType: UIKeyboardType? = nil
    ) {
        /// [Alert is created.]
        alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: alertStyle
        )

        /// [Cancel button action is created in alertController.]
        let cancelButton = UIAlertAction(
            title: cancelButtonTitle,
            style: .destructive
        )
        alertController.addAction(cancelButton)

        /// [Default button action is created by optional in alertController.]
        if let defaultButtonTitle {
            let defaultButton = UIAlertAction(
                title: defaultButtonTitle,
                style: .default,
                handler: defaultButtonHandler
            )
            alertController.addAction(defaultButton)
        }

        /// [If you wanna add textfield in alert you must set "isUseTextField" parameter to true]
        if isUseTextField {
            for i in 0..<textFieldLenght {
                /// [If you wanna add textfields in alert you must use "textFieldLenght" parameter]
                if let textFieldsPlaceholder {
                    addTextFieldFromAlert(
                        alertController: alertController,
                        placeHolder: textFieldsPlaceholder[i],
                        keyBoardType: textFieldKeyBoardType
                    )
                }
            }
        }

        present(alertController, animated: true)
    }

    /// [Error Alert is created by this method.]
    private func presentErrorAlert() {
        presentAlert(title: stringConstants.errorAlertTitle,
            message: stringConstants.errorAlertMessage,
            cancelButtonTitle: stringConstants.okButton)
    }

    /// [TextField is added by this method in alertController]
    private func addTextFieldFromAlert(
        alertController: UIAlertController,
        placeHolder: String,
        keyBoardType: UIKeyboardType? = nil
    ) {
        alertController.addTextField {
            (textField) -> Void in
            textField.attributedPlaceholder = NSAttributedString(
                string: placeHolder,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.5)]
            )
            /// [You can change keyboardType dynamically.]
            if let keyBoardType {
                textField.keyboardType = keyBoardType
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = "defaultCell"
        let cell = tableView.dequeueReusableCell(
            withIdentifier: defaultCell,
            for: indexPath
        )
        cell.textLabel?.text = CarModel.getNameAndModel(carModel: cars[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal, title: "Delete")
        { _, _, _ in
            self.presentAlert(
                title: "Delete Car",
                message: "The car will be deleted from list. \n Are you sure to continue?",
                cancelButtonTitle: self.stringConstants.cancelButton,
                defaultButtonTitle: self.stringConstants.okButton) { _ in
                self.cars.remove(at: indexPath.row)
                tableView.reloadData()
            }
        }
        deleteAction.backgroundColor = .systemRed

        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.presentAlert(
                title: "Edit Car",
                message: nil,
                cancelButtonTitle: self.stringConstants.cancelButton,
                defaultButtonTitle: self.stringConstants.okButton,
                defaultButtonHandler: {
                    _ in
                    let nameText = self.alertController.textFields?.first?.text!
                    let modelText = self.alertController.textFields?[1].text!
                    let priceText = self.alertController.textFields?.last?.text!

                },
                isUseTextField: true,
                textFieldLenght: self.stringConstants.fieldsPlaceHolder.count,
                textFieldsPlaceholder: self.stringConstants.fieldsPlaceHolder
            )
        }
        
        editAction.backgroundColor = .systemOrange

        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return config
    }
}

