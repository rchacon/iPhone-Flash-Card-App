//
//  AddSubjectController.h
//  FlashCards
//
//  Created by Raul Chacon on 12/3/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatabaseModel;


/*
 * AddSubjectController:
 * controller for view that initiates insertion into subjects db table
 */


@interface AddSubjectController : UIViewController
{
    IBOutlet UITextField *titleField;
}
// pointer to database model object needed for inserting into database
@property (nonatomic, strong) DatabaseModel *databaseModel;

- (IBAction)addSubject:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
