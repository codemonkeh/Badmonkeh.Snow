---
layout: post
title: Converting MPEG to H.265
date: 2018-03-14
author: xian
comments: true
categories: Photography
tags: software, tools, video, mpeg, h265
---

# Converting MPEG to H.265

I recently took a video of a friend's performance with my DSLR and only afterwards recalled just how massive MPEG files are. The 1080p clip was only 7 minutes long but was a whopping 1.1GB! A good thing that my camera does not support 4K ;).

Being time poor I fanticised briefly about using Windows Movie Maker which i recall as having a degree of utility, albeit with a lot of restrictions. 

Unfortunately the Windows 10 replacement only supports 720p at best in the free version whic is pretty dismal considering 4K is pretty standard these days and most codecs and encoding tools are open source anyway.

It was then that i remembered `ffmpeg`, a really powerful open source audio/video de/encoder that i had used in the past to encode MPEG1 to either DivX or Xvid.

Sure enough `ffmpeg` is still going strong and has naturally kept pace with the times and allows re-encoding in a number of modern formats.

## Encoding to H.265

So now to the fun part the encoding. I chose encoding to H.265 as it should be about half the file size of H.264 and is a likely successor.

### Process

1. To start download [ffmpeg](https://www.ffmpeg.org/download.html) or you can build it from source.
2. Re-encode it using the following command

    `ffmpeg -i input.mov -c:v libx265 -preset veryslow -crf 18 -c:a aac -strict -2 -b:a 128k output.mp4`
3. Profit

The above command re-encodes your mpeg into a h.265 movie using aac for audio at a very high quality (practically lossless). I should note that whilst this will produce a very high fidelity video, it may take a long time e.g. on my 16 thread machine clocked at 4.5Ghz re-encoding a 7min video took over two hours!

However it did manage to reduce the file size from 1.1GB to 202MB without any visual difference. To further reduce the size you could increase the CRF value, e.g. setting this to 28 produced a 54MB file with very minor quality loss.

### ffmpeg command arguments

So let's break down the arguments provided on the command line above a bit to better understand their impact.

`-i <filename>` - This simply specifies the input filename

`-c:v libx265` - `-c` is an alias for `-codec:v` or `-vcodec` and specifies the encoder to use, in this case lixb265. You could specify libx264 for X.264 encoding.

`-preset veryslow` - This specifies the X.264/265 encoding speed, the slower it encodes the smaller the file size. Set this in the range from `veryslow`, `slower`, `slow`, `medium` (default), `fast`, `faster`, `veryfast`, `superfast` and `ultrafast` depending on your patience ;).

I should note that in the example above, `veryslow` produced a 202MB file after 135 mins but `veryfast` produced a 288MB file after only 4 mins.

`-crf 18` - I am encoding using a constant bitrate because i care more about quality than file size, and this factor determines the output bitrate - and hence the quality. This is a scale between 0-51, where 17/18 is practically lossless and the default is 23. Experiment with higher numbers first to see if they give you an acceptable quality as they will also result in a smaller file with less encoding time.

`-c:a aac` - `-c` is an alias for `-codec:a` or `-acodec` and specifies the audio encoder to use. I should note that the AAC encoder is not open source and included with the static build of ffmpeg so you need to either build it from source or use the command `-strict -2` to use the internal encoder.

`b:a 128k` - This specifies the audio bitrate.

If you want to know all of the options please be sure to read the [ffmpeg documentation](https://ffmpeg.org/ffmpeg.html) or specific encoding documentation for [x.265](https://trac.ffmpeg.org/wiki/Encode/H.265) or [AAC](https://trac.ffmpeg.org/wiki/Encode/AAC).

## Conclusion

I hope this is as useful a reference for you as it is for me ;), let me know in the comments if you have any tips or feedback.