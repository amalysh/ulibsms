//
//  UMLayerSMS.h
//  ulibsms
//
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.
//
#import <ulib/ulib.h>
#import <ulibasn1/ulibasn1.h>

@class UMSMSInProgressQueue;
@class UMSMSWaitingQueue;
@class UMSMSRetryQueue;
@class UMHLRCache;
@class UMLayerGSMMAP;

@interface UMLayerSMS : UMLayer
{
    UMLayerGSMMAP           *mapInstance;
    NSString                *smscNumber;
    UMSMSWaitingQueue       *waitingQueue;      /* SMS waiting to be sent as soon as the number becomes free */
    UMSMSInProgressQueue    *inProgressQueue;   /* SMS currently being sent */
    UMSMSRetryQueue         *retryQueue;        /* SMS to be resent after some time (during normal retry) */
    UMHLRCache              *hlrCache;
}

@property (readwrite,strong)    UMSMSInProgressQueue    *inProgressQueue;
@property (readwrite,strong)    UMSMSWaitingQueue       *waitingQueue;
@property (readwrite,strong)    UMSMSRetryQueue         *retryQueue;
@property (readwrite,strong)    UMHLRCache              *hlrCache;

@property (readwrite,strong)    NSString                *smscNumber;
@property (readwrite,strong)    UMLayerGSMMAP           *mapInstance;

- (UMLayerSMS *)initWithTaskQueueMulti:(UMTaskQueueMulti *)tq;
- (UMLayerSMS *)initWithTaskQueueMulti:(UMTaskQueueMulti *)tq name:(NSString *)name;

@end
