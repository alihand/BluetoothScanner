//
//  ViewController.swift
//  BluetoothScanner
//
//  Created by Ali Han DEMIR on 1.07.2024.
//

import UIKit
import BluetoothScannerLibrary

class BluetoothScannerViewController: UIViewController {
    
    lazy var viewModel: BluetoothScannerViewModel = {
        let viewModel = BluetoothScannerViewModel(bluetoothScanner: BluetoothScanner(), delegate: self)
        return viewModel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(DeviceCell.self, forCellReuseIdentifier: "DeviceCell")
        return tableView
    }()
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.placeholder = "Search devices..."
        return searchBar
    }()
    private lazy var scanButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Scanning", for: .normal)
        button.addTarget(self, action: #selector(toggleScan), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    private lazy var noDevicesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No devices found"
        label.textColor = .gray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @objc private func toggleScan() {
        viewModel.toggleScan()
        scanButton.setTitle(viewModel.getScanButtonTitle(), for: .normal)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
//MARK: - BluetoothScannerViewModelDelegate
extension BluetoothScannerViewController: BluetoothScannerViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func showNoDevicesFoundMessage(_ show: Bool) {
        noDevicesLabel.isHidden = !show
    }
}
//MARK: - UITableViewDataSource, UITableViewDelegate
extension BluetoothScannerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as? DeviceCell else {
              return UITableViewCell()
        }
        let device = viewModel.filteredDevices[indexPath.row]
        cell.configure(with: device)
        return cell
    }
}
//MARK: - UISearchBarDelegate
extension BluetoothScannerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        viewModel.filterDevices(with: searchText)
    }
}
//MARK: -UI setup
extension BluetoothScannerViewController {
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(scanButton)
        view.addSubview(noDevicesLabel)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scanButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            scanButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            
            noDevicesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDevicesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        addTapGestureToDismissKeyboard()
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
}
