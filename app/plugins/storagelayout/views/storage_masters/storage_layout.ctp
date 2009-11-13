
<table class="structure" cellspacing="0">
	<tbody>
		<tr>
			<td class="this_column_1 total_columns_1">
				<ul style="margin-left: 10px;>
					<li style="display: inline; list-style-type: none;"><b>Legend</b></li>
					<li class="StorageMaster" style="display: inline; list-style-type: none; margin-left: 10px;"><?php echo(__("storage", true)); ?></li>
					<li class="AliquotMaster" style="display: inline; list-style-type: none; margin-left: 10px;"><?php echo(__("aliquot", true)); ?></li>
					<li class="TmaSlide" style="display: inline; list-style-type: none; margin-left: 10px;"><?php echo(__("tma slide", true)); ?></li>
				</ul>

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
?>
	<div style="border-style:solid; border-width:1px; min-height: 50px; margin: 10px;">
		<h4 class="ui-widget-header" style="height: 15px;  padding-right: 5px;">
			<span class="ui-icon ui-icon-calculator" style="float: left;"></span><?php echo(__("storage", true)); ?></h4>
	<table id="table" style="margin: 10px; width: 98%;">
<?php
	if($data['parent']['StorageControl']['coord_x_type'] == 'list'){
		if($data['parent']['StorageControl']['horizontal_display']){
			echo("<tr>");
			foreach($data['parent']['list'] as $list_item){
				echo("<td style='border-style:solid; border-width:1px; min-width: 30px;' class='droppable mycell'>"
				.'<b>'.$list_item['StorageCoordinate']['coordinate_value'].'</b>'
				.'<ul id="cell_'.$list_item['StorageCoordinate']['id'].'_1"/>'
				.'</td>');
			}
			echo("</tr>\n");
		}else{
			foreach($data['parent']['list'] as $list_item){
				echo("<tr><td style='border-style:solid; border-width:1px; min-width: 30px;' class='droppable mycell'>"
				.'<b>'.$list_item['StorageCoordinate']['coordinate_value'].'</b>'
				.'<ul id="cell_'.$list_item['StorageCoordinate']['id'].'_1"/>'
				.'</td></tr>\n');
			}
		}
	}else{
		$x_size = $data['parent']['StorageControl']['coord_x_size'];
		$y_size = $data['parent']['StorageControl']['coord_y_size'];
		if((strlen($x_size) == 0 || strlen($y_size) == 0) && $data['parent']['StorageControl']['square_box']){
			$use_height = $use_width = $x_size = $y_size = (strlen($x_size) > 0 ? sqrt($x_size) : sqrt($y_zise));
			$square_box = true;
		}else{
			$square_box = false;
			if(strlen($x_size) == 0 || $x_size < 1){
				$x_size = 1;
			}
			if(strlen($y_size) == 0  || $y_size < 1){
				$y_size = 1;
			}
			if($y_size == 1 && !$data['parent']['StorageControl']['horizontal_display']){
				//override orientation on 1d control
				$orientage_override = true;
				$use_width = 1;
				$use_height = $x_size;
			}else{
				//standard way, width = x, height = y
				$orientage_override = false;
				$use_width = $x_size;
				$use_height = $y_size;
			}
		}
		$x_alpha = $data['parent']['StorageControl']['coord_x_type'] == "alphabetical";
		$y_alpha = $data['parent']['StorageControl']['coord_y_type'] == "alphabetical";
		for($j = 1; $j <= $use_height; $j ++){
			echo("<tr>");
			if(!$square_box){
				$y_val = $y_alpha ? chr($j + 64) : $j;
			}
			for($i = 1; $i <= $use_width; $i ++){
				if($square_box){
					$display_value = ($j - 1) * $y_size + $i;
					$use_value = $display_value."_1"; 
				}else{
					if($orientage_override){
						$use_value = $y_val."_1";
					}else{
						$x_val = $x_alpha ? chr($i + 64) : $i;
						$use_value = $x_val."_".$y_val;
					}
					if($use_height == 1){
						$display_value = $x_val;
					}else if($use_width == 1){
						$display_value = $y_val;
					}else{
						$display_value = $x_val."-".$y_val;
					}
				}
				echo("<td style='border-style:solid; border-width:1px; min-width: 30px;' class='droppable'>"
				.'<b>'.$display_value."</b><ul id='cell_".$use_value."' /></td>");
			}
			echo("</tr>\n");
		}
	}
?>
	</table>
	<div style="text-align: right;">
		<button style="margin: 5px;" id="Reset"><span class="ui-icon ui-icon-gear" style="float: left;"></span><?php echo(__("reset", true)); ?></button>
		<button style="margin: 5px;" id="RecycleStorage"><span class="ui-icon ui-icon-refresh" style="float: left;"></span><?php echo(__("unclassify all storage's items", true)); ?></button>
		<button style="margin: 5px;" id="TrashStorage"><span class="ui-icon ui-icon-close" style="float: left;"></span><?php echo(__("remove all storage's items", true)); ?></button>
	</div>
	</div>
	<div class="droppable" style="border-style:solid; border-width:1px; display: inline-block; vertical-align: top; margin-left: 10px;">
		<h4 class="ui-widget-header" style="height: 15px;  padding-right: 5px;">
			<span class="ui-icon ui-icon-refresh" style="float: left;"></span><?php echo(__("Unclassified", true)); ?>
		</h4>
		<ul id="unclassified" style="margin-right: 5px;"></ul>
		<button style="margin: 10px;" id="TrashUnclassified"><span class="ui-icon ui-icon-close" style="float: left;"></span><?php echo(__("remove all unclassified", true)); ?></button>
	</div>
	<div class="droppable" style="border-style:solid; border-width:1px; display: inline-block; vertical-align: top; margin-left: 10px;">
		<h4 class="ui-widget-header" style="height: 15px; padding-right: 5px;">
			<span class="ui-icon ui-icon-close" style="float: left;"></span><?php echo(__("remove", true)); ?>
		</h4>
		<ul id="trash" style="margin-right: 5px;"></ul>
		<button style="margin: 10px;" id="RecycleTrash"><span class="ui-icon ui-icon-refresh" style="float: left;"></span><?php echo(__("unclassify all removed", true)); ?></button>
	</div>
		
<div id="debug"></div>
</td></tr></tbody></table>
<div class="actions">
	<form method="post">
		<input type="hidden" id="data" name="data" value="patate chaude"/>
		<input type="submit" id="submitButton" style="margin-top: 10px;"/>
		<div style="display: inline-block;">
			<div style="display: none; background-color: transparent;" id="saveWarning">
				<span class="ui-icon ui-icon-alert" style="float: left;"></span>
				<span style="color: #ff0000;"><?php echo(__("warning", true).": ".__("the data has been modified.", true)); echo(" ".__("do not forget to save it.")); //yes, 2 echo, but there is a bug with only one"?></span>
			</div>
		</div>
	</form>
</div>

<link type="text/css" href="/ctrnet2/js/jQuery/themes/ui-lightness/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
<style type="text/css">
.dragme{
	list-style-type:none;
	clear: both;
}
.handle{
	cursor: move;
}
.mycell{
	padding: 5px;
}
.StorageMaster{
	color: #cc0000;
}
.AliquotMaster{
	color: #00cc00;
}
.TmaSlide{
	color: #0000cc;
}
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

var removeString = "<?php echo(__("remove")); ?>";
var unclassifyString = "<?php echo(__("unclassify")); ?>";
</script>
<?php
echo $javascript->link('builder')."\n"; 
echo $javascript->link('storage_layout')."\n";
?>