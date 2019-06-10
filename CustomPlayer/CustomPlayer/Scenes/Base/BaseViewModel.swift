//
//  BaseViewModel.swift
//  CustomPlayer
//
//  Created by mac on 6/16/19.
//  Copyright © 2019 sunasterisk. All rights reserved.
//

enum BaseResult {
    case success
    case failure(error: Error?)
}

protocol BaseViewModel: class {
    var count: Int { get }
    subscript (index: Int) -> String? { get }
    func bind(didChange: @escaping (BaseResult) -> Void)
    func reloadData()
}
