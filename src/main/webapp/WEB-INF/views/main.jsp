<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>redis管理</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css">
    <script src="./static/js/jquery.min.js"></script>
    <script src="./static/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="./static/js/echarts.min.js"></script>
    <style>
        .menu {
            background-color: #4d4d4d;
            height: 720px;
        }
        .alertType {
            height: 250px;
        }
        .alertCount {
            height: 250px;
        }
        .alertLogs {
            height: 437px;
        }
        .chart {
            height: 171.5px;
        }

        #alertModal {
            top: 50%;left: 50%;
            transform: translate(-50%,-50%);
            min-width:60%;
            overflow: visible;
            bottom: inherit;
            right: inherit;
        }
    </style>
</head>
<body>
<div class="row" >
    <div class="col-sm-12" style="height: 43px; background-color: #1e94f3;">
        title
    </div>
    <div class="col-md-12">
        <div class="row">
            <div class="col-md-2 menu">
                <ul class="nav nav-pills nav-stacked">
                    <li class="active"><a href="index.do"><p class="glyphicon glyphicon-dashboard"></p>&emsp;Dashboard</a></li>
                    <li><a href="chart.do"><p class="glyphicon glyphicon-list"></p>&emsp;Chart</a></li>
                </ul>
            </div>
            <div class="col-md-10">
                <div class="row">
                    <div class="col-md-12 input-group rule_input" style="height: 33px">
                        <%--搜索框--%>
                        <input type="text" class="form-control" name="regex">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="button" onclick="search()">
                                Search
                            </button>
                         </span>
                    </div>
                    <div class="col-md-3">
                        <div class="row">
                            <%--四个饼形图--%>
                            <div class="col-md-12 chart"  id="src_ip">
                            </div>
                            <div class="col-md-12 chart"  id="src_port">
                            </div>
                            <div class="col-md-12 chart"  id="dest_ip">
                            </div>
                            <div class="col-md-12 chart"  id="dest_port">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-7 alertType table-responsive">
                        <!--alert-->
                        <table class="table">
                            <thead>
                            <tr>
                                <th>alert.signature</th>
                                <th>Count</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${alertType}" var="alert">
                                <tr>
                                    <td>${alert.key}</td>
                                    <td>${alert.value}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="col-md-2 alertCount">
                        <%--all alert count--%>
                        <div data-toggle="modal" data-target="#modal_all">
                            alert count
                            <div class="text-center article-title all_log">
                                <h2>${allCount}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-9 alertLogs table-responsive">
                        <!--all alert logs-->
                        <hr>
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Time</th>
                                <th>alert.signature</th>
                                <th>src_ip</th>
                                <th>src_port</th>
                                <th>dest_ip</th>
                                <th>dest_port</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${top20Logs}" var="log">
                                <tr>
                                    <td>${log.get("timestamp")}</td>
                                    <td style="display: none">${log.get("alert")}</td>
                                    <td data-toggle="modal" data-target="#alertModal">${log.get("alert").get("signature")}</td>
                                    <td>${log.get("src_ip")}</td>
                                    <td>${log.get("src_port")}</td>
                                    <td>${log.get("dest_ip")}</td>
                                    <td>${log.get("dest_port")}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 模态框（Modal） -->
    <div class="modal fade" id="alertModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"
                            aria-hidden="true">×
                    </button>
                    <h4 class="modal-title" id="myModalLabel">
                        alert
                    </h4>
                </div>
                <input type="text" class="content">
                <div class="modal-footer">
                    <button type="button" class="btn btn-default"
                            data-dismiss="modal">关闭
                    </button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
</div>

<script type="text/javascript">
    pie1();
    pie2();
    pie3();
    pie4();

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
                    center: ['20%', '60%'],
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
        myChart.setOption(option, true);
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
                    center: ['20%', '60%'],
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
        myChart.setOption(option, true);
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
                    center: ['20%', '60%'],
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
        myChart.setOption(option, true);
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
                    center: ['20%', '60%'],
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
        myChart.setOption(option, true);
    }

    $(document.body).css({
        "overflow-x": "hidden"
    });

    function search() {
        var search = {};
        search.regex = $('input[name="regex"]').val();
        $.ajax({
            type: 'GET',
            url: 'index.do',
            data: search,
            success: function (result) {
                window.location.href = "index.do";
            },
            error: function (result) {
                alert("error");
            }
        });
    }

    // 给模态框传值
    $('#alertModal').on('show.bs.modal', function (event) {
        let btnThis = $(event.relatedTarget); //触发事件的按钮
        let modal = $(this);  //当前模态框
        let content = btnThis.closest('tr').find('td').eq(1).text();
        alert(content);
        modal.find(".content").val(content);
    });
</script>
</body>
</html>