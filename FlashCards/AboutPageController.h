//
//  AboutPageController.h
//  FlashCards
//
//  Created by Raul Chacon on 12/13/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * AboutPageController
 * view controller with about contents displayed in a web view
 */


@interface AboutPageController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
