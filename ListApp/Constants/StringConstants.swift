import Foundation

class StringContants {
    static var instance: StringContants = {
        let instance = StringContants()
        return instance
    }()

    private init() { }

    let addCarAlertTitle = "Add Car"
    let addButton = "Add"
    let cancelButton = "Cancel"
    let okButton = "OK"
    let errorAlertTitle = "Error Message"
    let errorAlertMessage = "You must enter all parameters. \n Please, try again!"
    let fieldsPlaceHolder = [
        "Please enter car's name.",
        "Please enter car's model.",
        "Please enter car's price."
    ]
    let deleteAllAlertTitle = "Delete all cars from list"
    let deleteAllAlertMessage = "The all cars will be deleted from list. \n Are you sure to continue?"
    let deleteEmptyAlertMessage = "Your car list is empty! \n Please, add car in your list."
    let delete = "Delete"
    let deleteAlertTitle = "Delete Car"
    let deleteAlertMessage = "The car will be deleted from list. \n Are you sure to continue?"
    let edit = "Edit"
    let editAlertTitle = "Edit Car"
}
