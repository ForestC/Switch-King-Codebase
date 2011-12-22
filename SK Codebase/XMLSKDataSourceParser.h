//
//  XMLSKDataSourceParser.h
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDataSourceStoreDelegate.h"
#import "EntityStore.h"
#import "SKDataSource.h"

@interface XMLSKDataSourceParser : NSObject<NSXMLParserDelegate>
{
    Boolean expectsCollection;
    NSMutableString *currentElementValue;
    SKDataSource *dataSource;
    NSMutableArray *dataSourceList;
    EntityStore *entityStore;
}

@property (retain) EntityStore * entityStore;

@end
