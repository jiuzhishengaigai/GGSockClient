//
//  ViewController.m
//  GGSockClient
//
//  Created by engfei on 16/7/7.
//  Copyright © 2016年 GaiGai. All rights reserved.
//

#import "ViewController.h"
#import "GGSocketTools.h"

@interface ViewController ()<GGSocketToolsDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GGSocketTools *socketTool = [GGSocketTools shareSocketTools];
    socketTool.delegate = self;
    [socketTool connectSocketHost:@"host" port:@(12) ipv:GGInteProtocolIP4];
    
    socketTool.host = @"host";
    socketTool.port = @(12);
    socketTool.ipV = GGInteProtocolIP4;
    [socketTool connect];
    
    
    
    
}

#pragma mark - GGSocketToolsDelegate

- (void)socketTools:(GGSocketTools *)toos data:(NSData *)data error:(NSError *)error{
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
    
}

@end
