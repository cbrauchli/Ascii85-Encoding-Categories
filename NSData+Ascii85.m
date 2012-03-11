//
//  NSData+Ascii85.m
//  Lasso
//
//  Created by Chris Brauchli on 3/10/12.
//  Copyright (c) 2012 Chris Brauchli. All rights reserved.
//

#import "NSData+Ascii85.h"

static const unsigned char _b85encode[] = {
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 
  '!', '#', '$', '%', '&', '(', ')', '*', '+', '-', ';', '<', '=', '>', '?', '@', '^', '_', '`', '{', '|', '}', '~'
};

static const unsigned char _b85decode[] = {
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  
   0, 62,  0, 63, 64, 65, 66,  0, 67, 68, 69, 70,  0, 71,  0,  0,  
   0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  0, 72, 73, 74, 75, 76, 
  77, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 
  25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35,  0,  0,  0, 78, 79, 
  80, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 
  51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 81, 82, 83, 84,  0,  
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  
   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
};

@implementation NSData (Ascii85)

- (NSString *)ascii85EncodedString
{
  NSUInteger len = [self length];
  NSUInteger numBlocks = len / 4;
  NSUInteger remaining = len % 4;
  NSMutableData *output = [NSMutableData dataWithLength:numBlocks*5 + remaining + 1];
  char *outputBuffer = [output mutableBytes];
  NSUInteger outputLength = 0;
  
  for (NSUInteger i=0; i < numBlocks; i++) {
    NSData *data4 = [self subdataWithRange:NSMakeRange(i*4, 4)];
    uint32_t x = CFSwapInt32BigToHost(*(uint32_t*)([data4 bytes]));
    for (NSUInteger j=0; j < 5; j++) {
      outputBuffer[outputLength + (4-j)] = _b85encode[x % 85];
      x /= 85;
    }
    outputLength += 5;
  }
  
  if (remaining != 0) {
    NSData *data4 = [self subdataWithRange:NSMakeRange(numBlocks*4, remaining)];
    uint32_t x = CFSwapInt32BigToHost(*(uint32_t*)([data4 bytes]));
    for (NSUInteger j=0; j < 5; j++) {
      outputBuffer[outputLength + (4-j)] = _b85encode[x % 85];
      x /= 85;
    }
    outputLength += remaining + 1;
  }
  
  return [[NSString alloc] initWithBytes:outputBuffer length:outputLength encoding:NSASCIIStringEncoding];
}

+ (NSData *)dataWithAscii85String:(NSString*)ascii85
{
  const char *chars = [ascii85 cStringUsingEncoding:NSASCIIStringEncoding];
  NSUInteger len = [ascii85 length];
  NSUInteger numBlocks = len / 5;
  NSUInteger remaining = len % 5;
  
  NSMutableData *output = [NSMutableData dataWithLength:numBlocks*4 + remaining];
  NSUInteger outputLength = 0;
  
  for (NSUInteger i=0; i < numBlocks; i++) {
    uint32_t x = 0;
    for (NSUInteger j=0; j < 5; j++) {
      x = x*85 + _b85decode[chars[i*5 + j]];
    }
    x = CFSwapInt32HostToBig(x);
    [output replaceBytesInRange:NSMakeRange(i*4, 4) withBytes:&x];
    outputLength += 4;
  }
  
  if (remaining > 0) {
    uint32_t x = 0;
    for (NSUInteger i=0; i < remaining; i++) {
      x = x*85 + _b85decode[chars[numBlocks*5 + i]];
    }
    x *= pow(85, 5 - remaining);
    if (remaining > 1)
      x += 0xffffff >> (remaining - 2) * 8;
    
    x = CFSwapInt32HostToBig(x);
    [output replaceBytesInRange:NSMakeRange(numBlocks*4, 4) withBytes:&x];
    outputLength += remaining - 1;
  }
  
  return [output subdataWithRange:NSMakeRange(0, outputLength)];
}

@end
