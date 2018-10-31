//
//  DataConnection.h
//  PunchList
//
//  Created by apple on 15/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol connectionProtocolDelegate;

@interface DataConnection : NSObject < NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate,NSURLSessionDownloadDelegate, NSURLSessionStreamDelegate>

{
@private
    NSString *urlString;
    NSURLConnection *urlConnection;
    NSMutableData *downloadData;
    BOOL isGetResponseWithIn90sec;
    BOOL isTimedOut;
    
    
}
@property(nonatomic,retain) NSURLConnection *urlConnection;
@property(nonatomic,retain) NSMutableData *downloadData;
@property(nonatomic,assign)id<connectionProtocolDelegate>delegate;

-(id)initWithUrlStringFromData:(NSString*)myUrlString  withJsonString:(NSString*)jsonString  delegate:(id<connectionProtocolDelegate>)myDelegate;

-(id)initGetDataWithUrlString:(NSString*)myUrlString  withJsonString:(NSString*)jsonString  delegate:(id<connectionProtocolDelegate>)myDelegate;

-(id)initUpdateDataWithUrlString:(NSString*)myUrlString  withJsonString:(NSString*)jsonString  delegate:(id<connectionProtocolDelegate>)myDelegate;

-(void)requestListWithUrl:(NSString *)urlStr bodyDic:(NSDictionary *)body withResponseData:(void  (^)(NSData* bodyData))block failtureResponse:(void (^) (NSError* error))errorBlock checkConnectionStatus: (void (^)(BOOL isNetwork))networkBlock;

@end

@protocol connectionProtocolDelegate
@optional
-(void)dataLoadingFinished:(NSMutableData*)data;

@end
