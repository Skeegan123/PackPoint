//
//  MainContentView.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/29/23.
//

import SwiftUI

extension UIImage {
    func image(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

struct MainContentView: View {
    
    struct CustomTabView: UIViewControllerRepresentable {
        
        func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
            let scale = newHeight / image.size.height
            let newWidth = image.size.width * scale
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage!.withRenderingMode(.alwaysOriginal)
        }
        
        class CustomTabBarItem: UITabBarItem {
            override var selectedImage: UIImage? {
                get {
                    return super.selectedImage
                }
                set {
                    if let newValue = newValue {
                        let image = newValue.withRenderingMode(.alwaysOriginal)
                        super.selectedImage = isOn ? image : image.image(alpha: 0.7)
                    } else {
                        super.selectedImage = nil
                    }
                }
            }

            var isOn: Bool = false {
                didSet {
                    if let image = image {
                        self.image = isOn ? image.image(alpha: 1) : image.image(alpha: 0.7)
                    }
                }
            }
        }

        
        func makeUIViewController(context: Context) -> UITabBarController {
            let tabBarController = UITabBarController()
            let view1 = UIHostingController(rootView: MainView())
            let view2 = UIHostingController(rootView: CreatePointView())
            let view3 = UIHostingController(rootView: ProfileView())
            
            var tab1Image = UIImage()
            var tab2Image = UIImage()
            var tab3Image = UIImage()
            
            if let image = UIImage(named: "MainTab") {
                let resizedImage = resizeImage(image: image, newHeight: 30) // set your desired width
                tab1Image = resizedImage
            }

            if let image = UIImage(named: "PostTab") {
                let resizedImage = resizeImage(image: image, newHeight: 30) // set your desired width
                tab2Image = resizedImage
            }

            if let image = UIImage(named: "ProfileTab") {
                let resizedImage = resizeImage(image: image, newHeight: 30) // set your desired width
                tab3Image = resizedImage
            }
            
            view1.tabBarItem = CustomTabBarItem(title: "", image: tab1Image, tag: 0)
            view2.tabBarItem = CustomTabBarItem(title: "", image: tab2Image, tag: 1)
            view3.tabBarItem = CustomTabBarItem(title: "", image: tab3Image, tag: 2)
            
            tabBarController.viewControllers = [view1, view2, view3]
            tabBarController.tabBar.isTranslucent = false
            tabBarController.tabBar.barTintColor = .white
            tabBarController.tabBar.backgroundColor = .white
            
            view1.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            view2.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            view3.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

            // Add top border shadow
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: tabBarController.tabBar.frame.width, height: 1)
            layer.backgroundColor = UIColor.lightGray.cgColor
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            layer.shadowOpacity = 0.1
            layer.shadowRadius = 3.0
            tabBarController.tabBar.layer.addSublayer(layer)
            
            return tabBarController
        }

        
        func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
            for item in uiViewController.tabBar.items as! [CustomTabBarItem] {
                item.isOn = item.tag == uiViewController.selectedIndex
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.white)
                .ignoresSafeArea()
            CustomTabView()
        }
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
