//
//  GGSocketTools.m
//  runtime
//
//  Created by GaiGai on 16/7/7.
//  Copyright © 2016年 GaiGai. All rights reserved.
//

#import "GGSocketTools.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <netdb.h>

@implementation GGSocketTools
// 错误域常量
static NSString * const GGErrorDomain = @"GGErrorDomain";


static id _instance = nil;
+ (instancetype)shareSocketTools{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

// 连接
- (void)connect{
    [self connectSocketHost:self.host port:self.port ipv:self.ipV];
}

// 连接
- (void)connectSocketHost:(NSString *)host port:(NSNumber *)port ipv:(GGInteProtocol)ipv{

    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:host forKey:@"host"];
    [para setValue:port forKey:@"port"];
    [para setValue:@(ipv) forKey:@"ipv"];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(receiveData:) object:para] start];
}

- (void)receiveData:(NSDictionary *)para{
    
    NSString *host = [para valueForKey:@"host"];
    NSNumber *port = [para valueForKey:@"port"];
    NSInteger ipv = [(NSNumber *)[para valueForKey:@"ipv"] integerValue];
    
    NSError *error = nil;
    char buf[1024];
    
    
    int ip = 0;
    if (ipv == GGInteProtocolIP4) {
        ip = AF_INET;
    }else if(ipv == GGInteProtocolIP4){
        ip = AF_INET6;
    }
    // 创建套接字
    int sock = socket(ip, SOCK_STREAM, 0);
    if (sock == -1) {
        [self error:&error GGSocketToolConnectError:GGConnectErrorHostName userInfo:@"unable to resolve the hostname"];
        [self callBackDelegate:nil error:error];
        return;
    }
    // 使用DNS查找特定主机名字对应的IP
    struct hostent *remoteHp = gethostbyname([host UTF8String]);
    if (NULL == remoteHp) {
        close(sock);
        [self error:&error GGSocketToolConnectError:GGConnectErrorHostName userInfo:@"unable to resolve the hostname"];
        [self callBackDelegate:nil error:error];
        return;

    }
    
    // 描述套接字地址的结构体
    struct sockaddr_in sockPara;
    memcpy((char *)&sockPara.sin_addr, (char *)remoteHp->h_addr_list[0], remoteHp->h_length);
    //    sockPara.sin_addr = (struct in_addr*)remoteHp->h_addr_list[0];
    sockPara.sin_family = ip;
    sockPara.sin_port = htons([port intValue]);
    
    // 连接(会阻塞线程)
    int connectRet = connect(sock, (struct sockaddr *)&sockPara, sizeof(sockPara));
    
    if (-1 == connectRet) {
        close(sock);
        [self error:&error GGSocketToolConnectError:GGConnectErrorFail userInfo:[NSString stringWithFormat:@"faile to connect %@ : %@", host, port]];
        [self callBackDelegate:nil error:error];
        
        return;
    }
    
    // 接收数据
    
    NSMutableData *data = [NSMutableData data];
    BOOL hasData = YES;
    
    while (hasData) {
        // 会阻塞线程
        ssize_t result = recv(sock, &buf, sizeof(buf), 0);
        
        if (result > 0) {
            [data appendBytes:buf length:result];
        }else{
            hasData = NO;
        }
    }
    // 关闭套接字
    close(sock);
    // 回调代理
    [self callBackDelegate:data error:error];
    
    
}

// 关闭套接字
- (void)close:(int)sock{
    
    close(sock);
}

// 代理的回调
- (void)callBackDelegate:(NSData *)data error:(NSError *)error{
    if ([_delegate respondsToSelector:@selector(socketTools:data:error:)]) {
        [_delegate socketTools:self data:data error:error];
    }
}

// 错误信息
- (void)error:(NSError **)error GGSocketToolConnectError:(NSInteger)code userInfo:(NSString *)errorInfo{
    NSDictionary *info = @{NSLocalizedDescriptionKey : errorInfo};
    *error = [NSError errorWithDomain:GGErrorDomain code:code userInfo:info];
}



@end
