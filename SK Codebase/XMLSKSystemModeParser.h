//
//  XMLSKSystemModeParser.h
//  Switch King
//
//  Created by Martin Videfors on 2012-10-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSystemMode.h"
#import "EntityStore.h"

@interface XMLSKSystemModeParser : NSObject<NSXMLParserDelegate>
{
    Boolean expectsCollection;
    NSMutableString *currentElementValue;
    SKSystemMode *systemMode;
    NSMutableArray *systemModeList;
}

@property (nonatomic, weak) EntityStore *entityStore;

@end
