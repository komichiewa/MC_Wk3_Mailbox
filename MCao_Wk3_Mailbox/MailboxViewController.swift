//
//  MailboxViewController.swift
//  MCao_Wk3_Mailbox
//
//  Created by Michie Cao on 10/1/15.
//  Copyright © 2015 Michie Cao. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var edgePan: UIScreenEdgePanGestureRecognizer!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet var tapDismiss: UITapGestureRecognizer!
    
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var mailboxView: UIView!

    var messageViewOriginalCenter: CGPoint!
    var mailboxViewOriginalCenter: CGPoint!
    var messageViewOffset: CGFloat!
    var messageLeftEdge: CGFloat!
    var messageRightEdge: CGFloat!
    var initialXVelocity: CGFloat!
    var initialDragLeft: Bool!
    
    var grayColor = UIColor(red: 229/255.0, green: 230/255.0, blue: 232/255.0, alpha:1.0)
    var yellowColor = UIColor(red: 247/255.0, green: 204/255.0, blue: 39/255.0, alpha:1.0)
    var brownColor = UIColor(red: 206/255.0, green: 150/255.0, blue: 98/255.0, alpha:1.0)
    var redColor = UIColor(red: 228/255.0, green: 61/255.0, blue: 38/255.0, alpha:1.0)
    var greenColor = UIColor(red: 98/255.0, green: 214/255.0, blue: 79/255.0, alpha:1.0)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 320, height: 1202)
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        view.addGestureRecognizer(panGestureRecognizer)
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgeGesture)
        
        print("feed view Y = \(feedView.center.y)")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func checkTap(){
        
        var tapDismissRecognizer = UITapGestureRecognizer(target:self, action: "onTapDismiss:")
        
        if listView.alpha == 1 || rescheduleView.alpha == 1{
            view.addGestureRecognizer(tapDismissRecognizer)
        } else{
            view.removeGestureRecognizer(tapDismissRecognizer)
        }

    }
    
    @IBAction func onEdgePan(edgeGesture: UIScreenEdgePanGestureRecognizer) {
        print("Edge pan test")
        
        var eTranslation = edgeGesture.translationInView(view)
        var eVelocity = edgeGesture.velocityInView(view)
        
        if edgeGesture.state == UIGestureRecognizerState.Began{
            
            mailboxViewOriginalCenter == mailboxView.center
            
        } else if edgeGesture.state == UIGestureRecognizerState.Changed{
            mailboxView.center = CGPoint(x: mailboxViewOriginalCenter.x + eTranslation.x, y: mailboxViewOriginalCenter.y)
            
        } else if edgeGesture.state == UIGestureRecognizerState.Ended{
            
        }
        
    }
        
    @IBAction func onTapDismiss(sender: UITapGestureRecognizer) {
        
        listView.alpha = 0
        rescheduleView.alpha = 0
        
        hideRevealMessage()
    }
    
    
    func hideRevealMessage(){
    
        hideMessage()
        UIView .animateWithDuration(0.5, delay: 1, options: UIViewAnimationOptions.CurveEaseIn, animations: {self.feedView.center.y += 86}, completion: nil)
        
        delay(2, closure: {()-> () in
            self.messageContainerView.hidden = false
        })
        messageView.center.x = 160
        
    }
    
    func hideMessage(){
        
        messageContainerView.hidden = true
        UIView .animateWithDuration(0.5, animations: {self.feedView.center.y -= 86})
        print("feed view Y = \(feedView.center.y)")
    }
    
    func resetIcons(){
        archiveIcon.alpha = 0
        deleteIcon.alpha = 0
        laterIcon.alpha = 0
        listIcon.alpha = 0
    }
    
    @IBAction func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        var xOffset = messageView.frame.size.width/2
        var messageRightEdge = messageView.center.x + xOffset
        var messageLeftEdge = messageView.center.x - xOffset
        
        resetIcons()
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began{
           
            print("Gesture began at: \(point)")
            messageViewOriginalCenter = messageView.center
            initialXVelocity = velocity.x
            
            if initialXVelocity < 0{
               
                print("Initial drag = left")
                initialDragLeft = true
                
            } else{
                
                print("Initial drag = right")
                initialDragLeft = false
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed{
            
            print("Gesture changed at: \(point)")
             messageView.center = CGPoint(x: messageViewOriginalCenter.x + translation.x, y: messageViewOriginalCenter.y)
            
            if initialDragLeft == true{
                print("Initial drag = left")
                print("Right Edge X: \(messageRightEdge)")
            
                if messageRightEdge > 260{
                    
                    messageContainerView.backgroundColor = grayColor
                    //laterIcon.alpha = 1
                    laterIcon.alpha = 1 - ((messageRightEdge-260) * (100/60) * 0.01)
                    print(laterIcon.alpha)
                    
                } else if (messageRightEdge <= 260 && messageRightEdge >= 60){
                    
                    messageContainerView.backgroundColor = yellowColor
                    laterIcon.alpha = 1
                    laterIcon.center.x = messageRightEdge + 30
                    
                } else if messageRightEdge < 60 {
                    
                    messageContainerView.backgroundColor = brownColor
                    listIcon.alpha = 1
                    listIcon.center.x = messageRightEdge + 30
                }
            }
            else {
                print("Initial drag = right")
                print("Left Edge X: \(messageLeftEdge)")
            
                if messageLeftEdge < 60{
                    
                    messageContainerView.backgroundColor = grayColor
                    //archiveIcon.alpha = 1
                    archiveIcon.alpha = (messageLeftEdge) * (100/60) * 0.01
                    print(archiveIcon.alpha)
                    
                } else if messageLeftEdge <= 260 && messageLeftEdge >= 60{
                    
                    messageContainerView.backgroundColor = greenColor
                    archiveIcon.alpha = 1
                    archiveIcon.center.x = messageLeftEdge - 30
                    
                } else if messageLeftEdge > 260{
                    
                    messageContainerView.backgroundColor = redColor
                    
                    deleteIcon.alpha = 1
                    deleteIcon.center.x = messageLeftEdge - 30
                }
            }
        }else if panGestureRecognizer.state == UIGestureRecognizerState.Ended{
            if initialDragLeft == true{
                if messageRightEdge > 260 {
                
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.messageView.center.x = self.messageViewOriginalCenter.x
                    }, completion: nil)}
                
                if messageRightEdge <= 260 && messageRightEdge >= 60{
                    
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                            self.messageView.center.x = -160
                            self.rescheduleView.alpha = 1
                            self.checkTap()
                    }, completion: nil)}
                
               if messageRightEdge < 60{
                
                    UIView.animateWithDuration(0.5, delay: 0.0, options:    UIViewAnimationOptions.CurveEaseOut, animations: {
                            self.messageView.center.x = -160
                            self.listView.alpha = 1
                            self.checkTap()
                    }, completion: nil)}
                
            }
            else {
                
                if messageLeftEdge < 60{
                    
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.messageView.center.x = self.messageViewOriginalCenter.x
                        }, completion: nil)
                    
                }else if messageLeftEdge <= 260 && messageLeftEdge >= 60{
                   
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.messageView.center.x = 480
                        }, completion: nil)
                    self.archiveIcon.center.x = self.messageView.center.x - 60
                    hideMessage()
                    
                } else if messageLeftEdge > 260{
                    
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.messageView.center.x = 480
                        }, completion: nil)
                
                    self.deleteIcon.center.x = self.messageView.center.x - 60
                    hideMessage()
                }
                
            }
            
        }
    }
    
}
    