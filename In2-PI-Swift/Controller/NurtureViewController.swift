//
//  NurtureViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import SafariServices

class NurtureViewController: ParentViewController, SFSafariViewControllerDelegate {

    private let kOriginalContentViewHeight: CGFloat = 454
    var expandedAboutViewHeight:CGFloat = 0
    @IBOutlet var contentView: UIView!
    @IBOutlet var expandableAboutView: ExpandableAboutView!
    @IBOutlet weak var constraintHeightExpandableView: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var leftNurtureApplyWidget: ApplyWidgetView!
    @IBOutlet weak var rightHolyStarApplyWidget: ApplyWidgetView!
    @IBOutlet weak var nurtureNewsWidget: BoroSpecificNewsWidgetView!


    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        setUpExpandableAboutView()
        leftNurtureApplyWidget.applyButtonPressedHandler = {(sender) -> Void in
            self.presentSFSafariVCIfAvailable(NSURL(string: kApplyNurtureTeamGoogleDocURL)!)
        }
        rightHolyStarApplyWidget.applyButtonPressedHandler = {(sender) -> Void in
            self.openHolyStarIntroViewController()
        }
    }
    
    private func presentSFSafariVCIfAvailable(url: NSURL) {
        if #available(iOS 9.0, *) {
            let sfVC = SFSafariViewController(URL: url, entersReaderIfAvailable: true)
            sfVC.delegate = self
            self.presentViewController(sfVC, animated: true, completion: nil)
            //in case anybody prefers right to left push viewcontroller animation transition (below)
            //navigationController?.pushViewController(sfVC, animated: true)
        } else {
            // Fallback on earlier versions
            let webView = UIWebView(frame: view.frame)
            webView.loadRequest(NSURLRequest(URL: url))
            let vc = UIViewController()
            vc.view = webView
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setUpExpandableAboutView() {
        expandedAboutViewHeight = kOriginalAboutViewHeight + expandableAboutView.textView.frame.size.height + 30
        expandableAboutView.clipsToBounds = true
        expandableAboutView.delegate = ExpandableAboutViewHandler(viewControllerView: view, expandableView: expandableAboutView, constraintExpandableViewHeight: constraintHeightExpandableView, constraintContentViewHeight: constraintContentViewHeight, originalAboutViewHeight: kOriginalAboutViewHeight, expandedAboutViewHeight: expandedAboutViewHeight, originalContentViewHeight: kOriginalContentViewHeight)
    }
    
    private func openHolyStarIntroViewController() {
        let holyStarVC = HolyStarIntroViewController(nibName: "HolyStarIntroViewController", bundle: nil)
        holyStarVC.title = "홀리스타"
        self.navigationController?.pushViewController(holyStarVC, animated: true)
    }

    

}
