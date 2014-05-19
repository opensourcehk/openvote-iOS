//
//  VoteViewController.m
//  OpenVote
//
//  Created by db on 26/4/14.
//  Copyright (c) 2014 Open Source Hong Kong. All rights reserved.
//

#import "VoteViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "AFImageDownloader.h"

#define K_VOTE_CHOICE_1_TAG 1
#define K_VOTE_CHOICE_2_TAG 2

#define K_VOTE_URL @"" // TODO: Add your remote candidate server

#define K_REMOTE_CANDIDATE @"/candidate.php"

@interface VoteViewController()


@end

@implementation VoteViewController

@synthesize imgView1 = _imgView1;

@synthesize imgView2 = _imgView2;

@synthesize lblName1;

@synthesize lblName2;

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
    
    [self loadCandidate];
    
    
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
    
    long tag = btn.tag;
        
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

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[NSString stringWithFormat:@"%@", K_VOTE_URL ]
      parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
                NSLog(@"%@", responseObject);
                
                 [self.indicator stopAnimating];
                
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         NSLog(@"Error: %@", error);
         
         [self.indicator stopAnimating];
     }];

    
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


#pragma mark

- (void) loadCandidate
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{};
    [manager GET:[NSString stringWithFormat:@"%@%@", K_VOTE_URL, K_REMOTE_CANDIDATE]
      parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [self.indicator stopAnimating];
              
              NSLog(@"Success: %@", responseObject);
              
              NSString* voteTitle = [responseObject objectForKey:@"vote_title"];
              
              self.lblVoteTitle.title = voteTitle;
              
              NSArray* candidates = [responseObject objectForKey:@"candidate"];
              
              for (int i = 0; i < [candidates count]; i++){
              
                  NSDictionary *candidate = [candidates objectAtIndex:i];
                  
                  NSString* avatar = [candidate objectForKey:@"avatar"];
                  
                  NSNumber* cid = [candidate objectForKey:@"id"];
                  
                  NSString* name = [candidate objectForKey:@"name"];

                  NSString* imageUrl = [NSString stringWithFormat:@"%@/%@", K_VOTE_URL, avatar];
                  
                  
                  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, i*200+180, 260, 300)];
                  
                  [self.svCandidates addSubview:imageView];
                  
                  [imageView setTag:100+i];
                  
                  UIButton* btnCandiate = [[UIButton alloc] initWithFrame:imageView.frame];
                  
                  [self.svCandidates addSubview:btnCandiate];
                  
                  [self loadImage:imageUrl withImageView:imageView];
                  
                  UILabel* lblName = [[UILabel alloc] initWithFrame:CGRectMake(30, i*180+180, 260, 50)];
                  
                  lblName.text = name;
                  
                  lblName.textColor = [UIColor yellowColor];
                  
                  
                  
                  [self.svCandidates addSubview:lblName];
                  
                  [self.svCandidates setContentSize:CGSizeMake(self.svCandidates.contentSize.width, self.svCandidates.contentSize.height + 500)];
                  
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
              [self.indicator stopAnimating];
          }];
}

- (void) loadImage:(NSString*) url withImageView:(id) aImageView
{
    
//    NSLog(@"Image url:%@", url);
    
    [AFImageDownloader imageDownloaderWithURLString:url
                                          autoStart:YES completion:^(UIImage *decompressedImage) {
                                              
                                              ((UIImageView*)aImageView).image = decompressedImage;
                                              
                                              [aImageView setContentMode:UIViewContentModeScaleAspectFit];
    }];
    
    
    NSLog(@"%0.2f, %0.2f", self.svCandidates.contentSize.width, self.svCandidates.contentSize.height);
    
   }
@end
