#!/bin/bash
#############
# Overlay four movies into four quadrants to make one composite movie
# Uses avconv
# Brent Maranzano
# February 20, 2015
# Usage:
#$overlay file1.mp4 file2.mp4 file3.mp4 file4.mp4 scale_factor speed

scale=${5}
speed=${6}

avconv -i ${1} -i ${2} -i ${3} -i ${4} -filter_complex "[0:v] setpts=${speed}*${speed}*PTS-STARTPTS, pad=iw*2.5:ih*2.5:ih*0:iw*0, scale=iw*${scale}:ih*${scale}:iw [ul]; [1:v] setpts=${speed}*${speed}*PTS-STARTPTS, scale=iw*${scale}:ih*${scale} [ur]; [2:v] setpts=${speed}*${speed}*PTS-STARTPTS, scale=iw*${scale}:ih*${scale} [ll]; [3:v] setpts=${speed}*${speed}*PTS-STARTPTS, scale=iw*${scale}:ih*${scale} [lr]; [ul][ur] overlay=main_w*${scale}*1.1:main_h*0.0 [out]; [out][ll] overlay=main_w*0.0:main_h*${scale}*1.1 [out]; [out][lr] overlay=main_w*${scale}*1.1:main_h*${scale}*1.1" output.mp4
