//
//  ViewController.swift
//  DropDownMenuTutorial
//
//  Created by Stephen Dowless on 12/22/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import UIKit

private let reuseIdentifier = "DropDownCell"

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func blue() -> UIColor {
        return UIColor.rgb(red: 17, green: 154, blue: 237)
    }
    
    static func purple() -> UIColor {
        return UIColor.rgb(red: 98, green: 0, blue: 238)
    }
    
    static func pink() -> UIColor {
        return UIColor.rgb(red: 255, green: 148, blue: 194)
    }
    
    static func teal() -> UIColor {
        return UIColor.rgb(red: 3, green: 218, blue: 197)
    }
}

enum Colors: Int, CaseIterable {
    case Purple
    case Pink
    case Teal
    
    var description: String {
        switch self {
        case .Purple: return "Purple"
        case .Pink: return "Pink"
        case .Teal: return "Teal"
        }
    }
    
    var color: UIColor {
        switch self {
        case .Purple: return UIColor.purple()
        case .Pink: return UIColor.pink()
        case .Teal: return UIColor.teal()
        }
    }
}

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var showMenu = false
    
    let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        return view
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        view.addSubview(colorView)
        colorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        colorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 32).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    // MARK: - Selectors
    
    @objc func handleDropDown() {
        
        showMenu = !showMenu
        
        var indexPaths = [IndexPath]()
        
        Colors.allCases.forEach { (color) in
            let indexPath = IndexPath(row: color.rawValue, section: 0)
            indexPaths.append(indexPath)
        }
        
        if showMenu {
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    // MARK: - Helper Fucntions

    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        
        tableView.register(DropDownCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("Select Color", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleDropDown), for: .touchUpInside)
        button.backgroundColor = UIColor.blue()
        
        return button
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showMenu ? Colors.allCases.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DropDownCell
        cell.titleLabel.text = Colors(rawValue: indexPath.row)?.description
        cell.backgroundColor = Colors(rawValue: indexPath.row)?.color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let color = Colors(rawValue: indexPath.row) else { return }
        colorView.backgroundColor = color.color
    }
}

