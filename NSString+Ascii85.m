//
//  NSString+Ascii85.m
//  Lasso
//
//  Created by Chris Brauchli on 3/10/12.
//  Copyright (c) 2012 Chris Brauchli. All rights reserved.
//

#import "NSString+Ascii85.h"

@implementation NSString (Ascii85)

- (NSString *)ascii85Encode
{
  return [self ascii85EncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)ascii85EncodeUsingEncoding:(NSStringEncoding)encoding
{
  return [[self dataUsingEncoding:encoding] ascii85EncodedString];
}

- (NSString *)ascii85Decode
{
  return [self ascii85DecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)ascii85DecodeUsingEncoding:(NSStringEncoding)encoding
{
  return [[NSString alloc] initWithData:[NSData dataWithAscii85String:self] encoding:encoding];
}

@end
