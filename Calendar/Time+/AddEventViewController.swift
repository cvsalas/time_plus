//
//  AddEventViewController.swift
//  Time+
//
//  Created by user165037 on 2/3/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, DatePickerWithDoneDelegate {
    
    fileprivate enum ButtonPressed{
        case Start, End
    }
    
    fileprivate enum VisualKind {
        case Primary, Secondary
    }
    
    @IBAction func iconSelectionButton(_ sender: Any) {
        performSegue(withIdentifier: "toIconsView", sender: self)
    }

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var repeateSegment: UISegmentedControl!
    @IBOutlet weak var defaultIconsCollectionView: UICollectionView!
    
    
    var primaryVisual : EventsDataBaseStringEntry!
    var secondaryVisual : EventsDataBaseStringEntry!
    
    var startTime : Date!
    var endTime : Date!
    fileprivate var buttonPressed : ButtonPressed!
    fileprivate var visualSelected : VisualKind = .Primary
    
    var currentDay: Date!
    let dateFormatter = DateFormatter()
    
    var imagePickerController : UIImagePickerController!
    var imageTaken: UIImage!
    
    let datePickerTag = 0xDEADBEEF
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        defaultIconsCollectionView.dataSource = self
        defaultIconsCollectionView.delegate = self
        //setRepeatControlAppearance()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        if let start = startTime, let end = endTime{
            EventsDatabase.sharedInstance.enterEvent(startTime: start, endTime: end, date: currentDay, iconPath: primaryVisual.entry, imagePath: "")
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func setRepeatControlAppearance(){
        let size = CGSize(width: 117.333,height: 72)
        UIGraphicsBeginImageContext(size)
        defer {UIGraphicsEndImageContext()}
        UIColor.green.setFill()
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: size.height/2).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        
        repeateSegment.setBackgroundImage(image, for: .normal, barMetrics: .default)
    }
    
    @IBAction func endTimeButtonPressed(_ sender: Any) {
        displayPickere()
        buttonPressed = .End
    }
    @IBAction func startTimeButtonPressed(_ sender: Any) {
        displayPickere()
        buttonPressed = .Start
    }
    
    func displayPickere(){
        self.view.viewWithTag(datePickerTag)?.removeFromSuperview()

        let height = self.view.frame.size.height/2
        let datePicker = DatePickerWithDone(frame: CGRect(x: 0, y: self.view.frame.size.height - height, width: self.view.frame.size.width, height: height))
        
        datePicker.datePickerMode = .time
        datePicker.delegate = self
        datePicker.tag = datePickerTag
        self.view.addSubview(datePicker)
    }
    
    func doneTapped(picker: DatePickerWithDone) {
        setTimes(picker: picker)
        picker.removeFromSuperview()
    }
    
    func pickerDisappeared(picker: DatePickerWithDone) {
        setTimes(picker: picker)
    }
    
    func setTimes(picker: DatePickerWithDone){
        if(buttonPressed == .Start){
            self.startTime = picker.date
            self.startTimeLabel.text = self.dateFormatter.string(from: self.startTime)
        }
        else{
            self.endTime = picker.date
            self.endTimeLabel.text = self.dateFormatter.string(from: self.endTime)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toIconsView"){
            if(visualSelected == .Primary){
                let iconView = segue.destination as! IconsCollectionViewController
                iconView.iconSelected = {iconCell in self.primaryVisual = Icon(name: iconCell.nameLabel.text!, code: UnicodeScalar(iconCell.iconLabel.text!)!) }
            }
        }
    }
    
    
    @IBAction func ellipsisPressed(_ sender: Any) {
        self.visualSelected = .Primary
        performSegue(withIdentifier: "toIconsView", sender: self)
    }
}


extension AddEventViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    //CAMERA CODE FROM HERE ON DOWN -- @RAF & TEAM

       @IBAction func cameraButton(_ sender: Any) {
           imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.sourceType = .camera
           
           // If you were to create a custom overlay, need new view from a xib?
           //imagePickerController.showsCameraControls = false
           
          // present(imagePickerController, animated: true, completion: nil)
           performSegue(withIdentifier: "toIconsView", sender: self)
       }
       
       //Called after taking a picture
       internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           imagePickerController.dismiss(animated: true, completion: nil)
           imageTaken = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
           saveImage(imageName: "test.png")
       }
       
       func saveImage(imageName: String){
          //create an instance of the FileManager
          let fileManager = FileManager.default
          //get the image path
          let imagePath = (NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
           print(imagePath)
          //get the image we took with camera
           let image = imageTaken
          //get the PNG data for this image
           let data = image!.pngData()
          //store it in the document directory
           fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
       }
}


extension AddEventViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "defaultIconsFooter", for: indexPath)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         // #warning Incomplete implementation, return the number of sections
         return 1
     }
   
}
