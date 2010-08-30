<?php
if(isset($submit) && $submit){
	$top =  "/datamart/reports/nb_consent_by_month/";
	$links = array(
		"top" => $top,
		"bottom" => array("cancel" => "/datamart/reports/index"));
	$override = array("0.action" => array(" " => __("visualize", true), "true" => __("export as CSV file (comma-separated values)", true)));
	$structures->build($atim_structure, array("type" => "search", "links" => $links, 'settings' => array('header' => __('report title', NULL).' : '.__('consents by month', NULL), 'description' => __('consents by month description', NULL)), "override" => $override));
	?>
	<script type="text/javascript">
	var actionControl = "<?php echo($top); ?>";
	</script>
	<?php
}else{
	$month = AppController::getCalInfo(false);
	list($year_from, $month_from) = explode("-", $date_from);
	list($year_to, $month_to) = explode("-", $date_to);
	$data = array();
	$data[] = array(__("month", true), __("obtained consents", true));
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
				"title" => __('report title', NULL).' : '.__('consents by month', NULL), 
				"description" => __('consents by month description', NULL) . sprintf(" From %s to %s", $month[(int)$month_from]." ".$year_from, $month[(int)$month_to]." ".$year_to)),		
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