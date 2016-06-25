//
//  vhServiceListener.m
//  test211_server
//
//  Created by SunSi on 16/6/25.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import "vhServiceListener.h"
#import "GCDAsyncSocket.h"

@interface vhServiceListener()<GCDAsyncSocketDelegate>
/** socket  */
@property (strong,nonatomic) GCDAsyncSocket  *socketAsync;
/** arr socket  */
@property (strong,nonatomic) NSMutableArray *socketServerArr;


@end

@implementation vhServiceListener
-(NSMutableArray *)socketServerArr{
    if(_socketServerArr==nil){
        _socketServerArr=[NSMutableArray array];
    }
    return _socketServerArr;
}

-(void)start{
    
    GCDAsyncSocket *async=[[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    NSError *err=nil;
    [async acceptOnPort:5588 error:&err];
    if(err==nil){
        NSLog(@"211无err信息,成功");
    }
    else{
        NSLog(@"211错误,%@",err);
    }
    self.socketAsync=async;
    
}

-(void)socket:(GCDAsyncSocket *)serverSocket   didAcceptNewSocket:(GCDAsyncSocket *)clientSocket{
    NSLog(@"server信息==%@,client信息==%@",serverSocket,clientSocket);
    
    [self.socketServerArr addObject:clientSocket];//增加客户端到数组中
    
    NSMutableString *arrStr=[NSMutableString string];
    [ arrStr appendString:  @"211欢迎你\n" ];
    [ arrStr appendString: @"[1]在线充值\n" ];
    [ arrStr appendString:   @"[2]在线投拆\n" ];
    [ arrStr appendString:  @"[3]优惠信息\n" ];
    [ arrStr appendString:    @"[4]人工服务\n" ];
    [ arrStr appendString:   @"[5]退出 \n" ];
    
    [clientSocket writeData:[arrStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [clientSocket readDataWithTimeout:-1 tag:0];//-1代表不超时,tag标识作用
}

-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag{
    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收在客户端的信息==%@",str);
    NSInteger code=[str integerValue];
    NSString *responseStr=nil;
    switch (code) {
        case 1:
            responseStr=@"好的\n";
            break;
        case 2:
             responseStr=@"投拆谁呀\n";
            break;
        case 3:
           responseStr=@"暂无\n";
            break;
        case 4:
            responseStr=@"无人接听中\n";
            break;
        case 5:
            responseStr=@"退出ing\n";
            break;
        default:
            break;
    }
    
    [clientSocket writeData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    if(code==5){
        [self.socketServerArr removeObject:clientSocket];
    }
    
#warning 每次读完数据后,都要调用一次监听的方法
    [clientSocket readDataWithTimeout:-1 tag:0];
}
@end

















