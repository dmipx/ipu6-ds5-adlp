format="UYVY"
format_ir="SGRBG8"
format_ir="UYVY"
format_meta="UYVY"
format_imu="RAW8"
#resolusion_depth="640x480"
resolusion_depth="848x480"
#resolusion_depth="1280x720"
resolusion_rgb="640x480"
#resolusion_rgb="848x480"
#resolusion_rgb="1280x720"
#resolusion_ir="640x480"
resolusion_ir="848x480"
#resolusion_ir="1280x720"
#resolusion_meta="1280x4"
resolusion_meta="640x480"
resolusion_meta="640x1"
resolusion_imu="32x1"
# DS5 MUX. Can be {a, b, c, d}.
mux=${1:-'a'}

#media-ctl -r
declare -A media_mux_capture_link=( [a]='' [b]='1 ' [c]='2 ' [d]='3 ' )
declare -A media_mux_csi2_link=( [a]=0 [b]=1 [c]=2 [d]=3 )

#declare -A media_mux_capture_link=( [c]='' [b]='1 ' [a]='2 ' [d]='3 ' )
#declare -A media_mux_csi2_link=( [c]=0 [b]=1 [a]=2 [d]=3 )


declare -A serdes_mux_i2c_bus=( [a]=2 [b]=2 [c]=4 [d]=4 )

csi2_be_soc="CSI2 BE SOC ${media_mux_csi2_link[${mux}]}"

csi2="CSI-2 ${media_mux_csi2_link[${mux}]}"

be_soc_cap="BE SOC ${media_mux_capture_link[${mux}]}capture"

media-ctl -v -l "\"Intel IPU6 ${csi2}\":1 -> \"Intel IPU6 ${csi2_be_soc}\":0[1]"

media-ctl -v -l "\"D4XX depth ${mux}\":0 -> \"DS5 mux ${mux}\":1[1]"
media-ctl -v -l "\"DS5 mux ${mux}\":0 -> \"Intel IPU6 ${csi2}\":0[1]"

# video streaming node
media-ctl -v -l "\"Intel IPU6 ${csi2_be_soc}\":1 -> \"Intel IPU6 ${be_soc_cap} 0\":0[5]"
# metadata node
media-ctl -v -l "\"Intel IPU6 ${csi2_be_soc}\":2 -> \"Intel IPU6 ${be_soc_cap} 1\":0[5]"

media-ctl -v -l "\"D4XX rgb ${mux}\":0 -> \"DS5 mux ${mux}\":2[1]"
media-ctl -v -l "\"DS5 mux ${mux}\":0 -> \"Intel IPU6 ${csi2}\":0[1]"

media-ctl -v -l "\"Intel IPU6 ${csi2_be_soc}\":3 -> \"Intel IPU6 ${be_soc_cap} 2\":0[5]"
media-ctl -v -l "\"Intel IPU6 ${csi2_be_soc}\":4 -> \"Intel IPU6 ${be_soc_cap} 3\":0[5]"

media-ctl -v -l "\"D4XX motion detection ${mux}\":0 -> \"DS5 mux ${mux}\":3[1]"
media-ctl -v -l "\"DS5 mux ${mux}\":0 -> \"Intel IPU6 ${csi2}\":0[1]"

media-ctl -v -l "\"Intel IPU6 ${csi2_be_soc}\":5 -> \"Intel IPU6 ${be_soc_cap} 4\":0[5]"

# IMU link
media-ctl -v -l "\"D4XX imu ${mux}\":0 -> \"DS5 mux ${mux}\":4[1]"
media-ctl -v -l "\"Intel IPU6 ${csi2_be_soc}\":6 -> \"Intel IPU6 ${be_soc_cap} 5\":0[5]"


##########################################
# SET FORMATS
##########################################

#media-ctl -v -V "\"D4XX depth ${mux}\":0 [fmt:$format/$resolusion_depth]"
#media-ctl -v -V "\"DS5 mux ${mux}\":1 [fmt:$format/$resolusion_depth]"
#media-ctl -v -V "\"DS5 mux ${mux}\":0 [fmt:$format/$resolusion_depth]"
##media-ctl -v -V "\"Intel IPU6 CSI-2 1\":0 [fmt:$format/$resolusion_depth]"
##media-ctl -v -V "\"Intel IPU6 CSI-2 1\":1 [fmt:$format/$resolusion_depth]"
#media-ctl -v -V "\"Intel IPU6 ${csi2_be_soc}\":0 [fmt:$format/$resolusion_depth]"
#media-ctl -v -V "\"Intel IPU6 ${csi2_be_soc}\":1 [fmt:$format/$resolusion_depth]"
#media-ctl -v -V "\"Intel IPU6 ${csi2_be_soc}\":2 [fmt:$format_meta/$resolusion_meta crop:(0,0)/$resolusion_meta]"
#media-ctl -v -V "\"Intel IPU6 ${be_soc_cap} 0\":0 [fmt:$format/$resolusion_depth]"
#media-ctl -v -V "\"Intel IPU6 ${be_soc_cap} 1\":0 [fmt:$format_meta/$resolusion_meta]"

#media-ctl -v -V "\"D4XX rgb ${mux}\":0 [fmt:$format/$resolusion_rgb]"
#media-ctl -v -V "\"DS5 mux ${mux}\":2 [fmt:$format/$resolusion_rgb]"
#media-ctl -v -V "\"DS5 mux ${mux}\":0 [fmt:$format/$resolusion_rgb]"
##media-ctl -v -V "\"Intel IPU6 CSI-2 1\":0 [fmt:$format/$resolusion_rgb]"
#media-ctl -v -V "\"Intel IPU6 ${csi2_be_soc}\":3 [fmt:$format/$resolusion_rgb crop:(0,0)/$resolusion_rgb]]"
##media-ctl -v -V "\"Intel IPU6 ${csi2_be_soc}\":4 [fmt:$format_meta/$resolusion_meta]"
#media-ctl -v -V "\"Intel IPU6 ${csi2_be_soc}\":4 [fmt:$format_meta/$resolusion_meta crop:(0,0)/$resolusion_meta]]"
#media-ctl -v -V "\"Intel IPU6 ${be_soc_cap} 2\":0 [fmt:$format/$resolusion_rgb]"
#media-ctl -v -V "\"Intel IPU6 ${be_soc_cap} 3\":0 [fmt:$format_meta/$resolusion_meta]"

#media-ctl -v -V "\"D4XX motion detection ${mux}\":0 [fmt:$format_ir/$resolusion_ir]"
#media-ctl -v -V "\"DS5 mux ${mux}\":3 [fmt:$format_ir/$resolusion_ir]"
#media-ctl -v -V "\"DS5 mux ${mux}\":0 [fmt:$format_ir/$resolusion_ir]"
##media-ctl -v -V "\"Intel IPU6 CSI-2 1\":0 [fmt:$format_ir/$resolusion_ir]"
##media-ctl -v -V "\"Intel IPU6 CSI-2 1\":1 [fmt:$format_ir/$resolusion_ir]"
#media-ctl -v -V "\"Intel IPU6 ${csi2_be_soc}\":5 [fmt:$format_ir/$resolusion_ir]"
#media-ctl -v -V "\"Intel IPU6 ${be_soc_cap} 4\":0 [fmt:$format_ir/$resolusion_ir]"

##########################################


./SerDes_D457.sh ${serdes_mux_i2c_bus[${mux}]}

SUBDEV_NAME=$(media-ctl -e "DS5 mux ${mux}")
echo DS5: $SUBDEV_NAME
DEV_NAME=$(media-ctl -e "Intel IPU6 ${be_soc_cap} 0")
echo DEPTH: $DEV_NAME
v4l2-ctl -d $DEV_NAME -c enumerate_graph_link=1
#./yavta -c0 -n3 -x0 $DEV_NAME $SUBDEV_NAME --file=./frame-depth-a-#.yuv --log-status --size $resolusion_depth --format $format &
DEV_NAME=$(media-ctl -e "Intel IPU6 ${be_soc_cap} 1")
echo DEPTH-MD: $DEV_NAME
#./yavta -c$frame_nums -n3 $DEV_NAME --file=./frame-depth-meta-a-#.meta --log-status --size $resolusion_meta --format $format_meta &
DEV_NAME=$(media-ctl -e "Intel IPU6 ${be_soc_cap} 2")
echo RGB: $DEV_NAME
v4l2-ctl -d $DEV_NAME -c enumerate_graph_link=1
#./yavta -c0 -n3 -x1 $DEV_NAME $SUBDEV_NAME --file=./frame-rgb-a-#.yuv --log-status --size $resolusion_rgb --format $format &
DEV_NAME=$(media-ctl -e "Intel IPU6 ${be_soc_cap} 3")
echo RGB-MD: $DEV_NAME
#./yavta -c$frame_nums -n3 $DEV_NAME --file=./frame-rgb-meta-a-#.meta --log-status --size $resolusion_meta --format $format_meta &
DEV_NAME=$(media-ctl -e "Intel IPU6 ${be_soc_cap} 4")
echo IR: $DEV_NAME
v4l2-ctl -d $DEV_NAME -c enumerate_graph_link=1
#./yavta -c0 -n3 -x2 $DEV_NAME $SUBDEV_NAME --file=./frame-ir-a-#.raw --log-status --size $resolusion_ir --format $format_ir &

