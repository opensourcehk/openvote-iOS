//
//  VoteViewController.h
//  OpenVote
//
//  Created by db on 26/4/14.
//  Copyright (c) 2014 Open Source Hong Kong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaSecurity.h"

@interface VoteViewController : UIViewController <UITextFieldDelegate>
{
    int _voteChoice;
    
    NSString* _hkid;
    
    UIScrollView* _svCandidates;
 
    UIActivityIndicatorView* _indicator;
    
    NSArray* _candidates;
    
    UIImageView *_imgView1;
    UIImageView *_imgView2;
    
    UIBarButtonItem* _lblVoteTitle;
}

@property (nonatomic, retain) NSString* hkid;

@property (nonatomic, retain) IBOutlet UITextField *tfHkid;

@property (nonatomic, retain) IBOutlet UIScrollView *svCandidates;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* indicator;

@property (nonatomic, retain) IBOutlet UIImageView* imgView1;
@property (nonatomic, retain) IBOutlet UIImageView* imgView2;

@property (nonatomic, retain) IBOutlet UILabel* lblName1;

@property (nonatomic, retain) IBOutlet UILabel* lblName2;

@property (nonatomic, retain) IBOutlet UIBarButtonItem* lblVoteTitle;

- (IBAction) voteButtonClicked:(id)sender;

- (void) loadCandidate;

- (void) loadImage:(NSString*) url withImageView:(id) imageView;

- (CocoaSecurityResult*) hashContent:(NSString*) plaintext;

- (CocoaSecurityResult*) encodeMD5:(NSString*) plaintext;

- (CocoaSecurityResult*) encodeSHA1:(NSData*) hashedData;

@end
