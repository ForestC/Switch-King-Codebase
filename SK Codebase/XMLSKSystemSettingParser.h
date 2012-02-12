//
//  XMLSKSystemSettingParser.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKSystemSetting.h"
#import "EntityStore.h"

@interface XMLSKSystemSettingParser : NSObject<NSXMLParserDelegate>
{
    Boolean expectsCollection;
    NSMutableString *currentElementValue;
    SKSystemSetting *setting;
    NSMutableArray *settingList;
    EntityStore *entityStore;
}

@property (retain) EntityStore *entityStore;

@end
