//
//  UMSATTokenDeck.m
//  decode-st
//
//  Created by Andreas Fink on 18.10.19.
//  Copyright © 2019 Andreas Fink (andreas@fink.org). All rights reserved.
//

#import "UMSATTokenDeck.h"

@implementation UMSATTokenDeck

- (void)decodePayload
{
    [self lookForSubtokens];
}

@end
