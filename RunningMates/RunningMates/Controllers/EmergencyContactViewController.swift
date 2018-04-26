//
//  EmergencyContactViewController.swift
//  RunningMates
//
//  Created by Divya Kalidindi on 4/25/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
//based on this tutorial: https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ImplementNavigation.html#//apple_ref/doc/uid/TP40015214-CH16-SW1
import UIKit
import ContactsUI

class EmergencyContactViewController: UIViewController,UINavigationControllerDelegate, CNContactPickerDelegate {
    
    @IBOutlet weak var FirstName: UITextField!
    
    @IBOutlet weak var LastName: UITextField!

    @IBOutlet weak var phoneNum: UITextField!
    
    @IBOutlet weak var addToContacts: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var nameToSave = ""
    var contact: EmergencyContact?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Handle the text field’s user input through delegate callbacks.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
//            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
//        let name = nameTextField.text ?? ""
//        let photo = photoImageView.image
//        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        contact = EmergencyContact(FirstName: self.FirstName.text, LastName: self.LastName.text, phoneNumber: self.phoneNum.text)
        print("now save this:", contact)
    }
    
    //https://stackoverflow.com/questions/25218399/how-to-select-a-contact-with-abpeoplepickernavigationcontroller-in-swift
    @IBAction func didTapPickFromContacts(_ sender: Any) {
        let peoplePicker = CNContactPickerViewController()
        
        peoplePicker.delegate = self
        
        self.present(peoplePicker, animated: true, completion: nil)
    }
    
    //https://stackoverflow.com/questions/25218399/how-to-select-a-contact-with-abpeoplepickernavigationcontroller-in-swift
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
        print("nvm")
    }
    
    
  
    //https://stackoverflow.com/questions/25218399/how-to-select-a-contact-with-abpeoplepickernavigationcontroller-in-swift
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print("here")

            picker.dismiss(animated: true, completion: nil)
        
            //See if the contact has multiple phone numbers
            if contact.phoneNumbers.count > 1 {
                
                //If so we need the user to select which phone number we want them to use
                let multiplePhoneNumbersAlert = UIAlertController(title: "Which one?", message: "This contact has multiple phone numbers, which one did you want use?", preferredStyle: UIAlertControllerStyle.alert)
                
                //Loop through all the phone numbers that we got back
                for number in contact.phoneNumbers {
                    
                    //Each object in the phone numbers array has a value property that is a CNPhoneNumber object, Make sure we can get that
                    let actualNumber = number.value as CNPhoneNumber
                    
                    //Get the label for the phone number
                    var phoneNumberLabel = number.label
                    
                    //Strip off all the extra crap that comes through in that label
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "")
                    
                    //Create a title for the action for the UIAlertVC that we display to the user to pick phone numbers
                    let actionTitle = phoneNumberLabel! + " - " + actualNumber.stringValue
                    
                    //Create the alert action
                    let numberAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: { (theAction) -> Void in
                        
                        //See if we can get A frist name
                        if contact.givenName == "" {
                            
                            //If Not check for a last name
                            if contact.familyName == "" {
                                //If no last name set name to Unknown Name
                                self.nameToSave = "Unknown Name"
                            }else{
                                self.nameToSave = contact.familyName
                            }
                            
                        } else {
                            
                            self.nameToSave = contact.givenName
                            
                        }
                        
            
                        
                        //Do what you need to do with your new contact information here!
                        //Get the string value of the phone number like this:
                        //self.numeroADiscar = actualNumber.stringValue
                        
                        self.FirstName.text = contact.givenName
                        self.LastName.text = contact.familyName
                       //https://stackoverflow.com/questions/36343312/how-to-get-a-cncontact-phone-numbers-as-string-in-swift
                        self.phoneNum.text = (actualNumber as! CNPhoneNumber).value(forKey: "digits") as! String
                      
                        self.FirstName.textColor = UIColor.black
                        self.LastName.textColor = UIColor.black
                        self.phoneNum.textColor = UIColor.black
                        print(contact.givenName, contact.familyName, self.nameToSave)
                        
                    })
                    
                    //Add the action to the AlertController
                    multiplePhoneNumbersAlert.addAction(numberAction)
                    
                }
                
                //Add a cancel action
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (theAction) -> Void in
                    //Cancel action completion
                })
                
                //Add the cancel action
                multiplePhoneNumbersAlert.addAction(cancelAction)
                
                //Present the ALert controller
                self.present(multiplePhoneNumbersAlert, animated: true, completion: nil)
                
            } else {
                
                //Make sure we have at least one phone number
                if contact.phoneNumbers.count > 0 {
                    
                    //If so get the CNPhoneNumber object from the first item in the array of phone numbers
                    let actualNumber = (contact.phoneNumbers.first?.value)! as CNPhoneNumber
                    
                    //Get the label of the phone number
                    var phoneNumberLabel = contact.phoneNumbers.first!.label
                    
                    //Strip out the stuff you don't need
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "")
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "")
                    
                    //Create an empty string for the contacts name
                    self.nameToSave = ""
                    //See if we can get A frist name
                    if contact.givenName == "" {
                        //If Not check for a last name
                        if contact.familyName == "" {
                            //If no last name set name to Unknown Name
                            self.nameToSave = "Unknown Name"
                        }else{
                            self.nameToSave = contact.familyName
                        }
                    } else {
                        nameToSave = contact.givenName
                    }
                    
                    
                
        
                    
                    //Do what you need to do with your new contact information here!
                    //Get the string value of the phone number like this:
                    print(nameToSave, "name to save")
                    print(contact.givenName, "given name")
                    print(contact.familyName, "family name")
                    
                    self.FirstName.text = contact.givenName
                    self.LastName.text = contact.familyName
                    //https://stackoverflow.com/questions/36343312/how-to-get-a-cncontact-phone-numbers-as-string-in-swift
                    self.phoneNum.text = (actualNumber as! CNPhoneNumber).value(forKey: "digits") as! String
                    
                    
                    self.FirstName.textColor = UIColor.black
                    self.LastName.textColor = UIColor.black
                    self.phoneNum.textColor = UIColor.black
                //    self.numeroADiscar = actualNumber.stringValue
                    
                } else {
                    
                    //If there are no phone numbers associated with the contact I call a custom funciton I wrote that lets me display an alert Controller to the user
                    let alert = UIAlertController(title: "Missing info", message: "You have no phone numbers associated with this contact", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    
}

