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
    var counterPageDelegate: MainPageViewController!
    var paretController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.register(UINib.init(nibName: "ExerciseTableViewCell", bundle: nil) , forCellReuseIdentifier: "exerciseCell")
        
        self.tableView?.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as? ExerciseTableViewCell else {
            return UITableViewCell()
        }
        
        let exercise = HardcodedModel.exercises[indexPath.row]
        
        cell.exerciseTitle.text = exercise.title
        cell.exerciseTitle.textColor = UIColor.white
        cell.exerciseDescription.text = exercise.description
        cell.exercisePreview.image = exercise.image
        cell.exerciseId = exercise.id
        cell.exercisePreview.contentMode = UIViewContentMode.scaleAspectFill
        
        cell.exercisePreview.layer.masksToBounds = true
        cell.exercisePreview.clipsToBounds = true
        
        cell.frame.size.height = (cell.exercisePreview.image?.size.height)!
        cell.gradientView.gradientLayer.colors = [UIColor.black.cgColor, UIColor.black.withAlphaComponent(0)]
        cell.gradientView.gradientLayer.gradient = GradientPoint.bottomTop.draw()
        cell.gradientView.updateConstraints()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.counterPageDelegate?.exercise = HardcodedModel.exercises[indexPath.row]
        self.counterPageDelegate?.updateData()
        self.paretController?.scrollView.setContentOffset(CGPoint(x: (self.paretController?.view.frame.width)! * 2, y: 0), animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame.size.width = self.view.frame.width
        headerView.frame.size.height = 170
        headerView.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        //UIColor.white //UIColor(red:0.35, green:0.67, blue:0.89, alpha:1.0)
        
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
        subtitle.frame.origin.x = headerView.frame.origin.x + 20
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
