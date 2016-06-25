//
//  main.m
//  test211_server
//
//  Created by SunSi on 16/6/25.
//  Copyright © 2016年 SunSi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "vhServiceListener.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    vhServiceListener *listener=   [[vhServiceListener alloc] init];
        [listener start];
        [[NSRunLoop mainRunLoop] run];
    }
    return 0;
}
