//
//  UMGlobalMessageCacheEntry.h
//  ulibsms
//
//  © 2016  by Andreas Fink
//
// This source is dual licensed either under the GNU GENERAL PUBLIC LICENSE
// Version 3 from 29 June 2007 and other commercial licenses available by
// the author.
//

#import <ulib/ulib.h>

@interface UMGlobalMessageCacheEntry : UMObject
{
    NSString    *messageId;
    id          msg;
    int         retainCounter;
}

@property(readwrite,strong) NSString   *messageId;
@property(readwrite,strong) id          msg;
@property(readwrite,assign) int         retainCounter;


@end
