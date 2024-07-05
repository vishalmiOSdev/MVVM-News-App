//
//  TableViewExtension.swift
//  MindPause
//
//  Created by Vishal Manhas on 26/04/24.
//

import Foundation
import UIKit

extension UITableView{
    func registerNIBs(identifiers:[String]){
        self.tableFooterView = UIView()
        for idds in identifiers{
            self.register(UINib.init(nibName: idds, bundle: nil), forCellReuseIdentifier: idds)
        }
    }
}
