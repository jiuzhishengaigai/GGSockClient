//
//  GGSocketTools.h
//  runtime
//
//  Created by GaiGai on 16/7/7.
//  Copyright © 2016年 GaiGai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GGSocketTools;

typedef NS_ENUM(NSInteger, GGConnectError) {
    GGConnectErrorUnknow,
    GGConnectErrorCreatSock,
    GGConnectErrorFail,
    GGConnectErrorHostName
};

typedef NS_ENUM(NSInteger, GGInteProtocol) {
    GGInteProtocolIP4,
    GGInteProtocolIP6
};

@protocol GGSocketToolsDelegate <NSObject>

- (void)socketTools:(GGSocketTools *)toos data:(NSData *)data error:(NSError *)error;

@end

@interface GGSocketTools : NSObject

+ (instancetype)shareSocketTools;

/**
 *  IP
 */
@property (nonatomic, copy) NSString *host;
/**
 *  端口
 */
@property (nonatomic, strong) NSNumber *port;
/**
 *  网络连接协议
 */
@property (nonatomic, assign) GGInteProtocol ipV;
/**
 *  代理
 */
@property (nonatomic, weak) id<GGSocketToolsDelegate> delegate;

/**
 *  连接
 *
 *  @return 文件描述符
 */
- (int)connect;

/**
 *  连接
 *
 *  @param host             IP
 *  @param port             端口
 *  @param ipv              互联网协议
 *  @param receiveDataBlock 数据的回调
 *
 *  @return 文件描述符,error有值,返回-1
 */
- (int)connectSocketHost:(NSString *)host port:(NSNumber *)port ipv:(GGInteProtocol)ipv;


@end
