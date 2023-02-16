format="UYVY"
format_ir="SGRBG8"
format_ir="UYVY"
format_meta="UYVY"
resolusion_depth="640x480"
resolusion_depth="848x480"
#resolusion_depth="1280x720"
resolusion_rgb="640x480"
resolusion_rgb="848x480"
resolusion_rgb="1280x720"
resolusion_ir="640x480"
resolusion_ir="848x480"
#resolusion_ir="1280x720"
#resolusion_meta="1280x4"
resolusion_meta="640x480"
resolusion_meta="640x1"
frame_nums=${2:-10}
serdes_bus=${1:-2}
#media-ctl -r

media-ctl -v -l "\"D4XX depth a\":0 -> \"DS5 mux a\":1[1]"
media-ctl -v -l "\"DS5 mux a\":0 -> \"Intel IPU6 CSI-2 0\":0[1]"
media-ctl -v -l "\"Intel IPU6 CSI-2 0\":1 -> \"Intel IPU6 CSI2 BE SOC 0\":0[1]"
media-ctl -v -l "\"Intel IPU6 CSI2 BE SOC 0\":1 -> \"Intel IPU6 BE SOC capture 0\":0[5]"
media-ctl -v -l "\"Intel IPU6 CSI2 BE SOC 0\":2 -> \"Intel IPU6 BE SOC capture 1\":0[5]"

media-ctl -v -l "\"D4XX rgb a\":0 -> \"DS5 mux a\":2[1]"
media-ctl -v -l "\"DS5 mux a\":0 -> \"Intel IPU6 CSI-2 0\":0[1]"
media-ctl -v -l "\"Intel IPU6 CSI-2 0\":1 -> \"Intel IPU6 CSI2 BE SOC 0\":0[1]"
media-ctl -v -l "\"Intel IPU6 CSI2 BE SOC 0\":3 -> \"Intel IPU6 BE SOC capture 2\":0[5]"
media-ctl -v -l "\"Intel IPU6 CSI2 BE SOC 0\":4 -> \"Intel IPU6 BE SOC capture 3\":0[5]"

media-ctl -v -l "\"D4XX motion detection a\":0 -> \"DS5 mux a\":3[1]"
media-ctl -v -l "\"DS5 mux a\":0 -> \"Intel IPU6 CSI-2 0\":0[1]"
media-ctl -v -l "\"Intel IPU6 CSI-2 0\":1 -> \"Intel IPU6 CSI2 BE SOC 0\":0[1]"
media-ctl -v -l "\"Intel IPU6 CSI2 BE SOC 0\":5 -> \"Intel IPU6 BE SOC capture 4\":0[5]"

media-ctl -v -V "\"D4XX depth a\":0 [fmt:$format/$resolusion_depth]"
media-ctl -v -V "\"DS5 mux a\":1 [fmt:$format/$resolusion_depth]"
media-ctl -v -V "\"DS5 mux a\":0 [fmt:$format/$resolusion_depth]"
#media-ctl -v -V "\"Intel IPU6 CSI-2 0\":0 [fmt:$format/$resolusion_depth]"
#media-ctl -v -V "\"Intel IPU6 CSI-2 0\":1 [fmt:$format/$resolusion_depth]"
media-ctl -v -V "\"Intel IPU6 CSI2 BE SOC 0\":0 [fmt:$format/$resolusion_depth]"
media-ctl -v -V "\"Intel IPU6 CSI2 BE SOC 0\":1 [fmt:$format/$resolusion_depth]"
media-ctl -v -V "\"Intel IPU6 CSI2 BE SOC 0\":2 [fmt:$format_meta/$resolusion_meta crop:(0,0)/$resolusion_meta]"
media-ctl -v -V "\"Intel IPU6 BE SOC capture 0\":0 [fmt:$format/$resolusion_depth]"
media-ctl -v -V "\"Intel IPU6 BE SOC capture 1\":0 [fmt:$format_meta/$resolusion_meta]"

media-ctl -v -V "\"D4XX rgb a\":0 [fmt:$format/$resolusion_rgb]"
media-ctl -v -V "\"DS5 mux a\":2 [fmt:$format/$resolusion_rgb]"
media-ctl -v -V "\"DS5 mux a\":0 [fmt:$format/$resolusion_rgb]"
#media-ctl -v -V "\"Intel IPU6 CSI-2 0\":0 [fmt:$format/$resolusion_rgb]"
media-ctl -v -V "\"Intel IPU6 CSI2 BE SOC 0\":3 [fmt:$format/$resolusion_rgb crop:(0,0)/$resolusion_rgb]]"
#media-ctl -v -V "\"Intel IPU6 CSI2 BE SOC 0\":4 [fmt:$format_meta/$resolusion_meta]"
media-ctl -v -V "\"Intel IPU6 CSI2 BE SOC 0\":4 [fmt:$format_meta/$resolusion_meta crop:(0,0)/$resolusion_meta]]"
media-ctl -v -V "\"Intel IPU6 BE SOC capture 2\":0 [fmt:$format/$resolusion_rgb]"
media-ctl -v -V "\"Intel IPU6 BE SOC capture 3\":0 [fmt:$format_meta/$resolusion_meta]"

media-ctl -v -V "\"D4XX motion detection a\":0 [fmt:$format_ir/$resolusion_ir]"
media-ctl -v -V "\"DS5 mux a\":3 [fmt:$format_ir/$resolusion_ir]"
media-ctl -v -V "\"DS5 mux a\":0 [fmt:$format_ir/$resolusion_ir]"
#media-ctl -v -V "\"Intel IPU6 CSI-2 0\":0 [fmt:$format_ir/$resolusion_ir]"
#media-ctl -v -V "\"Intel IPU6 CSI-2 0\":1 [fmt:$format_ir/$resolusion_ir]"
media-ctl -v -V "\"Intel IPU6 CSI2 BE SOC 0\":5 [fmt:$format_ir/$resolusion_ir]"
media-ctl -v -V "\"Intel IPU6 BE SOC capture 4\":0 [fmt:$format_ir/$resolusion_ir]"


./SerDes_D457_a.sh $serdes_bus

SUBDEV_NAME=$(media-ctl -e "DS5 mux a")
echo DS5: $SUBDEV_NAME
DEV_NAME=$(media-ctl -e "Intel IPU6 BE SOC capture 0")
echo DEPTH: $DEV_NAME
v4l2-ctl -d $DEV_NAME -c enumerate_graph_link=1
#./yavta -c0 -n3 -x0 $DEV_NAME $SUBDEV_NAME --file=./frame-depth-a-#.yuv --log-status --size $resolusion_depth --format $format &
DEV_NAME=$(media-ctl -e "Intel IPU6 BE SOC capture 1")
echo DEPTH-MD: $DEV_NAME
#./yavta -c$frame_nums -n3 $DEV_NAME --file=./frame-depth-meta-a-#.meta --log-status --size $resolusion_meta --format $format_meta &
DEV_NAME=$(media-ctl -e "Intel IPU6 BE SOC capture 2")
echo RGB: $DEV_NAME
v4l2-ctl -d $DEV_NAME -c enumerate_graph_link=1
#./yavta -c0 -n3 -x1 $DEV_NAME $SUBDEV_NAME --file=./frame-rgb-a-#.yuv --log-status --size $resolusion_rgb --format $format &
DEV_NAME=$(media-ctl -e "Intel IPU6 BE SOC capture 3")
echo RGB-MD: $DEV_NAME
#./yavta -c$frame_nums -n3 $DEV_NAME --file=./frame-rgb-meta-a-#.meta --log-status --size $resolusion_meta --format $format_meta &
DEV_NAME=$(media-ctl -e "Intel IPU6 BE SOC capture 4")
echo IR: $DEV_NAME
v4l2-ctl -d $DEV_NAME -c enumerate_graph_link=1
#./yavta -c0 -n3 -x2 $DEV_NAME $SUBDEV_NAME --file=./frame-ir-a-#.raw --log-status --size $resolusion_ir --format $format_ir &

