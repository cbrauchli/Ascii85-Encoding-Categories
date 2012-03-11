//
//  NSData+Ascii85.h
//  Lasso
//
//  Created by Chris Brauchli on 3/10/12.
//  Copyright (c) 2012 Chris Brauchli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Ascii85)

- (NSString *)ascii85EncodedString;

+ (NSData *)dataWithAscii85String:(NSString*)ascii85;

@end
