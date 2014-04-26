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
}

@property (nonatomic, retain) NSString* hkid;

@property (nonatomic, retain) IBOutlet UITextField *tfHkid;

@property (nonatomic, retain) IBOutlet UIScrollView *svCandidates;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView* indicator;

- (IBAction) voteButtonClicked:(id)sender;

- (CocoaSecurityResult*) hashContent:(NSString*) plaintext;

- (CocoaSecurityResult*) encodeMD5:(NSString*) plaintext;

- (CocoaSecurityResult*) encodeSHA1:(NSData*) hashedData;

@end
