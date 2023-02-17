//
//  DetailViewController.swift
//  Notes
//
//  Created by Timur Mannapov on 2023/2/17.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.adjustsFontForContentSizeCategory = true
        textView.textColor = UIColor.white
        textView.text = "..."
        textView.textAlignment = .left
        textView.isScrollEnabled = true
        textView.backgroundColor = UIColor.clear
        textView.dataDetectorTypes = .all
        return textView
    }()
    
    var note: Note? = nil
    let placeholder = "Tap here to type..."
    
    var originalContent: String = ""
    var shouldDelete: Bool = false
    
    var doneButton: UIBarButtonItem? = nil
    var trashButton: UIBarButtonItem? = nil
    
    let noteDataSource: NoteDataSource
    
    init(noteDataSource: NoteDataSource) {
        self.noteDataSource = noteDataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0)
        
        navigationItem.title = "Editing..."
        navigationItem.largeTitleDisplayMode = .never
        
        if note == nil {
            note = Note(content: "")
        }
        originalContent = note?.content ?? ""
        
        view.addSubview(textView)
        
        setTextViewConstraints()
        
        textView.text = note?.content.isEmpty == true ? placeholder : note?.content
        textView.delegate = self
        
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
    
        if let trashButton = trashButton {
            navigationItem.rightBarButtonItems = [trashButton]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if textView.text.isEmpty || shouldDelete {
            note?.delete(dataSource: noteDataSource)
        } else {
            // Ensure that the content of the note has changed.
            guard originalContent != note?.content else {
                return
            }
            note?.write(dataSource: self.noteDataSource)
        }
    }
    
    private func setTextViewConstraints() {
        
        let textViewContstraints = [
            textView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            textView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
            textView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(textViewContstraints)
    }
    
    @objc func didTapDone() {
        textView.endEditing(true)
    }
    
    @objc func didTapDelete() {
        shouldDelete = true
        
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
        
        navigationItem.hidesBackButton = true
        
        if let trashButton = trashButton, let doneButton = doneButton {
            navigationItem.rightBarButtonItems = [doneButton, trashButton]
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
        }
        
        note?.content = textView.text
        
        if let trashButton = trashButton {
            navigationItem.rightBarButtonItems = [trashButton]
        }
        
        navigationItem.hidesBackButton = false
    }
}
