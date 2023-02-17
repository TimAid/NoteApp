//
//  ViewController.swift
//  Notes
//
//  Created by Timur Mannapov on 2023/2/17.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Oultets
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var searchController = UISearchController()
    
    var notes: [Note] {
        return noteDataSource.notes
    }
    var filteredNotes: [Note] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    let noteDataSource: NoteDataSource
    
    init(noteDataSource: NoteDataSource) {
        self.noteDataSource = noteDataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
        
        setupNavBar()
        searchController.searchResultsUpdater = self
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(notesDidUpdate), name: .noteDataChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.frame
    }
    //MARK: - Methods
    private func setupNavBar() {
        navigationItem.searchController = searchController
        
        navigationItem.titleView = searchController.searchBar;
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredNotes = notes.filter { (note: Note) -> Bool in
            return note.content.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    //MARK: - objc Methods
    @objc func didTapCompose() {

        navigationController?.pushViewController(DetailViewController(noteDataSource: noteDataSource), animated: true)
    }

    @objc func notesDidUpdate() {
        print ("NotesViewController: Note Data Changed")
        self.tableView.reloadData()
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotes.count
        }
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as? NoteCell else { return UITableViewCell() }
        
        if isFiltering {
            cell.note = filteredNotes[indexPath.row]
        } else {
            cell.note = self.notes[indexPath.row]
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(noteDataSource: noteDataSource)
        if isFiltering {
            detailVC.note = filteredNotes[indexPath.row]
        } else {
            detailVC.note = notes[indexPath.row]
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
