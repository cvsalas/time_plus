//
//  AddEventViewController.swift
//  Time+
//
//  Created by user165037 on 2/3/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//
//TODO: Maintainince storage issue, user keeps fetching from gallery will blow up
// Data managment issue TBD

import UIKit

class AddEventViewController: UIViewController, DatePickerWithDoneDelegate {
    
    fileprivate enum ButtonPressed{
        case Start, End
    }
    
    fileprivate enum VisualKind {
        case Primary, Secondary
    }
    
    @IBAction func iconSelectionButton(_ sender: Any) {
        self.visualSelected = .Primary
        performSegue(withIdentifier: "toIconsView", sender: self)
    }
    
    @IBOutlet weak var ButtonItem: UIBarButtonItem!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var repeateSegment: UISegmentedControl!
    @IBOutlet weak var defaultIconsCollectionView: UICollectionView!
    @IBOutlet weak var bottomActionBar: UISegmentedControl!
    @IBOutlet weak var endButtonOutlet: UIButton!
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var miscButton: UIButton!
    
    
    @IBAction func iconButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "toIconsView", sender: self)
    }
    @IBOutlet weak var iconButtonOutlet: UIButton!
    @IBAction func cameraButtonAction(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBOutlet weak var cameraButtonOutlet: UIButton!
    @IBAction func galleryButtonAction(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBOutlet weak var galleryButtonAction: UIButton!
    @IBOutlet var viewOutlet: UIView!
    
    var primaryVisual : EventsDataBaseStringEntry!
    var secondaryVisual : EventsDataBaseStringEntry!
    
    var startTime : Date!
    var endTime : Date!
    fileprivate var buttonPressed : ButtonPressed!
    fileprivate var visualSelected : VisualKind = .Primary
    
    var currentDay: Date!
    let dateFormatter = DateFormatter()
        
    var imagePickerController : UIImagePickerController!
    
    let datePickerTag = 0xDEADBEEF
    
    let primaryIcons = MainIconsDataBase.sharedInstance.get()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        defaultIconsCollectionView.dataSource = self
        defaultIconsCollectionView.delegate = self
        ButtonItem.isEnabled = false
        ButtonItem.tintColor = UIColor.clear
        setupButtonIcons()
        viewOutlet.backgroundColor = UIColor(red:0.81, green:0.89, blue:0.79, alpha:1.0)
        miscButton.setTitleColor(.white, for: .normal)
        miscButton.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 40)
        miscButton.setTitle("\u{f141}", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkFieldComplete()
    }
    
    func setupButtonIcons(){
        startButtonOutlet.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 60)!
        startButtonOutlet.setTitle("\u{f144}", for: .normal)
        endButtonOutlet.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 60)!
        endButtonOutlet.setTitle("\u{f28d}", for: .normal)
        iconButtonOutlet.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 40)!
        iconButtonOutlet.setTitle("\u{f141}", for: .normal)
        cameraButtonOutlet.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 40)!
        cameraButtonOutlet.setTitle("\u{f030}", for: .normal)
        galleryButtonAction.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 40)!
        galleryButtonAction.setTitle("\u{f03e}", for: .normal)
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        if let start = startTime, let end = endTime{ //add checks here
            EventsDatabase.sharedInstance.enterEvent(startTime: start, endTime: end, date: currentDay, iconPath: primaryVisual.entry, imagePath: secondaryVisual.entry)
        }
        navigationController?.popViewController(animated: true)
    }
    
    //Add support for checking if primary icon selected!
    func checkFieldComplete(){
        if(startTime != nil && endTime != nil && primaryVisual != nil){
            if(endTime > startTime){
                ButtonItem.isEnabled = true
                ButtonItem.tintColor = UIColor.systemBlue
            }
        }
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
    
    func setTitlesActionBar(actionBar: UISegmentedControl){
        let stringAttributes = [
            NSAttributedString.Key.font : UIFont(name: "FontAwesome5Free-Solid",
                                                 size: 17.0)!]
        actionBar.setTitleTextAttributes(stringAttributes, for: .normal)
        actionBar.setTitle("f05e", forSegmentAt: 0)
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
        //Broken, TODO!
        //datePicker.minuteInterval = 30
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
        checkFieldComplete()
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
    
    //Takes the selected icon from the IconsView controller and declare's its components to iconView var
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toIconsView"){
            if(visualSelected == .Primary){
                let iconView = segue.destination as! IconsCollectionViewController
                iconView.iconSelected = {iconCell in self.primaryVisual = Icon(name: iconCell.nameLabel.text!, code: UnicodeScalar(iconCell.iconLabel.text!)!) }
            }
        }
    }
}


extension AddEventViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    //CAMERA CODE FROM HERE ON DOWN -- @RAF & TEAM
    
    func currentTimeInMilliSeconds()-> Int {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //Called after taking a picture
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        let imageTaken = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imagePath = String(currentTimeInMilliSeconds())
        secondaryVisual = ImagePath(path: imagePath)
        saveImage(imageName: imagePath, imageTaken: imageTaken!)
    }
    
    func saveImage(imageName: String, imageTaken: UIImage){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        let fullPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        //get the image we took with camera
        let image = resizeImage(image: imageTaken, targetSize: CGSize(width: 200, height: 200))
        //get the PNG data for this image
        let data = image.pngData()
        //store it in the document directory
        fileManager.createFile(atPath: fullPath as String, contents: data, attributes: nil)
        
        if fileManager.fileExists(atPath: fullPath){
            print("IT GOT STORED!")
        } else{
            print("Panic! No Image!")
        }
    }
}

extension AddEventViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return primaryIcons.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
        let iconCode = String(UnicodeScalar(Int(primaryIcons[indexPath.row][MainIconsDataBase.columns.icon]))!)
        let color =  UIColor(rgba: primaryIcons[indexPath.row][MainIconsDataBase.columns.color])
        cell.iconLabel.text = iconCode
        cell.backgroundColor = color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
        var code: UInt64 = 0
        Scanner(string: cell.iconLabel.text!).scanHexInt64(&code)
        let convertedString = convertName(iconCode: code)
        secondaryVisual = Icon(name: convertedString, code: UnicodeScalar(Int(code))!)
        self.visualSelected = .Primary
    }
    
    func convertName(iconCode: UInt64) -> String{
        switch iconCode{
        case 0xf486:
            return "medicine"
        case 0xf70c:
            return "excercise"
        case 0xf0f1:
            return "doctor"
        case 0xf26c:
            return "TV"
        case 0xf500:
            return "social"
        case 0xf2e7:
            return "eating"
        default:
            return "None"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 3
        let cellsAbove: CGFloat = 2
        let spaceBetweenCells: CGFloat = 1
        let width = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        let height = (collectionView.bounds.height - (cellsAbove - 1) * spaceBetweenCells) / cellsAbove
        return CGSize(width: width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
}
