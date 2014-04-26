//
//  VoteViewController.m
//  OpenVote
//
//  Created by db on 26/4/14.
//  Copyright (c) 2014 Open Source Hong Kong. All rights reserved.
//

#import "VoteViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"

#define K_VOTE_CHOICE_1_TAG 1
#define K_VOTE_CHOICE_2_TAG 2

@interface VoteViewController()


@end

@implementation VoteViewController

@synthesize tfHkid;

@synthesize hkid = _hkid;

@synthesize svCandidates = _svCandidates;

@synthesize indicator = _indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [_indicator startAnimating];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"candidate" ofType:@"json"];
    
    NSError *jsonError;
    
    NSString* candidate = [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionAllowLossy error:&jsonError];
    
    NSLog(@"Candidate:%@", candidate);
    
//    JSONDecoder *jd = [JSONDecoder decoder];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    
//    NSData *fileContent = [NSData dataWithContentsOfFile:filePath];
//    
//    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];

//    NSDictionary *jsonDictionary = (NSDictionary*)[jsonKitDecoder objectWithData:fileContent];
//    
//    id f = [fileContent objectFromJSONData];
//    
//    NSArray *candidateArray = [jsonDictionary objectForKey:@"candidate"];
//    
//    for (int i = 0; i < [candidateArray count]; i++){
//
//        NSDictionary* dictCandidate = [candidateArray objectAtIndex:i];
//        
//        NSLog(@"Candidate:%@, %@, %@", [dictCandidate objectForKey:@"name"], [dictCandidate objectForKey:@"id"], [dictCandidate objectForKey:@"avatar"]);
//        
//        
//        
//        
//        
//        
//    }

    
    [_indicator stopAnimating];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}

- (IBAction) photoButtonClicked:(id)sender
{
    UIButton* btn = (UIButton*) sender;
    
    int tag = btn.tag;
        
    switch (tag) {
        case K_VOTE_CHOICE_1_TAG:
            
            _voteChoice = K_VOTE_CHOICE_1_TAG;
            
            NSLog(@"1");
            
            break;
            
        case K_VOTE_CHOICE_2_TAG:
            
            _voteChoice = K_VOTE_CHOICE_2_TAG;
            
            break;
            
        default:
            break;
            
    }
    

}

- (IBAction) voteButtonClicked:(id)sender
{
    CocoaSecurityResult *encrypted = [self hashContent:_hkid];
    
    /* POST MESSAGE */
    NSDictionary *parameters = @{@"vote": [NSString stringWithFormat:@"%d", _voteChoice], @"hkid": encrypted.hexLower};

    
}

- (CocoaSecurityResult*) hashContent:(NSString*) plaintext
{
    CocoaSecurityResult *encrypted = [self encodeMD5:plaintext];
    
    encrypted = [self encodeSHA1:encrypted.data];
    
    return encrypted;
}

- (CocoaSecurityResult*) encodeMD5:(NSString*) plaintext
{

    CocoaSecurityResult *md5 = [CocoaSecurity md5:plaintext];

    NSLog(@"%@", md5.hex);
    
    return md5;
}

- (CocoaSecurityResult*) encodeSHA1:(NSData*) hashedData
{
    CocoaSecurityResult *sha1 = [CocoaSecurity sha1WithData:hashedData];
    
    NSLog(@"%@", sha1.hex);
    
    return sha1;
}


#pragma mark Textfield Delegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return true;
}

@end
