<?php
if(isset($submit) && $submit){
	$top =  "/datamart/reports/nb_consent_by_month/";
	$links = array(
		"top" => $top,
		"bottom" => array("cancel" => "/datamart/reports/index"));
	$override = array("0.action" => array(" " => __("visualize", true), "true" => __("export as CSV file (comma-separated values)", true)));
	$structures->build($atim_structure, array("type" => "search", "links" => $links, "override" => $override));
	?>
	<script type="text/javascript">
	function refreshTop(){
		$("form").attr("action", root_url + "<?php echo($top); ?>" + $("#0Action").val());
	}
	$(function(){
		$($(".adv_ctrl.btn_add_or")[1]).parent().parent().find("select").change(function(){
			refreshTop();
		});
		$(".adv_ctrl.btn_add_or").remove();
	});
	</script>
	<?php
}else{
	$month[1] = __('January', true);
	$month[2] = __('February', true);
	$month[3] = __('March', true);
	$month[4] = __('April', true);
	$month[5] = __('May', true);
	$month[6] = __('June', true);
	$month[7] = __('July', true);
	$month[8] = __('August', true);
	$month[9] = __('September', true);
	$month[10] = __('October', true);
	$month[11] = __('November', true);
	$month[12] = __('December', true);
	list($year_from, $month_from) = explode("-", $date_from);
	list($year_to, $month_to) = explode("-", $date_to);
	$data = array();
	$data[] = array(__("period", true), __("obtained consents", true));
	foreach($this->data as $unit){
		$data[] = array($month[$unit[0]['m']]." ".$unit[0]['y'], $unit[0]['c']);	
	}
	if($csv){
		foreach($data as $line){
			echo(implode(csv_separator, $line)."\n");
		}
		$structures->build( $atim_structure, array('type'=>'csv') );
	}else{
		$settings = array(
			"header" => array(
				"title" => "number of consents obtained by month", 
				"description" => sprintf("shows the number of consents obtained by month from %s to %s", $month[(int)$month_from]." ".$year_from, $month[(int)$month_to]." ".$year_to)),
			"actions" => false);
		$structures->build($atim_structure, array("settings" => $settings));
	
	?>
		<table class="structure">
			<thead>
				<tr>
				<?php 
				echo("<th>".$data[0][0]."</th>");
				echo("<th>".$data[0][1]."</th>");
				array_shift($data);
				?>
				</tr>
			</thead>
			<tbody>
				<?php 
				foreach($data as $line){
					echo("<tr><th>".$line[0]."</th><td align='center'>".$line[1]."</td></tr>\n");	
				}
				?>
			</tbody>
		</table>
		<?php
		$links = array(
			"bottom" => array("cancel" => "/datamart/reports/nb_consent_by_month")); 
		$structures->build($atim_structure, array("links" => $links));
	}
}
