//
//  ResultsTableViewController.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 04/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit

class ResultsTableViewController: UITableViewController {
    private let viewModel: ResultsViewModel
    
    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
    
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.rowHeight = 100
        self.tableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: ResultsTableViewCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(for: self.viewModel)
    }
    
    private func updateView(for vm: ResultsViewModel) {
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.itemViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = viewModel.itemViewModels[indexPath.row]
        let vc = ResultDetailViewController(viewModel: ResultDetailViewModel(text: cellVM.text ?? "<no text read>", imageURL: cellVM.imageURL))
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        present(vc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ResultsTableViewCell = tableView.dequeueReusableCell(withIdentifier: ResultsTableViewCell.reuseIdentifier, for: indexPath) as? ResultsTableViewCell else { return UITableViewCell() }
        
        cell.setup(with: self.viewModel.itemViewModels[indexPath.row])
        
        return cell
    }
}
