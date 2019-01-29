var createGraph =function(index, isPopup){
    var chartData = charts[index];
    var type = chartData['type'];
    var chartType="";
    if (['linechart'].indexOf(type.toLowerCase())>-1){
        chartType = 'lineChart';
    }else if (['linefocus', 'linewithfocus'].indexOf(type.toLowerCase())>-1){
        chartType =  'lineWithFocusChart';
    }else if (['piechart', 'pie', 'donutchart', 'donut'].indexOf(type.toLowerCase())>-1){
        chartType = 'pieChart';
    }else{
        chartType = type;
    }
    
    var chart;
    try{chart = eval("nv.models."+chartType+"()");}catch(err){return;}
    var i = index;
    nv.addGraph(function () {
        try{chart.useInteractiveGuideline(true);}catch(err){}
        try{chart.x(function (d) {return d[0];});}catch(err){}
        try{chart.y(function (d) {return d[1];});}catch(err){}
        try{chart.color(d3.scale.category10().range());}catch(err){}
        try{chart.duration(300);}catch(err){}
        try{chart.xAxis.axisLabel(getLableX(chartData));}catch(err){}
        try{chart.xAxis.tickFormat(function (d) {return x(d, chartData);});}catch(err){}
        try{chart.yAxis.axisLabel(getLableY(chartData));}catch(err){}
        try{chart.yAxis.tickFormat(function (d) {return y(d, chartData);});}catch(err){}
        try{chart.showTooltipPercent(true);}catch(err){}
        try{chart.padAngle(.008);}catch(err){}
        try{chart.cornerRadius(5);}catch(err){}
        if (['donutchart', 'donut'].indexOf(type.toLowerCase())>-1){
            try{chart.donut(true);}catch(err){}
        }
        try{chart.title(chartData['title']).titleOffset(-10);}catch(err){}

        var element, num;
        num = Math.floor(Math.random()*1000);
        
        if (isPopup){
            element = $('<div class = "chartDivHTMLDialog"><svg></svg></div>');
        }else{
            element = $('.chartDivHTML').eq(i);
        }
        element.attr('id', 'id'+num)
        d3.select(element.children('svg')[0])
            .datum(chartData.data)
            .call(chart);
        if (isPopup){
            element.dialog({
                width: $(window).width() / 2,
                height: $(window).height() / 2,
                open: function (event, ui) {
                    $(this).after($('<a href="javascript:void(0)" class="" role="button"  style="display: inline-block"><span class="ui-icon ui-icon-circle-arrow-s" onclick = "downloadSvg('+num+')">save</span></a>'));
                    $(this).siblings("div.ui-dialog-titlebar").find("span.ui-dialog-title").eq(0).text(chartData['title']);
                    chart.update();
                },
                resizeStop: function( event, ui ) {
                    chart.update();
                }
            });   
        }else{
            $( window ).resize(function() {
                chart.update();
            });
        }
    });

};

function getLableY(charts) {
    return (typeof charts.yAxis === 'undefined' || typeof charts.yAxis.axisLabel === 'undefined') ? "" : charts.yAxis.axisLabel;
}

function getLableX(charts) {
    return (typeof charts.xAxis === 'undefined' || typeof charts.xAxis.axisLabel === 'undefined') ? "" : charts.xAxis.axisLabel;
}

function y(i, charts) {
    if (typeof charts.yAxis === 'undefined' || typeof charts.yAxis.ticks === 'undefined' || typeof charts.yAxis.ticks[i] === 'undefined') {
        return i;
    } else {
        return charts.yAxis.ticks[i];
    }
}

function x(i, charts) {
    if (typeof charts.xAxis === 'undefined' || typeof charts.xAxis.ticks === 'undefined' || typeof charts.xAxis.ticks[i] === 'undefined') {
        return i;
    } else {
        return charts.xAxis.ticks[i];
    }
}

function downloadSvg(num)
{
    svgObj = $('#id'+num).find('svg')[0];
    saveSvgAsPng(svgObj, "diagram.png");
}

document.addEventListener("DOMContentLoaded", function(event) { 
    if (typeof charts !=='undefined' && charts !== '') {
        for (var c in charts){
            if (chartsSettings['popup']){
                $('a.show-chart-popup').eq(c).on('click', {'index':c, 'popup': chartsSettings['popup']}, function(event){
                    createGraph(event.data.index, event.data.popup);
                });
            }else{
                createGraph(c, chartsSettings['popup']);
            }
        }
    }
    setTimeout(function(){
        window.scroll({
            top: 0, 
            left: 0, 
            behavior: 'smooth' 
        });
    }, 100);
});
