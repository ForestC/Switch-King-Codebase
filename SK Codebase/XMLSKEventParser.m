//
//  XMLSKEventParser.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLSKEventParser.h"
#import "SKEvent.h"
#include "Constants.h"
#import "NSString+HTML.h"

@implementation XMLSKEventParser

@synthesize entityStore;

- (XMLSKEventParser *) initXmlParser {
    self = [super init];
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:XML_ELEMENT_NAME__EVENT_ARRAY]) {
        self->expectsCollection = true;
        eventList = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:XML_ELEMENT_NAME__EVENT]) {
        
        //Initialize the book.
        event = [[SKEvent alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:XML_ELEMENT_NAME__EVENT_ARRAY]) {
        if(entityStore != nil) {
            [entityStore entityCollectionUpdated:self :eventList :[SKEvent class]];
        }
        
        event = nil;
    } else if([elementName isEqualToString:XML_ELEMENT_NAME__EVENT]) {        
        if(!expectsCollection) {
            if(entityStore != nil) {
                [entityStore entityUpdated:self :event];
            }
        } else {
            [eventList addObject:event];
        }
        
        event = nil;
    }
    else {
        @try {
            //            if([currentElementValue isEqualToString:XML_VALUE__TRUE]) {
            //                [device setValue:@"YES" forKey:elementName];                
            //            } else if([currentElementValue isEqualToString:XML_VALUE__FALSE]) {
            //                [device setValue:@"NO" forKey:elementName];
            //            } else {
            NSString *unescaped = [currentElementValue stringByDecodingHTMLEntities];
            [event setValue:unescaped forKey:elementName];
            // }
        }
        @catch (NSException * e) {
            NSLog(@"Invalid key: %@", elementName);
        }
    }
    
    currentElementValue = nil;
}

@end