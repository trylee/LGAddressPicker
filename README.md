# LGAddressPicker
####高仿京东商城App地址选择器，可以加载本地的地址plist文件，具体实现效果如下：

![AddressPicker](https://github.com/trylee/Pictures/blob/master/AddressPicker.gif)

####使用方法：
---
- 将Demo中的`LGAddressPicker`文件夹拖到项目中，并在需要选择地址的控制器中引入头文件

```objc
#import "LGAddressPicker.h"
```
---
- 在`viewDidLoad`方法中设置文本输入框的inputview为该地址选择器，传入选择器高度，选择完成的回调和取消选择的回调，代码如下：


```objc
__weak typeof(self) weakSelf = self;
    self.addressTF.inputView = [LGAddressPicker addressPickerWithHeight:-200 PickOver:^(NSDictionary *addressDict) {
        
        NSLog(@"地区选择完毕！");
         [weakSelf.addressTF endEditing:YES];
        weakSelf.addressTF.text = [NSString stringWithFormat:@"%@%@%@",addressDict[@"province"], addressDict[@"city"], addressDict[@"area"]];
        
    } PickCancel:^{
        
        NSLog(@"您已取消选择地区！");
        [weakSelf.addressTF endEditing:YES];
        
    }];
```

---
####Tips:
- 在处理选择完成的回调时，返回给一个地区字典，需要自己根据key取值，省"province"、市“city”、区“area”`

- 如果plist文件中地址不正确，可以直接修改plist文件。

- 当前只解决了加载本地plist地址文件，没有实现选择服务端请求到的地址功能，后期改进
