//
//  XMLSKLiveDaysLeftParser.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLSKLiveDaysLeftParser.h"
#import "Constants.h"

@implementation XMLSKLiveDaysLeftParser

@synthesize entityStore;

- (XMLSKLiveDaysLeftParser *) initXmlParser {
    self = [super init];
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
//    
//    if([elementName isEqualToString:XML_ELEMENT_NAME__SCENARIO_ARRAY]) {
//        self->expectsCollection = true;
//        scenarioList = [[NSMutableArray alloc] init];
//    }
//    else if([elementName isEqualToString:XML_ELEMENT_NAME__SCENARIO]) {
//        
//        //Initialize the book.
//        scenario = [[SKScenario alloc] init];
//    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if(currentElementValue != nil && currentElementValue.length > 0) {
        NSInteger v = [currentElementValue integerValue];
    
        [entityStore daysLeftOfLiveUsageUpdated:v];    
    } else {
        [entityStore daysLeftOfLiveUsageUpdated:DAYS_LEFT_NO_INFO];
    }
    
    currentElementValue = nil;
}

@end
