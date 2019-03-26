<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>Chart</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="./static/js/html2canvas.js"></script>
    <script src="./static/js/jsPdf.debug.js"></script>
    <style>
        .daohang {
            height: 95%;
            background-color: #4d4d4d;
        }

        .chart {
            height: 710px;
        }
    </style>
</head>
<body>
<div style="height: 43px; background-color: #1e94f3">
    title
    <button onclick="exportPdf('charts', 'test')">pdf</button>
</div>
<div>
    <div class="row">
        <jsp:include page="navigation.jsp"/>
        <div class="col-md-10 chart" id="charts">
            <div class="row">
                <div class="col-md-3 scrIP" id="src_ip" style="height: 300px;">
                    <!-- 来源ip饼形图 -->
                </div>
                <div class="col-md-3 scrPort" id="src_port" style="height: 300px;">
                    <!-- 来源port饼形图 -->
                </div>
                <div class="col-md-3 descIP" id="dest_ip" style="height: 300px;">
                    <!-- 目的ip饼形图 -->
                </div>
                <div class="col-md-3 descPort" id="dest_port" style="height: 300px;">
                    <!-- 目的port饼形图 -->
                </div>
                <div class="col-md-12 category" id="category" style="height: 420px;">
                    <!-- 柱状图 -->
                </div>
            </div>
        </div>

    </div>
</div>
<script type="text/javascript" src="./static/js/echarts.min.js"></script>
<script type="text/javascript">

    pie1();
    pie2();
    pie3();
    pie4();
    category();

    //来源ip的饼形图
    function pie1() {
        var dom = document.getElementById("src_ip");
        var myChart = echarts.init(dom);
        var app = {};
        option = null;
        option = {
            title: {
                text: 'Top 20 scrip',
                x: 'left',
                textStyle: {
                    fontSize: '10'
                }
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                type: 'scroll',
                pageButtonPosition: 'end',
                orient: 'vertical',
                left: 'right',
                data: ${top20scrIP_key},
                x: 'left'
            },
            series: [
                {
                    name: '来源IP',
                    type: 'pie',
                    radius: '55%',
                    center: ['30%', '60%'],
                    data: ${top20scrIP},
                    itemStyle: {
                        emphasis: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        },
                        normal: {
                            label: {
                                show: false
                            }
                        }
                    }
                }
            ]
        };
        if (option && typeof option === "object") {
            myChart.setOption(option, true);
        }
    }

    //来源port的饼形图
    function pie2() {
        var dom = document.getElementById("src_port");
        var myChart = echarts.init(dom);
        var app = {};
        option = null;
        option = {
            title: {
                text: 'Top 20 scrPort',
                x: 'left',
                textStyle: {
                    fontSize: '10'
                }
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                type: 'scroll',
                orient: 'vertical',
                left: 'right',
                data: ${top20scrPort_key}
            },
            series: [
                {
                    name: '访问来源',
                    type: 'pie',
                    radius: '55%',
                    center: ['30%', '60%'],
                    data: ${top20scrPort},
                    itemStyle: {
                        emphasis: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        },
                        normal: {
                            label: {
                                show: false
                            }
                        }
                    }
                }
            ]
        };
        if (option && typeof option === "object") {
            myChart.setOption(option, true);
        }
    }

    //目的ip的饼形图
    function pie3() {
        var dom = document.getElementById("dest_ip");
        var myChart = echarts.init(dom);
        var app = {};
        option = null;
        option = {
            title: {
                text: 'Top 20 descip',
                x: 'left',
                textStyle: {
                    fontSize: '10'
                }
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                type: 'scroll',
                orient: 'vertical',
                left: 'right',
                data: ${top20descIP_key}
            },
            series: [
                {
                    name: '访问来源',
                    type: 'pie',
                    radius: '55%',
                    center: ['30%', '60%'],
                    data: ${top20descIP},
                    itemStyle: {
                        emphasis: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        },
                        normal: {
                            label: {
                                show: false
                            }
                        }
                    }
                }
            ]
        };
        if (option && typeof option === "object") {
            myChart.setOption(option, true);
        }
    }

    //目的端口的饼形图
    function pie4() {
        var dom = document.getElementById("dest_port");
        var myChart = echarts.init(dom);
        var app = {};
        option = null;
        option = {
            title: {
                text: 'Top 20 scrip',
                x: 'left',
                textStyle: {
                    fontSize: '10'
                }
            },
            tooltip: {
                trigger: 'item',
                formatter: "{a} <br/>{b} : {c} ({d}%)"
            },
            legend: {
                type: 'scroll',
                orient: 'vertical',
                left: 'right',
                data: ${top20descPort_key}
            },
            series: [
                {
                    name: '访问来源',
                    type: 'pie',
                    radius: '55%',
                    center: ['30%', '60%'],
                    data: ${top20descPort},
                    itemStyle: {
                        emphasis: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        },
                        normal: {
                            label: {
                                show: false
                            }
                        }
                    }
                }
            ]
        };
        if (option && typeof option === "object") {
            myChart.setOption(option, true);
        }
    }

    function category() {
        var dom = document.getElementById("category");
        var myChart = echarts.init(dom);
        var app = {};
        option = null;
        app.title = '坐标轴刻度与标签对齐';

        option = {
            color: ['#3398DB'],
            title: {
                text: '各个月日志总览',
                subtext: 'Feature Sample: Gradient Color, Shadow, Click Zoom'
            },
            tooltip: {
                trigger: 'axis',
                axisPointer: {            // 坐标轴指示器，坐标轴触发有效
                    type: 'line'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            xAxis: [
                {
                    type: 'category',
                    data: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'],
                    axisTick: {
                        alignWithLabel: true
                    }
                }
            ],
            yAxis: [
                {
                    type: 'value'
                }
            ],
            series: [
                {
                    name: '直接访问',
                    type: 'bar',
                    data: [220, 182, 191, 234, 290, 330, 310, 123, 442, 321, 90, 149]
                }
            ]
        };
        if (option && typeof option === "object") {
            myChart.setOption(option, true);
        }
    }

    //导出pdf
    function exportPdf(id, name) {
        html2canvas($("#" + id), {
            allowTaint: true,//允许跨域，具体啥意思不清楚
            height: document.getElementById(id).scrollHeight,//
            width: document.getElementById(id).scrollWidth,//为了使横向滚动条的内容全部展示，这里必须指定
            background: "#FFFFFF",//如果指定的div没有设置背景色会默认成黑色,这里是个坑
            onrendered: function (canvas) {

                var contentWidth = canvas.width;
                var contentHeight = canvas.height;

                //一页pdf显示html页面生成的canvas高度;
                var pageHeight = contentWidth / 595.28 * 841.89;
                //未生成pdf的html页面高度
                var leftHeight = contentHeight;
                //pdf页面偏移
                var position = 0;
                //a4纸的尺寸[595.28,841.89]，html页面生成的canvas在pdf中图片的宽高
                var imgWidth = 555.28;
                var imgHeight = 555.28 / contentWidth * contentHeight;

                var pageData = canvas.toDataURL('image/jpeg', 1.0);

                var pdf = new jsPDF('p', 'pt', 'a4');
                //有两个高度需要区分，一个是html页面的实际高度，和生成pdf的页面高度(841.89)
                //当内容未超过pdf一页显示的范围，无需分页
                if (leftHeight < pageHeight) {
                    pdf.addImage(pageData, 'JPEG', 20, 0, imgWidth, imgHeight);
                } else {
                    while (leftHeight > 0) {
                        pdf.addImage(pageData, 'JPEG', 20, position, imgWidth, imgHeight)
                        leftHeight -= pageHeight;
                        position -= 841.89;
                        //避免添加空白页
                        if (leftHeight > 0) {
                            pdf.addPage();
                        }
                    }
                }
                pdf.save(name + '.pdf');
            }
        })
    };

    $(document.body).css({
        "overflow-x": "hidden"
    });
</script>
</body>
</html>