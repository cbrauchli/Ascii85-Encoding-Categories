//
//  NSString+Ascii85.h
//  Lasso
//
//  Created by Chris Brauchli on 3/10/12.
//  Copyright (c) 2012 Chris Brauchli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Ascii85.h"

@interface NSString (Ascii85)

- (NSString *)ascii85Encode;

- (NSString *)ascii85EncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)ascii85Decode;

- (NSString *)ascii85DecodeUsingEncoding:(NSStringEncoding)encoding;

@end
