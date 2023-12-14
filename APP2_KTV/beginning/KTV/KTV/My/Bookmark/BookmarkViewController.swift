//
//  BookmarkViewController.swift
//  KTV
//
//  Created by Choi Oliver on 2023/11/14.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet weak var tableView: UITableView!
    private var bookmarkViewModel: BookmarkViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView()
        self.bindViewModel()
        
        self.bookmarkViewModel.requestData()
    }
    
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(
            UINib(nibName: BookmarkCell.identifier, bundle: nil),
            forCellReuseIdentifier: BookmarkCell.identifier
        )
    }

    private func bindViewModel() {
        self.bookmarkViewModel.dataChanged = { [weak self] in
            guard let self else { return }
            
            self.tableView.reloadData()
        }
    }
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.bookmarkViewModel.bookmark?.channels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        BookmarkCell.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkCell.identifier, for: indexPath)
        
        if let cell = cell as? BookmarkCell,
           let data = self.bookmarkViewModel.bookmark?.channels[indexPath.row] {
            cell.setData(data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("bookmark selected at \(indexPath.row)")
    }
}
