<?php
/**
 * Prints a row with checkbox/input when appropriate
 * @param $model_name The model name of the field
 * @param $field_name The field name
 * @param $avg Print average checkbox
 * @param $min Print minimum checkbox
 * @param $max Print maximum checkbox
 * @param $group Print group checkbox. If false, prints an input text instead
 */
function printRow($model_name, $field_name, $avg, $min, $max, $group){
	$str = "<input type='checkbox' name='data[".$model_name."][".$field_name."][%s]'/>";
	$tmp_arr = array("avg" => $avg, "min" => $min, "max" => $max);
	foreach($tmp_arr as $k => $v){
		echo("<td>");
		if($v){
			printf($str, $k);
		}
		echo("</td>");
	}
	echo("<td>");
	if($group){
		printf($str, "group");
	}else{
		echo("<input type='text' name='data[".$model_name."][".$field_name."][group]'/>");
	}
	echo("</td>\n");
}


$settings = array(
	"form_top" => false,
	"form_bottom" => false,
	"actions" => false,
	"header" => array(
		"title" => __("fields", true),
		"description" => __("select the fields to display in he report", true))
	);
$structures->build($empty_structure, array("settings" => $settings, "data" => array()));
?>
<table class="structure">
	<thead>
		<tr>
			<th><?php echo(__("field", true)." \ ".__("associated stats", true)); ?></th>
			<th><?php __("average"); ?></th>
			<th><?php __("minimum"); ?></th>
			<th><?php __("maximum"); ?></th>
			<th><?php __("grouping"); ?></th>
		</tr>
	</thead>
	<tbody>
	<?php 
	$num_types = array("number", "integer", "integer_positive", "float", "float_positive");
	$date_types = array("datetime", "date");
	$rejeceted = array();
	foreach($structure['SimplifiedField'] as $sf){
		if($sf['flag_detail']
		&& $sf['type'] != "input" 
		&& $sf['type'] != "textarea"
		&& strlen($sf['language_label']) > 0){
			echo("<tr class='input'><td class='label no_border'>".$sf['language_label']." (".$sf['type'].")</td>");
			if(in_array($sf['type'], $num_types)){
				printRow($sf['model'], $sf['field'], true, true, true, false);
			}else if(in_array($sf['type'], $date_types)){
				printRow($sf['model'], $sf['field'], false, true, true, false);
			}else{
				printRow($sf['model'], $sf['field'], false, false, false, true);
			}
			echo("</tr>");
		}else{
			$rejected[] = $sf['language_label'];
		}
	}
	?>
	</tbody>
</table>
<?php
//pr($rejected);
?>