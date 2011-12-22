//
//  XmlSKDeviceParser.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SKDeviceStoreDelegate.h"
#import "EntityStore.h"

@class SKDevice;

@interface XMLSKDeviceParser : NSObject<NSXMLParserDelegate>
{
    Boolean expectsCollection;
    NSMutableString *currentElementValue;
    SKDevice *device;
    NSMutableArray *deviceList;
    EntityStore *entityStore;
}

@property (retain) EntityStore * entityStore;
    
@end
