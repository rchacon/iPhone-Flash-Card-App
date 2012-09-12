//
//  WebViewController.h
//  FlashCards
//
//  Created by Raul Chacon on 12/13/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * WebViewController
 * view controller with about contents displayed in a web view
 */


@interface WebViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSMutableString *flashCardTitle;

@end
