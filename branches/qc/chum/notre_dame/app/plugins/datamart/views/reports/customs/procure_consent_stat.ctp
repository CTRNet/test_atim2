<?php
if(isset($submit) && $submit){
	$top =  "/datamart/reports/procure_consent_stat/";
	$links = array(
		"top" => $top,
		"bottom" => array("cancel" => "/datamart/reports/index"));
	$override = array("0.action" => array(" " => __("visualize", true), "true" => __("export as CSV file (comma-separated values)", true)));
	$structures->build($atim_structure, array("type" => "search", "links" => $links, "override" => $override, "settings" => array("header" => __("procure consents stats", true))));
	?>
	<script type="text/javascript">
	var actionControl = "<?php echo($top); ?>";
	</script>
	<?php
}else{
	$months = AppController::getCalInfo(false);
	$months[13] = __('total', true);
	list($year_from, $month_from) = explode("-", $date_from);
	list($year_to, $month_to) = explode("-", $date_to);
	$data = array();
	$keys = array();
	foreach($this->data[0] as $field => $years_arr){
		$data[0][$field] = array();
		foreach($years_arr as $year => $months_arr){
			foreach($months_arr as $month => $value){
				$key = $months[(int)$month]." ".$year;
				$data[0][$field][$key] = $value;
				$keys[$key] = null;
			}
		}
	}
	$keys = array_keys($keys);
	if($csv){
		foreach($data as $line){
			echo(implode(csv_separator, $line)."\n");
		}
		$structures->build( $atim_structure, array('type'=>'csv') );
	}else{
		$settings = array(
			"header" => array(
				"title" => "number of consents obtained by month", 
				"description" => sprintf("shows the number of consents obtained by month from %s to %s", $months[(int)$month_from]." ".$year_from, $months[(int)$month_to]." ".$year_to)),
			"columns_names" => $keys);
		$links = array(
			"bottom" => array("cancel" => "/datamart/reports/nb_consent_by_month"));
		$structures->build($atim_structure, array("settings" => $settings, "links" => $links, "data" => $data));
	}
}
