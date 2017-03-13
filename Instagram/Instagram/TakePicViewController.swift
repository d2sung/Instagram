//
//  TakePicViewController.swift
//  Instagram
//
//  Created by Daniel Sung on 3/13/17.
//  Copyright © 2017 Daniel Sung. All rights reserved.
//

import UIKit
import Parse
class TakePicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.isHidden = true
        captionTextField.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
       
        imageView.image = originalImage
        button.isHidden = true
        captionTextField.isHidden = false
        button.setTitle("", for: .normal)
        submitButton.isHidden = false
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onButton(_ sender: Any) {
        
        let vc = UIImagePickerController()
        
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    

    @IBAction func onSubmit(_ sender: Any) {
        let image = resize(image: self.imageView.image!, newSize: CGSize(width: 600, height: 600))
        let caption = captionTextField.text
        
        Post.postUserImage(image: image, withCaption: caption) { (success: Bool, error: Error?) in
            
            if success {
                print("photo posted")
                self.imageView.image = nil;
                self.captionTextField.text = ""
                self.captionTextField.isHidden = true
                self.button.setTitle("Tap to choose picture", for: .normal)
                self.button.isHidden = false;
                self.submitButton.isHidden = true
                
                self.tabBarController?.selectedIndex = 0
                
            } else {
                print(error?.localizedDescription ?? 0)
            }
        }
        }
    
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
