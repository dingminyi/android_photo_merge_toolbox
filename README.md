# Android Photo Merge Toolbox / 多设备照片整合工具箱
Tool box for merging pictures from different Android/iOS devices on Android

```
Copyright 2023 Minyi Ding

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

这个工具箱是为了解决一个痛点。当你有很多台设备存储着不同的照片，视频，微信图片想要copy到一台设备上时，在目标设备上往往会发生时间线错乱的问题，核心原因在于大部分的Android设备相册是通过 mtime/ctime来判断照片的时间，但是这些时间往往会在多设备间的拷贝中丢失。所以，就需要把照片正确的mtime/ctime时间在目标设备中复现出来。

本工具箱可以支持以下图片来源
## 安卓设备照片，截屏，视频

## 安卓设备微信图片

## 苹果iOS设备导出的图片
