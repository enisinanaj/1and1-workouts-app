//
//  ExercisesTableTableViewController.swift
//  1and1.workout
//
//  Created by Eni Sinanaj on 14/08/2017.
//  Copyright © 2017 Eni Sinanaj. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    func withFont(_ font: UIFont) -> NSMutableAttributedString {
        self.removeAttribute(NSFontAttributeName, range: NSRange(location: 0, length: self.length))
        self.addAttributes([NSFontAttributeName: font], range: NSRange(location: 0, length: self.length))
        return self
    }
}

class ExercisesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var title = ""
        
        switch indexPath.row {
        case 0:
            title = "High knees"
        case 1:
            title = "Jumping jacks"
        case 2:
            title = "Squats"
        case 3:
            title = "Lunges"
        case 4:
            title = "Plank leg raises"
        case 5:
            title = "Climbers"
        case 6:
            title = "Bicycle crunches"
        case 7:
            title = "Leg raises"
        case 8:
            title = "Knee pull-ins"
        case 9:
            title = "Push-ups"
        default:
            title = "High knees"
        }
        
        cell.textLabel?.text = title
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame.size.width = self.view.frame.width
        headerView.frame.size.height = 170
        headerView.backgroundColor = UIColor.white //UIColor(red:0.35, green:0.67, blue:0.89, alpha:1.0)
        
        let startingPoint = addTitleToSectionHeaderView(headerView)
        _ = addSubtitleToSectionHeaderView(headerView, startingPoint: startingPoint)
        // addDescriptionLabel(headerView, startingPoint: descriptionStartinPoint)
        
        return headerView
    }
    
    func addTitleToSectionHeaderView(_ headerView: UIView) -> CGFloat {
        let title = UILabel()
        title.text = "1&1"
        title.frame.size.width = 100
        title.frame.origin.x = headerView.frame.origin.x + 10
        title.frame.origin.y = headerView.frame.origin.y + 25
        title.numberOfLines = 0
        
        var fontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute: "Helvetica Neue",
                                                               UIFontDescriptorSizeAttribute: 47.0,
                                                               UIFontDescriptorTraitsAttribute:
                                                                [UIFontWeightTrait: UIFontWeightHeavy]])
        
        title.font = UIFont(descriptor: fontDescriptor, size: 47.0)
        title.textColor = UIColor(displayP3Red: 0.98, green: 0.05, blue: 0.17, alpha: 1)
        title.sizeToFit()
        
        let titlePart = UILabel()
        titlePart.text = "WORKOUT"
        titlePart.frame.size.width = 250
        titlePart.frame.origin.x = title.frame.origin.x + title.frame.width + 5
        titlePart.frame.origin.y = headerView.frame.origin.y + 30
        titlePart.numberOfLines = 0
        
        fontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptorFamilyAttribute: "Helvetica Neue",
                                                               UIFontDescriptorSizeAttribute: 40,
                                                               UIFontDescriptorTraitsAttribute:
                                                                [UIFontWeightTrait: UIFontWeightRegular]])
        
        titlePart.font = UIFont(descriptor: fontDescriptor, size: 40)
        titlePart.textColor = UIColor.black
        titlePart.sizeToFit()
        
        headerView.addSubview(titlePart)
        headerView.addSubview(title)
        
        return title.frame.origin.y + title.bounds.height
    }
    
    func addSubtitleToSectionHeaderView(_ headerView: UIView, startingPoint: CGFloat) -> CGFloat {
        let subtitle = UILabel()
        subtitle.text = "1 minute each exercise / 1 minute rest afterwards"
        subtitle.frame.size.width = headerView.frame.width - 20
        subtitle.frame.origin.x = headerView.frame.origin.x + 15
        subtitle.frame.origin.y = startingPoint - 5
        subtitle.numberOfLines = 1
        subtitle.adjustsFontSizeToFitWidth = true
        subtitle.minimumScaleFactor = 0.5
        subtitle.adjustsFontForContentSizeCategory = true
        
        subtitle.font = UIFont(name:"AvenirNextCondensed-Regular" , size: 16)
        subtitle.textColor = UIColor.black //UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        
        headerView.addSubview(subtitle)
        subtitle.sizeToFit()
        
        return subtitle.bounds.height + subtitle.frame.origin.y + 10
    }
    
    func addDescriptionLabel(_ headerView: UIView, startingPoint: CGFloat) {
        let descriptionInTitle = UILabel()
        
        let attributedText = createAttributedText()
        
        descriptionInTitle.attributedText = attributedText
        descriptionInTitle.frame.size.width = headerView.frame.width - 20
        descriptionInTitle.frame.origin.x = headerView.frame.origin.x + 15
        descriptionInTitle.frame.origin.y = startingPoint + 20
        descriptionInTitle.numberOfLines = 0
        descriptionInTitle.textColor = UIColor.black // UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        
        headerView.addSubview(descriptionInTitle)
        descriptionInTitle.sizeToFit()
    }
    
    fileprivate func createAttributedText() -> NSMutableAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.maximumLineHeight = 17
        
        let font = UIFont(name: "AvenirNextCondensed-Regular", size: 16)
        let boldFont = UIFont(name: "AvenirNextCondensed-Heavy", size: 16)
        
        let attributedText = NSMutableAttributedString(string: "level I ").withFont(boldFont!)
        attributedText.append(NSMutableAttributedString(string: "3 sets   ").withFont(font!))
        attributedText.append(NSMutableAttributedString(string: "level II ").withFont(boldFont!))
        attributedText.append(NSMutableAttributedString(string: "4 sets   ").withFont(font!))
        attributedText.append(NSMutableAttributedString(string: "level III ").withFont(boldFont!))
        attributedText.append(NSMutableAttributedString(string: "6 sets").withFont(font!))
        attributedText.append(NSMutableAttributedString(string: "\nrest between sets for up to 3 minutes").withFont(font!))
        
        attributedText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle],
                                     range: NSRange(location: 0, length: attributedText.length))
        
        return attributedText
    }
}
