//
//  WebViewController.m
//  FlashCards
//
//  Created by Raul Chacon on 12/13/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController
@synthesize flashCardTitle;

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.title = @"Wikipedia";

    // replace spaces with underscores in order to construct query string for wikipedia
    [flashCardTitle replaceOccurrencesOfString:@" " withString:@"_" options:NSCaseInsensitiveSearch 
                                         range:NSMakeRange(0, [flashCardTitle length])];
    
    // construct dynamic url
    NSMutableString *URL = [[NSMutableString alloc] init];
    [URL setString:@"http://en.wikipedia.org/wiki/Special:Search/"];
    [URL appendString:flashCardTitle];
    
    // load wikipedia with search string to web view
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    
    
    [super viewDidLoad];
}


//- (void)viewDidUnload
//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
