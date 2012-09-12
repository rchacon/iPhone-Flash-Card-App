//
//  FlashCardModel.m
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "FlashCardModel.h"

@implementation FlashCardModel
@synthesize primaryKey, title, definition, isHidden, insertDate;

- (id) initWithId: (int) aId title: (NSString *) aTitle definition: (NSString *) aDefinition isHidden: (int) isHiddenBit insertDate: (NSString *) aInsertDate
{
    self.primaryKey = aId;
    self.title = aTitle;
    self.definition = aDefinition;
    self.isHidden = isHiddenBit;
    self.insertDate = aInsertDate;
    
    return self;
}


// there is a namespace warning with the property definition
- (NSString *) getDefinition
{
    return self.definition;
}
@end
