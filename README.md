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
# 中文
**请在任何操作前对您的珍贵数据做好备份！**

这个工具箱是为了解决一个痛点。当你有很多台设备存储着不同的照片，视频，微信图片想要copy到一台设备上时，在目标设备上往往会发生时间线错乱的问题，核心原因在于大部分的Android设备相册是通过 mtime/ctime来判断照片的时间，但是这些时间往往会在多设备间的拷贝中丢失。所以，就需要把照片正确的mtime/ctime时间在目标设备中复现出来。

本工具箱可以支持以下图片来源：
## 安卓设备照片，截屏，视频
这类文件有典型的timestamp pattern在文件名中，可以用来set mtime
典型的文件名：
```
20210916_022555.jpg # Samsung DCIM
IMG_20180311_211431.jpg # Huawei DCIM
ScreenShot_20200120_001431327.jpg
```
使用adb在Android设备上执行script [update_mtime_from_timestamp.sh](https://github.com/dingminyi/android_photo_merge_toolbox/blob/main/update_mtime_from_timestamp.sh) 即可。

filelist.txt 的生成方式：
```
find "/folder_path" -type f > filelist.txt
```

## 安卓设备微信图片
这类文件有典型的epoch timestamp pattern在文件名中，可以用来set mtime
典型的文件名
```
mmexport1634290785365.jpg
```
使用adb在Android设备上执行script [update_mtime_from_epoch.sh](https://github.com/dingminyi/android_photo_merge_toolbox/blob/main/update_mtime_from_epoch.sh) 即可。

filelist.txt 的生成方式同上。

## 苹果iOS设备导出的图片
苹果设备上导出的图片视频没有timestamp在文件名里，所以需要在到处设备上(我这里使用的是Mac)预处理一下。
有两种方法：
第一种是直接从Mac Photos导出后保留了正确的mtime，那只要把mtime在Mac上写到文件名里就可以到目标Android设备上使用update_mtime_from_timestamp.sh了
可以使用这个脚本在Mac上执行

[add_timestamp_to_filename_from_mtime.sh](https://github.com/dingminyi/android_photo_merge_toolbox/blob/main/add_timestamp_to_filename_from_mtime.sh)

第二种情况是改对了mtime也没用，因为目标设备相册对于视频读的是mp4文件中的MediaCreateDate（比如小米MIUI），如果这个文件中的时间有问题，解决方式是需要修改文件，这里需要对exiftool的使用有一些理解,此处提供一些样例命令：
```shell
exiftool -api "QuickTimeUTC" "-MediaCreateDate<ContentCreateDate" *.m4v
exiftool -api "QuickTimeUTC" "-TrackCreateDate<ContentCreateDate" *.m4v
exiftool -api "QuickTimeUTC" "-CreateDate<ContentCreateDate" *.m4v
# 检查文件状态
exiftool -time:all -a -s -G1 20191201_223933_IMG_0011.m4v

[System]        FileModifyDate                  : 2023:10:04 03:59:38+08:00
[System]        FileAccessDate                  : 2023:10:04 03:59:40+08:00
[System]        FileInodeChangeDate             : 2023:10:04 03:59:39+08:00
[QuickTime]     CreateDate                      : 2020:03:10 20:15:32
[QuickTime]     ModifyDate                      : 2020:03:10 20:16:49
[Track1]        TrackCreateDate                 : 2019:12:01 14:39:35
[Track1]        TrackModifyDate                 : 2020:03:10 20:16:49
[Track1]        MediaCreateDate                 : 2019:12:01 14:39:35
[Track1]        MediaModifyDate                 : 2020:03:10 20:16:49
[Track2]        TrackCreateDate                 : 2019:12:01 14:39:35
[Track2]        TrackModifyDate                 : 2020:03:10 20:16:49
[Track2]        MediaCreateDate                 : 2019:12:01 14:39:35
[Track2]        MediaModifyDate                 : 2020:03:10 20:16:49
[ItemList]      ContentCreateDate               : 2019:12:01 22:39:35+08:00
```

# English 
**Please back up your precious data before performing any operations!**
This toolbox is designed to resolve a pain point: When you have multiple devices storing photos, videos, and WeChat images that you want to copy to a single destination device, there is often an issue of the timeline getting messed up on the target device photo apps. The root cause for this is that most Android device galleries determine the time of photos using file mtime/ctime, but these times can often be lost during copying between multiple devices. Therefore, it's necessary to reproduce the correct mtime/ctime timestamps for the photos on the target device.

This toolbox can support the following sources of images:

## Android device photos, screenshots, videos
These types of files typically have a timestamp pattern in their filenames that can be used to set the mtime.
Typical filenames:
```
20210916_022555.jpg # Samsung DCIM
IMG_20180311_211431.jpg # Huawei DCIM
ScreenShot_20200120_001431327.jpg
```
use adb to run script on our destination Android device [update_mtime_from_timestamp.sh](https://github.com/dingminyi/android_photo_merge_toolbox/blob/main/update_mtime_from_timestamp.sh)。

filelist.txt generation：
```
find "/folder_path" -type f > filelist.txt
```

## Wechat pics from the Android devices
These types of files typically have a epoch/unix time pattern in their filenames that can be used to set the mtime.
Typical filenames:
```
mmexport1634290785365.jpg
```
use adb to run script on our destination Android device [update_mtime_from_epoch.sh](https://github.com/dingminyi/android_photo_merge_toolbox/blob/main/update_mtime_from_epoch.sh).


## Images and videos exported from Apple iOS devices

Images and videos exported from Apple iOS devices do not have timestamps in their filenames. Therefore, some preprocessing is required on the exporting device (in this case, your Mac). There are two methods:

The first method involves exporting directly from Mac Photos while preserving the correct mtime. In this case, you can simply write the mtime to the filename on your Mac, and then use the "update_mtime_from_timestamp.sh" script on the target Android device. You can execute this script on your Mac.

[add_timestamp_to_filename_from_mtime.sh](https://github.com/dingminyi/android_photo_merge_toolbox/blob/main/add_timestamp_to_filename_from_mtime.sh)

The second scenario is when correcting the mtime alone is not working because the target device's gallery relies on the "MediaCreateDate" metadata from the mp4 files (for example, in Xiaomi MIUI). If the time in this metadata is incorrect, you need to modify the file. This requires some understanding of how to use exiftool. Here are some example commands:
```shell
exiftool -api "QuickTimeUTC" "-MediaCreateDate<ContentCreateDate" *.m4v
exiftool -api "QuickTimeUTC" "-TrackCreateDate<ContentCreateDate" *.m4v
exiftool -api "QuickTimeUTC" "-CreateDate<ContentCreateDate" *.m4v
# check file status
exiftool -time:all -a -s -G1 20191201_223933_IMG_0011.m4v

[System]        FileModifyDate                  : 2023:10:04 03:59:38+08:00
[System]        FileAccessDate                  : 2023:10:04 03:59:40+08:00
[System]        FileInodeChangeDate             : 2023:10:04 03:59:39+08:00
[QuickTime]     CreateDate                      : 2020:03:10 20:15:32
[QuickTime]     ModifyDate                      : 2020:03:10 20:16:49
[Track1]        TrackCreateDate                 : 2019:12:01 14:39:35
[Track1]        TrackModifyDate                 : 2020:03:10 20:16:49
[Track1]        MediaCreateDate                 : 2019:12:01 14:39:35
[Track1]        MediaModifyDate                 : 2020:03:10 20:16:49
[Track2]        TrackCreateDate                 : 2019:12:01 14:39:35
[Track2]        TrackModifyDate                 : 2020:03:10 20:16:49
[Track2]        MediaCreateDate                 : 2019:12:01 14:39:35
[Track2]        MediaModifyDate                 : 2020:03:10 20:16:49
[ItemList]      ContentCreateDate               : 2019:12:01 22:39:35+08:00
```
