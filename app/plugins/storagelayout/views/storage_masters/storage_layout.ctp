<?php
	
//	$structure_links = array(
//		'bottom'=>array(
//			'edit children storage positions' => '/underdevelopment/',
//			'edit aliquots positions' => '/storagelayout/storage_masters/editAliquotPositionInBatch/' . $atim_menu_variables['StorageMaster.id']
//		)
//	);
//		
//	$structure_override = array('StorageMaster.code' => 'In Dev');
//
//	$structures->build($atim_structure, array('type' => 'detail', 'links' => $structure_links, 'override' => $structure_override));

	echo("<table id='table'>");
	if($data['parent']['StorageControl']['coord_x_type'] == 'list'){
		foreach($data['parent']['list'] as $list_item){
			echo("<tr><td style='border-style:solid; border-width:1px; min-width: 30px;' class='droppable'>"
			.$list_item['StorageCoordinate']['coordinate_value']
			.'<ul id="cell_'.$list_item['StorageCoordinate']['id'].'_1"/>'
			.'</td></tr>');
		}
	}else{
		$x_size = $data['parent']['StorageControl']['coord_x_size'];
		$y_size = $data['parent']['StorageControl']['coord_y_size'];
		if((strlen($x_size) == 0 || strlen($y_size) == 0) && $data['parent']['StorageControl']['square_box']){
			$x_size = $y_size = (strlen($x_size) > 0 ? sqrt($x_size) : sqrt($y_zise));
			$square_box = true;
		}else{
			$square_box = false;
			if(strlen($x_size) == 0 || $x_size < 1){
				$x_size = 1;
			}
			if(strlen($y_size) == 0  || $y_size < 1){
				$y_size = 1;
			}
		}
		$x_alpha = $data['parent']['StorageControl']['coord_x_type'] == "alphabetical";
		$y_alpha = $data['parent']['StorageControl']['coord_y_type'] == "alphabetical";
		for($j = 1; $j <= $y_size; $j ++){
			echo("<tr>");
			if(!$square_box){
				$y_val = $y_alpha ? chr($j + 64) : $j;
			}
			for($i = 1; $i <= $x_size; $i ++){
				if($square_box){
					$display_value = ($j - 1) * $y_size + $i;
					$use_value = $display_value."_1"; 
				}else{
					$x_val = $x_alpha ? chr($i + 64) : $i;
					$use_value = $x_val."_".$y_val;
					if($y_size == 1){
						$display_value = $x_val;
					}else if($x_size == 1){
						$display_value == $y_val;
					}else{
						$display_value = $x_val."-".$y_val;
					}
				}
				echo("<td style='border-style:solid; border-width:1px; min-width: 30px;' class='droppable'>"
				.$display_value."<ul id='cell_".$use_value."' /></td>");
			}
			echo("</tr>");
		}
	}
	
	echo("</table><br/><br/>");
	echo('<div class="ui-widget-content ui-state-default droppable" style="border-style:solid; border-width:1px; min-height: 50px;">'
		.'<h4 class="ui-widget-header"><span class="ui-icon ui-icon-trash"></span>Unclassified</h4>'
		.'<ul id="unclassified" >'
		.'</ul>'
		.'</div>');
	echo('<div class="ui-widget-content ui-state-default droppable" style="border-style:solid; border-width:1px; min-height: 50px;">'
		.'<h4 class="ui-widget-header"><span class="ui-icon ui-icon-trash"></span> Trash</h4>'
		.'<ul id="trash"></ul>'
		.'</div>');
	//pr($data);
?>
<div id="debug"></div>
<form method="post">
	<input type="hidden" id="data" name="data" value="patate chaude"/>
	<input type="submit" id="submitButton"/>
</form>
<link type="text/css" href="/ctrnet2/js/jQuery/themes/ui-lightness/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
<style type="text/css">
.dragme{
	list-style-type:none;
	clear: both;
	cursor: move;
</style>

<?php 

//the following script is a json transfer from php to javascript
?>
<script>

var orgItems = '([<?php
	$first = true;
	foreach($data['children'] as $children_array){
		$display_data = $children_array['DisplayData'];
		if(!$first){
			echo(",'\n+ '");
		}else{
			$first = false;
		}
		echo('{"id" : "'.$display_data['id'].'", '
			.'"x" : "'.$display_data['x'].'", '
			.'"y" : "'.$display_data['y'].'", '
			.'"label" : "'.$display_data['label'].'", '
			.'"type" : "'.$display_data['type'].'"}');
	}
?>])';
</script>
<?php
echo $javascript->link('builder')."\n"; 
echo $javascript->link('storage_layout')."\n";
?>