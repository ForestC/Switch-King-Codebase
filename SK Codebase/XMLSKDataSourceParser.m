//
//  XmlSKDeviceParser.m
//  SK Codebase
//
//  Created by Martin Videfors on 2011-12-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "XMLSKDataSourceParser.h"
#import "SKDataSource.h"
#include "Constants.h"

@implementation XMLSKDataSourceParser

@synthesize entityStore;

- (XMLSKDataSourceParser *) initXmlParser {
    self = [super init];
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:XML_ELEMENT_NAME__DATASOURCE_ARRAY]) {
        self->expectsCollection = true;
        dataSourceList = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:XML_ELEMENT_NAME__DATASOURCE]) {
        
        //Initialize the book.
        dataSource = [[SKDataSource alloc] init];
    }
    
    //NSLog(@"Processing Element: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
    
    //NSLog(@"Processing Value: %@", currentElementValue);
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:XML_ELEMENT_NAME__DATASOURCE_ARRAY]) {
        if(entityStore != nil) {
            [entityStore entityCollectionUpdated:self :dataSourceList :[SKDataSource class]];
        }
        
        dataSource = nil;
    } else if([elementName isEqualToString:XML_ELEMENT_NAME__DATASOURCE]) {
        if(!expectsCollection) {
            if(entityStore != nil) {
                [entityStore entityUpdated:self :dataSource];
            }
        } else {
            [dataSourceList addObject:dataSource];
        }
        
        dataSource = nil;
    }
    else {
        @try {
            [dataSource setValue:currentElementValue forKey:elementName];
        }
        @catch (NSException * e) {
            //NSLog(@"Invalid key");
        }
    }
    
    currentElementValue = nil;
}

@end