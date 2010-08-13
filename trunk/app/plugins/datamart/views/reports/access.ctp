<?php
function getFieldFromSimplifiedStructure($simplified_structure, $field_name){
	foreach($simplified_structure['SimplifiedField'] as $simple_field){
		if($field_name == $simple_field['field']){
			return $simple_field;
		}
	}
	return null;
}

function printStatsRow($field_name, $stats, $simple_field){
	echo("<tr><th>".__($simple_field['language_label'], true)."</th>");
	$straight_stats = array("avg", "min", "max");
	foreach($straight_stats as $straight_stat){
		echo("<td>");
		if(isset($stats[$straight_stat])){
			echo($stats[$straight_stat]);
		}
		echo("</td>");
	}
	//group stats
	echo("<td>");
	if(isset($stats['group'])){
		echo("<ul>");
		foreach($stats['group'] as $g_name => $g_val){
			if(isset($simple_field['StructureValueDomain']['StructurePermissibleValue'])){
				foreach($simple_field['StructureValueDomain']['StructurePermissibleValue'] as $spv){
					if($spv['value'] == $g_name){
						$g_name = __($spv['language_alias'], true);
					}
				}
			}
			echo("<li>".(empty($g_name) ? "?" : $g_name).": ".(empty($g_val) ? "0" : $g_val)."</li>");
		}
		echo("</ul>");
	}
	echo("</td>");
}


//pr($report);
//pr($fields);
//pr($simplified_structure);
$settings = array(
	'header' => array(
		'title' => $report['Report']['name'],
		'description' => $report['Report']['description']	
	), 'actions' => false
	);
$structures->build($empty_structure, array('settings' => $settings));
?>
<table class="structure">
	<thead>
		<tr>
			<?php 
			echo("<th>".__('field', true)." \\ ".__('stat', true)."</th>");
			echo("<th>".__('average', true)."</th>");
			echo("<th>".__('minimum', true)."</th>");
			echo("<th>".__('maximum', true)."</th>");
			echo("<th>".__('group', true)."</th>");
			?>
		</tr>
	</thead>
<?php 
	foreach($data as $model => $fields){
		foreach($fields as $field_name => $stats){
			$simple_field = getFieldFromSimplifiedStructure($simplified_structure, $field_name);
			printStatsRow($field_name, $stats, $simple_field);
		}
	}
?>
</table>
<?php 
$links = array(
	'bottom' => array(
		'list all' => '/datamart/reports/index'
));
$structures->build($empty_structure, array('links' => $links));
?>