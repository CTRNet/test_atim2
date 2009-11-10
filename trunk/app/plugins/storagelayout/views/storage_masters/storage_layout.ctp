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
	$x_size = $data['parent']['StorageControl']['coord_x_size'];
	$y_size = (is_numeric($data['parent']['StorageControl']['coord_y_size']) ? $data['parent']['StorageControl']['coord_y_size'] : 1);
	echo("<table id='table'>");
	for($j = 0; $j < $y_size; $j ++){
		echo("<tr>");
		for($i = 0; $i < $x_size; $i ++){
			echo("<td style='border-style:solid; border-width:1px; min-width: 30px;' class='droppable'>".$i."-".$j."<ul id='cell_".$i."_".$j."' /></td>");
		}
		echo("</tr>");
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
//echo $javascript->link('jQuery/jquery-1.3.2.min')."\n";
//echo $javascript->link('jQuery/ui/ui.core')."\n";
//echo $javascript->link('jQuery/ui/ui.draggable')."\n";
//echo $javascript->link('jQuery/ui/ui.droppable')."\n";
//echo $javascript->link('jQuery/ui/ui.sortable')."\n";

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
echo $javascript->link('storage_layout')."\n";
?>