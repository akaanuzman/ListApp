import UIKit
import CoreData


class ViewController: UIViewController {
    private var items: [CarModelItem] = []
    private let stringConstants = StringContants.instance
    private var alertController = UIAlertController()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetch()
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
                self.addCar()
            },
            isUseTextField: true,
            textFieldLenght: stringConstants.fieldsPlaceHolder.count,
            textFieldsPlaceholder: stringConstants.fieldsPlaceHolder
        )
    }

    /// [If you wanna add a car in list, you must use this method.]
    private func addCar() {
        let nameText = alertController.textFields?.first?.text!
        let modelText = alertController.textFields?[1].text!
        let priceText = alertController.textFields?.last?.text!
        if nameText != "" && modelText != "" && priceText != "" {
            let entityName = "CarItem"
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(
                forEntityName: entityName,
                in: managedObjectContext!
            )
            let carItem = CarModelItem(
                entity: entity!,
                insertInto: managedObjectContext
            )
            carItem.setValue(UUID(), forKey: "id")
            carItem.setValue(nameText, forKey: "name")
            carItem.setValue(modelText, forKey: "model")
            carItem.setValue(Double(priceText!), forKey: "price")
            onDatabaseSave(db: managedObjectContext)
        } else {
            presentErrorAlert()
        }

    }

    /// [Error Alert is created by this method for add a car in list.]
    private func presentErrorAlert() {
        presentAlert(title: stringConstants.errorAlertTitle,
            message: stringConstants.errorAlertMessage,
            cancelButtonTitle: stringConstants.okButton)
    }

    /// [The all cars are deleted from list with alert.]
    private func presentDeleteAllAlert() {
        if items.isEmpty {
            presentAlert(
                title: stringConstants.errorAlertTitle,
                message: stringConstants.deleteEmptyAlertMessage,
                cancelButtonTitle: stringConstants.okButton
            )
        } else {
            presentAlert(
                title: stringConstants.deleteAllAlertTitle,
                message: stringConstants.deleteAllAlertMessage,
                cancelButtonTitle: stringConstants.cancelButton,
                defaultButtonTitle: stringConstants.okButton,
                defaultButtonHandler: {
                    _ in
                    self.deleteAllItems()
                }
            )
        }
    }

    /// [The all cars are deleted from list by this method.]
    private func deleteAllItems() {
        let managedObjectContext = self.appDelegate?.persistentContainer.viewContext
        for item in self.items {
            managedObjectContext?.delete(item)
        }
        onDatabaseSave(db: managedObjectContext)
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
        textFieldsText: [String]? = nil,
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
                    if let textFieldsText {
                        addTextFieldFromAlert(
                            alertController: alertController,
                            placeHolder: textFieldsPlaceholder[i],
                            keyBoardType: textFieldKeyBoardType,
                            fieldText: textFieldsText[i]
                        )
                    }
                    else {
                        addTextFieldFromAlert(
                            alertController: alertController,
                            placeHolder: textFieldsPlaceholder[i],
                            keyBoardType: textFieldKeyBoardType
                        )
                    }

                }
            }
        }

        present(alertController, animated: true)
    }



    /// [TextField is added by this method in alertController]
    private func addTextFieldFromAlert(
        alertController: UIAlertController,
        placeHolder: String,
        keyBoardType: UIKeyboardType? = nil,
        fieldText: String? = nil
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

            /// [You can change textfield's text dynamically.]
            if let fieldText {
                textField.text = fieldText
            }
        }
    }

    /// [The changes are saved on database by this method.]
    private func onDatabaseSave(db: NSManagedObjectContext?) {
        do {
            try db?.save()
            self.fetch()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    /// [The data are fetched on database by this method]
    private func fetch() {
        let managedObjectContext = self.appDelegate?.persistentContainer.viewContext
        let fetchRequest = CarModelItem.fetchRequest()
        do {
            items = try managedObjectContext!.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = "defaultCell"
        let cell = tableView.dequeueReusableCell(
            withIdentifier: defaultCell,
            for: indexPath
        )
        cell.textLabel?.text = "\(items[indexPath.row].name ?? "NULL_NAME") \(items[indexPath.row].model ?? "NULL_MODEL") \(items[indexPath.row].price)$"
        return cell
    }


    func tableView(_ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal, title: stringConstants.delete)
        {
            _, _, _ in
            self.deleteCar(indexPath: indexPath)

        }
        deleteAction.backgroundColor = .systemRed

        let editAction = UIContextualAction(style: .normal, title: stringConstants.edit) {
            _, _, _ in
            self.editCar(indexPath: indexPath)
        }

        editAction.backgroundColor = .systemOrange

        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return config
    }

    /// [Car is deleted from list by this method.]
    private func deleteCar(indexPath: IndexPath) {
        let constants = self.stringConstants
        self.presentAlert(
            title: constants.deleteAlertTitle,
            message: constants.deleteAlertMessage,
            cancelButtonTitle: constants.cancelButton,
            defaultButtonTitle: constants.okButton) {
            _ in
            let managedObjectContext = self.appDelegate?.persistentContainer.viewContext
            managedObjectContext?.delete(self.items[indexPath.row])
            self.onDatabaseSave(db: managedObjectContext)
        }
    }

    /// [Car is edited from list by this method.]
    func editCar(indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        var nameText = item.name
        var modelText = item.model
        var priceText = String(item.price)
        self.presentAlert(
            title: self.stringConstants.editAlertTitle,
            message: nil,
            cancelButtonTitle: self.stringConstants.cancelButton,
            defaultButtonTitle: self.stringConstants.okButton,
            defaultButtonHandler: {
                _ in
                nameText = self.alertController.textFields?.first?.text!
                modelText = self.alertController.textFields?[1].text!
                priceText = (self.alertController.textFields?.last?.text!)!
                if nameText != "" || modelText != "" || priceText != "" {
                    let managedObjectContext = self.appDelegate?.persistentContainer.viewContext
                    if nameText != "" {
                        item.name = nameText!
                        item.setValue(nameText, forKey: "name")
                    }
                    if modelText != "" {
                        item.setValue(modelText, forKey: "model")
                    }
                    if priceText != "" {
                        item.setValue(Double(priceText) ?? Double(0), forKey: "price")
                    }
                    self.onDatabaseSave(db: managedObjectContext)
                } else {
                    self.presentErrorAlert()
                }

            },
            isUseTextField: true,
            textFieldLenght: self.stringConstants.fieldsPlaceHolder.count,
            textFieldsPlaceholder: self.stringConstants.fieldsPlaceHolder,
            textFieldsText: [nameText!, modelText!, priceText]
        )
    }
}

