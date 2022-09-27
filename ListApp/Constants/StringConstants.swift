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
    let nameFieldPlaceholder = "Please enter car's name."
    let modelFieldPlaceholder = "Please enter car's model."
    let priceFieldPlaceholder = "Please enter car's price."
}
