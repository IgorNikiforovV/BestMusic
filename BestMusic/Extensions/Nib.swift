//
//  Nib.swift
//  BestMusic
//
//  Created by Игорь Никифоров on 03.06.2021.
//

import UIKit

extension UIView {

    class func loadFromNib<T: UIView>() -> T {
        Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

}
