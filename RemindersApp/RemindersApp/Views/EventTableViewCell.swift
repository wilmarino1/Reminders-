//
//  EventTableViewCell.swift
//  RemindersApp
//
//  Created on $(DATE).
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let colorIndicator = UIView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let locationLabel = UILabel()
    private let notesLabel = UILabel()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Color Indicator
        colorIndicator.layer.cornerRadius = 4
        colorIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorIndicator.widthAnchor.constraint(equalToConstant: 8),
            colorIndicator.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Title Label
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.numberOfLines = 0
        
        // Time Label
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = .secondaryLabel
        
        // Location Label
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textColor = .systemBlue
        locationLabel.numberOfLines = 0
        
        // Notes Label
        notesLabel.font = UIFont.systemFont(ofSize: 14)
        notesLabel.textColor = .secondaryLabel
        notesLabel.numberOfLines = 2
        
        // Add subviews
        [colorIndicator, titleLabel, timeLabel, locationLabel, notesLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            colorIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: colorIndicator.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            locationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            notesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            notesLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            notesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            notesLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    func configure(with event: CalendarEvent) {
        titleLabel.text = event.title
        colorIndicator.backgroundColor = event.displayColor
        
        // Time formatting
        let formatter = DateFormatter()
        if event.isAllDay {
            timeLabel.text = "All day"
        } else {
            formatter.timeStyle = .short
            let startTime = formatter.string(from: event.startDate)
            let endTime = formatter.string(from: event.endDate)
            timeLabel.text = "\(startTime) - \(endTime)"
        }
        
        // Location
        if let location = event.location, !location.isEmpty {
            locationLabel.text = "📍 \(location)"
            locationLabel.isHidden = false
        } else {
            locationLabel.isHidden = true
        }
        
        // Notes
        if let notes = event.notes, !notes.isEmpty {
            notesLabel.text = notes
            notesLabel.isHidden = false
        } else {
            notesLabel.isHidden = true
        }
    }
}
