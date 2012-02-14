//
//  Base64Enc.m
//  SK Codebase
//
//  Created by Martin Videfors on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Base64Enc.h"




@implementation Base64Enc

static const char _base64EncTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};



+ (NSString *) base64StringFromData: (NSData *)data length: (int)length {
    int lentext = [data length]; 
    if (lentext < 1) return @"";
    
    char *outbuf = malloc(lentext*4/3+4); // add 4 to be sure
    
    if ( !outbuf ) return nil;
    
    const unsigned char *raw = [data bytes];
    
    int inp = 0;
    int outp = 0;
    int do_now = lentext - (lentext%3);
    
    for ( outp = 0, inp = 0; inp < do_now; inp += 3 )
    {
        outbuf[outp++] = _base64EncTable[(raw[inp] & 0xFC) >> 2];
        outbuf[outp++] = _base64EncTable[((raw[inp] & 0x03) << 4) | ((raw[inp+1] & 0xF0) >> 4)];
        outbuf[outp++] = _base64EncTable[((raw[inp+1] & 0x0F) << 2) | ((raw[inp+2] & 0xC0) >> 6)];
        outbuf[outp++] = _base64EncTable[raw[inp+2] & 0x3F];
    }
    
    if ( do_now < lentext )
    {
        char tmpbuf[3] = {0,0,0};
        int left = lentext%3;
        for ( int i=0; i < left; i++ )
        {
            tmpbuf[i] = raw[do_now+i];
        }
        raw = tmpbuf;
        inp = 0;
        outbuf[outp++] = _base64EncTable[(raw[inp] & 0xFC) >> 2];
        outbuf[outp++] = _base64EncTable[((raw[inp] & 0x03) << 4) | ((raw[inp+1] & 0xF0) >> 4)];
        if ( left == 2 ) outbuf[outp++] = _base64EncTable[((raw[inp+1] & 0x0F) << 2) | ((raw[inp+2] & 0xC0) >> 6)];
        else outbuf[outp++] = '=';
        outbuf[outp++] = '=';

    }
    
    NSString *ret = [[NSString alloc] initWithBytes:outbuf length:outp encoding:NSASCIIStringEncoding];
    free(outbuf);
    
    return ret;
}


@end
