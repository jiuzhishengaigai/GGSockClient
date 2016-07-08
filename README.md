
# GGSockClient
    
###对socket编程的简单封装,
    ** 简单用法 **
    - 使用的时候直接把GGSocketTools拖到项目中就可以了
    ```
    GGSocketTools *socketTool = [GGSocketTools shareSocketTools];
    socketTool.delegate = self;
    [socketTool connectSocketHost:@"host" port:@(port) ipv:GGInteProtocolIP4];
    
#pragma mark - GGSocketToolsDelegate
    - (void)socketTools:(GGSocketTools *)toos data:(NSData *)data error:(NSError *)error{
        
        
    }
    
    ```
    
    ```
    GGSocketTools *socketTool = [GGSocketTools shareSocketTools];
    socketTool.delegate = self;
    socketTool.host = @"host";
    socketTool.port = @(port);
    socketTool.ipV = GGInteProtocolIP4;
    [socketTool connect];
    ```
