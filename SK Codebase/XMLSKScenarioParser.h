//
//  XMLSKScenarioParser.h
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKScenario.h"
#import "EntityStore.h"

@interface XMLSKScenarioParser : NSObject<NSXMLParserDelegate>
{
    Boolean expectsCollection;
    NSMutableString *currentElementValue;
    SKScenario *scenario;
    NSMutableArray *scenarioList;
}

@property (nonatomic, weak) EntityStore *entityStore;

@end
