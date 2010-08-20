<?php
if(isset($submit) && $submit){
	$top =  "/datamart/reports/samples_by_type/";
	$links = array(
		"top" => $top,
		"bottom" => array("cancel" => "/datamart/reports/index"));
	$override = array("0.action" => array(" " => __("visualize", true), "true" => __("export as CSV file (comma-separated values)", true)));
	$structures->build($atim_structure, array("type" => "search", "links" => $links, "override" => $override));
	?>
	<script type="text/javascript">
	var actionControl = "<?php echo($top); ?>";
	</script>
	<?php
}else{
	$data = array();
	$data[] = array(__("sample type", true), __('count', true));
	foreach($my_data as $unit){
		$data[] = array(__($unit['SampleMaster']['sample_type'], true), $unit[0]['c']);
	}
	if($csv){
		foreach($data as $line){
			echo(implode(csv_separator, $line)."\n");
		}
		$structures->build( $atim_structure, array('type'=>'csv') );
	}else{
		$settings = array(
			"header" => array(
				"title" => "number of samples acquired ", 
				"description" => sprintf("show the number of samples acquired from %s to %s", 
					AppController::getFormatedDateString($date_from['year'], $date_from['month'], $date_from['day']),
					AppController::getFormatedDateString($date_to['year'], $date_to['month'], $date_to['day']))),
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
			"bottom" => array("cancel" => "/datamart/reports/samples_by_type")); 
		$structures->build($atim_structure, array("links" => $links));
	}
}