//
//  RemoveCardPositionInforming.swift
//  Set-game_stanford
//
//  Created by Олег Черных on 03/03/2020.
//  Copyright © 2020 Олег Черных. All rights reserved.
//

import Foundation
import UIKit

protocol RemovedCardPositionInforming {
    var removedCardPosition: CGRect { get }
    var view: UIView! { get set }
}
