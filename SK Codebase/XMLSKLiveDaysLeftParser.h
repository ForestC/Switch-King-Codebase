//
//  XMLSKLiveDaysLeftParser.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityStore.h"

@interface XMLSKLiveDaysLeftParser : NSObject<NSXMLParserDelegate>
{
    NSMutableString *currentElementValue;
}

@property (nonatomic, weak) EntityStore *entityStore;

@end