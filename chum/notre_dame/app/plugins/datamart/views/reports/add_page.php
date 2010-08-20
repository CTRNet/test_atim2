<?php
$links = array(
	"top" => "/datamart/reports/add"
	);
$settings = array(
	"header" => array(
		"title" => __("general", true),
		"description" => __("global report information", true)),
	"form_bottom" => false,
	"actions" => false
	);
$structures->build($head_structure, array("type" => "add", "links" => $links, "settings" => $settings));

	
$links = array(
	"top" => "/datamart/reports/add",
	"radiolist" => array('Report.structure_id' => '%%DatamartStructure.id%%')
	);

$settings = array(
	"header" => __("Based on", true),
	"pagination" => false,
	'form_inputs'=>false,
	"form_top" => false,
	"form_bottom" => false,
	"actions" => false
	);
$structures->build($report_structures, array("settings" => $settings, "type" => "radiolist", "data" => $report_structures_data, "links" => $links));

?>
<div id="structure_holder"></div>
<?php 
$links = array(
	"top" => "/datamart/reports/add",
	"bottom" => array(
		"cancel" => "/datamart/reports/index")
	);
$settings = array(
	"form_top" => false,
	"form_bottom" => true,
	"actions" => true
	);
$structures->build($empty_structure, array("settings" => $settings, "data" => array(), "links" => $links));
?>
<div id="cache" class="hidden">

</div>
<script type="text/javascript">
var last_id = 0;
$(function(){
	$("input[type=radio]").click(function(){
		var val = $(this).val();
		if($("#structure_" + val).length){
			//reload cached loaded forms
			$("#structure_" + last_id).appendTo("#cache");
			$("#structure_" + val).appendTo("#structure_holder");
			last_id = val;
		}else{
			$.post(root_url + "datamart/reports/add/" + val, "", function(data){
				$("#structure_" + last_id).appendTo("#cache");
				$("#structure_holder").html('<div id="structure_' + val + '">' + data + '</div>');
				last_id = val;
			});
		}
	});
});
</script>