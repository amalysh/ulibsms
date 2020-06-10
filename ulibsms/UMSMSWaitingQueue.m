//
//  UMSMSWaitingQueue.m
//  ulibsms
//
//  Copyright © 2017 Andreas Fink (andreas@fink.org). All rights reserved.
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.
//
#import "UMSMSWaitingQueue.h"
#import "UMGlobalMessageCache.h"

//#define DEBUG_LOGGING    1


@implementation UMSMSWaitingQueue

- (UMSMSWaitingQueue *)init
{
    self = [super init];
    if(self)
    {
        _numbersInProgress = [[UMSynchronizedDictionary alloc]init];
        _lock = [[UMMutex alloc]initWithName:@"sms-waiting-queue"];
    }
    return self;
}

- (BOOL)isTransactionToNumberInProgress:(NSString *)number
{
    BOOL returnValue = NO;
    @autoreleasepool
    {
        [_lock lock];
    #ifdef DEBUG_LOGGING
        NSLog(@"waitingQueue isTransactionToNumberInProgress:%@",number);
    #endif
        UMSynchronizedArray *transactionsOfNumber = _numbersInProgress[number];
        if([transactionsOfNumber count]>0)
        {
            returnValue = YES;
        }
        [_lock unlock];
    }
    return returnValue;
}

- (void)queueTransaction:(id<UMSMSTransactionProtocol>)transaction
               forNumber:(NSString *)number
{
    @autoreleasepool
    {
        [_lock lock];
#ifdef DEBUG_LOGGING
    NSLog(@"waitingQueue queueTransaction:%@ forNumber:%@",transaction,number);
#endif
        UMQueue *transactionsOfNumber = _numbersInProgress[number];
        if(transactionsOfNumber == NULL)
        {
            transactionsOfNumber = [[UMQueue alloc]init];
        }
        [transactionsOfNumber append:transaction];
        _numbersInProgress[number] = transactionsOfNumber;
        [_messageCache retainMessage:transaction.msg forMessageId:transaction.messageId file:__FILE__ line:__LINE__ func:__FUNCTION__];
        [_lock unlock];
    }
}

- (id<UMSMSTransactionProtocol>)getNextTransactionForNumber:(NSString *)number
{
    
    id<UMSMSTransactionProtocol> transaction = NULL;
    @autoreleasepool
    {
        [_lock lock];

#ifdef DEBUG_LOGGING
    NSLog(@"waitingQueue getNextTransactionForNumber:%@",number);
#endif

        UMQueue *transactionsOfNumber = _numbersInProgress[number];
        if(transactionsOfNumber == NULL)
        {
#ifdef DEBUG_LOGGING
            NSLog(@"  return NULL");
#endif
        }
        else
        {
            transaction = [transactionsOfNumber getFirst];
            [_messageCache releaseMessage:transaction.msg forMessageId:transaction.messageId file:__FILE__ line:__LINE__ func:__FUNCTION__];
            if([transactionsOfNumber count]<1)
            {
                [_numbersInProgress removeObjectForKey:number];
            }
            else
            {
                _numbersInProgress[number] = transactionsOfNumber;
            }
        }
#ifdef DEBUG_LOGGING
        NSLog(@"  returning %@",transaction);
#endif
        [_lock unlock];
    }
    return transaction;
}

- (NSInteger)count
{
    NSInteger count = 0;
    [_lock unlock];
    count =  [_numbersInProgress count];
    [_lock unlock];
    return count;
}

@end
