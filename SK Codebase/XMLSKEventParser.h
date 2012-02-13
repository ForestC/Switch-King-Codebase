//
//  XMLSKEventParser.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKEventStoreDelegate.h"
#import "EntityStore.h"
#import "SKEvent.h"

@interface XMLSKEventParser : NSObject<NSXMLParserDelegate>
{
    Boolean expectsCollection;
    NSMutableString *currentElementValue;
    SKEvent *event;
    NSMutableArray *eventList;
}

@property (nonatomic, weak) EntityStore *entityStore;

@end
