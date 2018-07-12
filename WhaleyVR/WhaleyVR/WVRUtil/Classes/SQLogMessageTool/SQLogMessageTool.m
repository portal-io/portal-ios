//
//  SQLogMessageTool.m
//  QBDemo
//
//  Created by qbshen on 2016/12/15.
//  Copyright © 2016年 qbshen. All rights reserved.
//

#import "SQLogMessageTool.h"
#import <asl.h>
#import <HTTPServer.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include<arpa/inet.h>
#include<net/if.h>
#import <WebSocket.h>
#import <HTTPMessage.h>
#import <GCDAsyncSocket.h>
#import "WVRCocoaHttpServerHeader.h"

@interface SQLogMessageTool ()

@property (nonatomic) HTTPServer* httpServer;

@end


@implementation SQLogMessageTool

+ (instancetype)shareInstance
{
    static SQLogMessageTool * tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [SQLogMessageTool new];
    });
    return tool;
}

+ (NSMutableArray<SQSystemLogMessage *> *)allLogMessagesForCurrentProcess
{
    asl_object_t query = asl_new(ASL_TYPE_MSG);
    
    // Filter for messages from the current process. Note that this appears to happen by default on device, but is required in the simulator.
    NSString *pidString = [NSString stringWithFormat:@"%d", [[NSProcessInfo processInfo] processIdentifier]];
    asl_set_query(query, ASL_KEY_PID, [pidString UTF8String], ASL_QUERY_OP_EQUAL);
    
    aslresponse response = asl_search(NULL, query);
    aslmsg aslMessage = NULL;
    
    NSMutableArray *logMessages = [NSMutableArray array];
    while ((aslMessage = asl_next(response))) {
        [logMessages addObject:[self logMessageFromASLMessage:aslMessage]];
    }
    asl_release(response);
    
    return logMessages;
}


//这个是怎么从日志的对象aslmsg中获取我们需要的数据
+ (SQSystemLogMessage *)logMessageFromASLMessage:(aslmsg)aslMessage
{
    SQSystemLogMessage *logMessage = [[SQSystemLogMessage alloc] init];
    
    const char *timestamp = asl_get(aslMessage, ASL_KEY_TIME);
    if (timestamp) {
        NSTimeInterval timeInterval = [@(timestamp) integerValue];
        const char *nanoseconds = asl_get(aslMessage, ASL_KEY_TIME_NSEC);
        if (nanoseconds) {
            timeInterval += [@(nanoseconds) doubleValue] / NSEC_PER_SEC;
        }
        logMessage.timeInterval = timeInterval;
        logMessage.date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    
    const char *sender = asl_get(aslMessage, ASL_KEY_SENDER);
    if (sender) {
        logMessage.sender = @(sender);
    }
    
    const char *messageText = asl_get(aslMessage, ASL_KEY_MSG);
    if (messageText) {
        logMessage.messageText = @(messageText);//NSLog写入的文本内容
    }
    
    const char *messageID = asl_get(aslMessage, ASL_KEY_MSG_ID);
    if (messageID) {
        logMessage.messageID = [@(messageID) longLongValue];
    }
    
    return logMessage;
}

#define kMinRefreshDelay 500  // In milliseconds

//- (void)openHttpServer {
//    self.httpServer = [[HTTPServer alloc] init];
//    [self.httpServer setType:@"_http._tcp."];  // 设置服务类型
//        [self.httpServer setPort:8080]; // 设置服务器端口
//    
//    // 设置服务器路径
////    [self.httpServer setDocumentRoot:webPath];
//    NSError *error;
//    if(![self.httpServer start:&error])
//    {
//        NSLog(@"-------------\nError starting HTTP Server: %@\n", error);
//    }
//    else {
//        NSLog(@"port %hu",[self.httpServer listeningPort]);
//        
//    }
//}

+ (void)saveLogMsgToWeb
{
    NSString *webPath = SQCocoaHttpServerRoot;
    NSString *filePath = [webPath stringByAppendingPathComponent:@"log.html"];
    NSString * msgs = [SQLogMessageTool createResponseBody];
    BOOL fileExists = NO, removeSuccess = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    fileExists = [fileManager fileExistsAtPath:filePath];
    NSError * writeError = nil;
    if (fileExists) {
        removeSuccess = [fileManager removeItemAtPath:filePath error:&writeError];
    }
    
    if (writeError) { NSLog(@"remove log.html %@", writeError); }
    
    [msgs writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&writeError];

    if (writeError) { NSLog(@"write log.html %@", writeError); }
}

//当浏览器请求的时候,返回一个由日志信息组装成的html返回给浏览器
+ (NSString *)createResponseBody {
   
    //NSLog(@"path = %@,query = %@",path,query);
    NSMutableString* string;
//    if ([path isEqualToString:@"/"]) {
        string = [[NSMutableString alloc] init];
        [string appendString:@"<!DOCTYPE html><html lang=\"en\">"];
        [string appendString:@"<head><meta charset=\"utf-8\"></head>"];
        [string appendFormat:@"<title>%s[%i]</title>", getprogname(), getpid()];
        [string appendString:@"<style>\
         body {\n\
         margin: 0px;\n\
         font-family: Courier, monospace;\n\
         font-size: 0.8em;\n\
         }\n\
         table {\n\
         width: 100%;\n\
         border-collapse: collapse;\n\
         }\n\
         tr {\n\
         vertical-align: top;\n\
         }\n\
         tr:nth-child(odd) {\n\
         background-color: #eeeeee;\n\
         }\n\
         td {\n\
         padding: 2px 10px;\n\
         }\n\
         #footer {\n\
         text-align: center;\n\
         margin: 20px 0px;\n\
         color: darkgray;\n\
         }\n\
         .error {\n\
         color: red;\n\
         font-weight: bold;\n\
         }\n\
         </style>"];
        [string appendFormat:@"<script type=\"text/javascript\">\n\
         var refreshDelay = %i;\n\
         var footerElement = null;\n\
         function updateTimestamp() {\n\
         var now = new Date();\n\
         footerElement.innerHTML = \"Last updated on \" + now.toLocaleDateString() + \" \" + now.toLocaleTimeString();\n\
         }\n\
         function refresh() {\n\
         var timeElement = document.getElementById(\"maxTime\");\n\
         var maxTime = timeElement.getAttribute(\"data-value\");\n\
         timeElement.parentNode.removeChild(timeElement);\n\
         \n\
         var xmlhttp = new XMLHttpRequest();\n\
         xmlhttp.onreadystatechange = function() {\n\
         if (xmlhttp.readyState == 4) {\n\
         if (xmlhttp.status == 200) {\n\
         var contentElement = document.getElementById(\"content\");\n\
         contentElement.innerHTML = contentElement.innerHTML + xmlhttp.responseText;\n\
         updateTimestamp();\n\
         setTimeout(refresh, refreshDelay);\n\
         } else {\n\
         footerElement.innerHTML = \"<span class=\\\"error\\\">Connection failed! Reload page to try again.</span>\";\n\
         }\n\
         }\n\
         }\n\
         xmlhttp.open(\"GET\", \"/log?after=\" + maxTime, true);\n\
         xmlhttp.send();\n\
         }\n\
         window.onload = function() {\n\
         footerElement = document.getElementById(\"footer\");\n\
         updateTimestamp();\n\
         setTimeout(refresh, refreshDelay);\n\
         }\n\
         </script>", kMinRefreshDelay];
        [string appendString:@"</head>"];
        [string appendString:@"<body>"];
        [string appendString:@"<table><tbody id=\"content\">"];
        [self _appendLogRecordsToString:string afterAbsoluteTime:0.0];
        
        [string appendString:@"</tbody></table>"];
        [string appendString:@"<div id=\"footer\"></div>"];
        [string appendString:@"</body>"];
        [string appendString:@"</html>"];
    
//    else if ([path isEqualToString:@"/log"] && query[@"after"]) {
//        string = [[NSMutableString alloc] init];
//        double time = [query[@"after"] doubleValue];
//        [self _appendLogRecordsToString:string afterAbsoluteTime:time];
    
//    }
//    else {
//        string = [@" <html><body><p>无数据</p></body></html>" mutableCopy];
//    }
    if (string == nil) {
        string = [NSMutableString string];
    }
    return string;
}

+ (void)_appendLogRecordsToString:(NSMutableString*)string afterAbsoluteTime:(double)time {
    
    __block double maxTime = time;
    NSArray<SQSystemLogMessage *>  *allMsg = [SQLogMessageTool allLogMessagesForCurrentProcess];
    [allMsg enumerateObjectsUsingBlock:^(SQSystemLogMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        const char* style = "color: dimgray;";
        NSString* formattedMessage = [self displayedTextForLogMessage:obj];
        [string appendFormat:@"<tr style=\"%s\">%@</tr>", style, formattedMessage];
        if (obj.timeInterval > maxTime) {
            maxTime = obj.timeInterval ;
        }
    }];
    [string appendFormat:@"<tr id=\"maxTime\" data-value=\"%f\"></tr>", maxTime];
}


+ (NSString *)displayedTextForLogMessage:(SQSystemLogMessage *)msg {
    
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"<td>%@</td> <td>%@</td> <td>%@</td>", msg.date.description, msg.sender, msg.messageText];
    
    return string;
}

@end


@implementation SQSystemLogMessage

@end
