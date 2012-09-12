//
//  AddFlashCardController.h
//  FlashCards
//
//  Created by Raul Chacon on 12/3/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatabaseModel;

/*
 * AddFlashCardController:
 * view controller with form to insert new flash card into database
 */


@interface AddFlashCardController : UIViewController
{
    IBOutlet UITextField *titleField;
    IBOutlet UITextField *definitionField;
}
@property (nonatomic, strong) DatabaseModel *databaseModel;
@property (nonatomic, strong) NSString *subjectTitle;

- (IBAction)addFlashCard:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end
