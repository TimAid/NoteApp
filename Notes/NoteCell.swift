//
//  TableViewCell.swift
//  Notes
//
//  Created by Timur Mannapov on 2023/2/17.
//

import UIKit

class NoteCell: UITableViewCell {
    
    static let identifier = "cell"
    
    //MARK: - subviews
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.numberOfLines = 0
        return label
    }()

    let customBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 64/255, green: 64/255, blue: 64/255, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    var note: Note? = nil {
        didSet {
            guard let note = note else { return }
            
            titleLabel.text = String(note.content.split(separator: "\n")[0])
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            subtitleLabel.text = "Измененно в \(formatter.string(from: note.lastEdited))"
        }
    }
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.fontSizeDidChange()
        NotificationCenter.default.addObserver(self, selector: #selector(fontSizeDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        contentView.addSubview(customBackground)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        
        setConstraints()
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setConstraints
    private func setConstraints() {
        let backgroundViewConstraints = [
            customBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            customBackground.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            customBackground.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            customBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ]
        
        let titleLabelConstaints = [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        
        let subtitleConstraints = [
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(backgroundViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstaints)
        NSLayoutConstraint.activate(subtitleConstraints)
    }
    
    //MARK: - fontSizeDidChange
    @objc func fontSizeDidChange() {
        if UIApplication.shared.preferredContentSizeCategory.isAccessibilityCategory {
            self.titleLabel.numberOfLines = 3
        } else {
            self.titleLabel.numberOfLines = 1
        }
    }
}
