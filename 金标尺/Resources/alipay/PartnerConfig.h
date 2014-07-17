//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088301025848650"
//收款支付宝账号
#define SellerID  @"cqdingwei@163.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"f962dlhxu9pk4vysjw7ydnlxx2dpadia"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMJ5PRHuHo1XNElNOUQoP+RViWp5jWeF8HppsNEcp2mlpZPnA8szHJiIgTeaux3NjveraLa/19rbxiCgxQYb50cstkQscJwMv6YGzdzjCmBQIi1NsLVu4coWbYD//L2T8fYXs7GymeATaIfwiqztiItvAGj+n0h89N3ZqtVh4xhdAgMBAAECgYBRX+fU+92e6PGBBqZCxdDOW5hvjENGIT6aCmWpaqMGywB43f6xZUa+8MeZG87WTrBXJEthxO6urq2982feAYkJfSm1mwlHk+dg8XIh6fhrneW530+eV21gAluFAYMamrTmLUN2Xmb3DWF1QT05jzfD1wwOLC9yZvwskmIeefC7YQJBAO3Agt3vuZ1IMarv2SXeLLyvNn6FkP32MHi3HuDewu9RbGqaPlRswZbNkDO/+tyw67QhlSiT19ymaGQfKJFiCEkCQQDRZl4+WsW6Vee3RvBxK+NPBym7ipH/uVXJ7bDt5DPGxUqr0uhi4Mo+DfZlYa0WAs7krxNjWwk03Kg80+ACINd1AkAJWyELQMrKILQrqOKftd2G01JOqkzpYY3IwlQJv1pmdorQqx82zUzU9WPuVWi21JOB9Cxde2vsN/Q1tHAxQG1ZAkEAn//0Kvj49HQHZcdSmWbLfOsgPCiZfiiDIJP6CQvBdDPz5m51GnhgkCHjD3we4R6sL5iG2/gHhNjFxBSwqW+msQJBAIMN5D/c195bETlnGocHQ4K5YVL8GwfeGQmQQ4L55V5JcdCp9f6zyPW3rZZnyEjtraAUcTy7dW3COIlVXLxkC5U="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
