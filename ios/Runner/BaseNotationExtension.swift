
//
//  NotationExtension.swift
//  Runner
//
//  Created by Charlotte on 2025/10/31.
//
import UIKit

public class BaseNotationExtension: UIViewController {
    //: public override func viewDidLoad() {
    override public func viewDidLoad() {
        //: super.viewDidLoad()
        super.viewDidLoad()
        //: let bgImgV = UIImageView()
        let bgImgV = UIImageView()
        //: bgImgV.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        bgImgV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        //: bgImgV.image = UIImage(named: "LaunchImage")
        bgImgV.image = UIImage(named: "LaunchImage")
        //: view.addSubview(bgImgV)
        view.addSubview(bgImgV)
    }
}
