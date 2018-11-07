<textarea cols=50 rows=40></textarea>
<button onclick='testLatency(true);'>Launch Hammer</button>
<button onclick='testLatency(false);'>Launch Normal</button>

<script>
var maxLatency = 0;
var minLatency = 100000000;
var total = 0;
var count = 0;
function testLatency(hammer){
	maxLatency = 0;
	minLatency = 100000000;
	total = 0;
	count = 0;
	//$("button").attr("disabled", true);
	if(hammer){
		for(var i = 1; i < 11; ++ i){
			testLatency2(i);
		}
	}else{
		for(var i = 1; i < 11; ++ i){
			setTimeout("testLatency2(" + i + ")", 1000 * i);
		}
	} 
}

function testLatency2(id){
	var pingTime = new Date();
	$.get(root_url + "Administrate/Versions/latencyTest?id=" + id + "&t=" + (new Date()).getTime(), "", function(data){
            if ($(data)[$(data).length-1].id==="ajaxSqlLog"){
                var ajaxSqlLog={'sqlLog': [$(data.substring (data.lastIndexOf('<div id="ajaxSqlLog"'))).html()]};
                data=data.substring(0, data.lastIndexOf('<div id="ajaxSqlLog"'));
                saveSqlLogAjax(ajaxSqlLog);
            }
            
		var pongTime = new Date();
		var latency = pongTime.getTime() - pingTime.getTime();
		$("textarea").append(id + ": " + (latency) + "ms\r");
		maxLatency = Math.max(maxLatency, latency);
		minLatency = Math.min(minLatency, latency);
		total += latency;
		++ count;
		if(count == 10){
			//end results
			$("textarea").append("---Max: " + maxLatency + "ms ---Min: " + minLatency + "ms ---Avg: " + (total / 10) + "\r");
		}
	});
}
</script>