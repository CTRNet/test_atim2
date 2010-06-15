<table class="structure" cellspacing="0">
	<tbody>
		<tr>
			<td class="this_column_1 total_columns_1">
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
				."</td></tr>\n");
			}
		}
	}else{
		$x_size = $data['parent']['StorageControl']['coord_x_size'];
		$y_size = $data['parent']['StorageControl']['coord_y_size'];
		if((strlen($x_size) == 0 || strlen($y_size) == 0) && ($data['parent']['StorageControl']['display_x_size'] > 0 || $data['parent']['StorageControl']['display_y_size'] > 0)){
			//continuous numbering with 2 dimensions
			$use_width = $y_size = max(1, $data['parent']['StorageControl']['display_x_size']);
			$use_height = $x_size = max(1, $data['parent']['StorageControl']['display_y_size']);
			$twoAxis = true;
			//Validate that the number of displayed cells is the same as the number of actual cells
			if(max(1, $data['parent']['StorageControl']['coord_x_size']) * max(1, $data['parent']['StorageControl']['coord_y_size']) != $x_size * $y_size){
				echo("The current box properties are invalid. The storage cells count and the cells count to display doesn't match. Contact ATiM support.<br/>");
				echo("Real storage cells: ".(($data['parent']['StorageControl']['coord_x_size']) * max(1, $data['parent']['StorageControl']['coord_y_size']))."<br/>");
				echo("Display cells: ".$x_size * $y_size."<br/>");
				print_r($data['parent']['StorageControl']);
				exit;
			}
		}else{
			$twoAxis = false;
			if(strlen($x_size) == 0 || $x_size < 1){
				$x_size = 1;
			}
			if(strlen($y_size) == 0  || $y_size < 1){
				$y_size = 1;
			}
			$use_width = $x_size;
			$use_height = $y_size;
		}
		$x_alpha = $data['parent']['StorageControl']['coord_x_type'] == "alphabetical";
		$y_alpha = $data['parent']['StorageControl']['coord_y_type'] == "alphabetical";
		$horizontal_increment = $data['parent']['StorageControl']['horizontal_increment'];
		//table display loop and inner loop
		$j = null;
		while(axisLoopCondition($j, $data['parent']['StorageControl']['reverse_y_numbering'], $use_height)){
			echo("<tr>");
			if(!$twoAxis){
				$y_val = $y_alpha ? chr($j + 64) : $j;
			}
			$i = null;
			while(axisLoopCondition($i, $data['parent']['StorageControl']['reverse_x_numbering'], $use_width)){
				if($twoAxis){
					if($horizontal_increment){
						$display_value = ($j - 1) * $y_size + $i;
					}else{
						$display_value = ($i - 1) * $y_size + $j;
					}
					$use_value = $display_value."_1"; //static y = 1
				}else{
					$x_val = $x_alpha ? chr($i + 64) : $i;
					$use_value = $x_val."_".$y_val;
					if($use_height == 1){
						$display_value = $x_val;
					}else if($use_width == 1){
						$display_value = $y_val;
					}else{
						$display_value = $x_val."-".$y_val;
					}
				}
				echo("<td style='border-style:solid; border-width:1px; min-width: 30px; border-color: #000;' class='droppable'>"
				.'<b>'.$display_value."</b><ul id='cell_".$use_value."' /></td>");
			}
			echo("</tr>\n");
		}
	}
	
	//NOTE: No hook supported!
	
?>
	</table>
	<div style="text-align: right;">
		<span id="Reset" class="button"><span class="ui-icon ui-icon-gear"></span><?php echo(__("reset", true)); ?></span> 
		<span id="RecycleStorage" class="button"><span class="ui-icon ui-icon-refresh"></span><?php echo(__("unclassify all storage's items", true)); ?></span>
		<span id="TrashStorage" class="button"><span class="ui-icon ui-icon-close"></span><?php echo(__("remove all storage's items", true)); ?></span>
	</div>
	</div>
	<div class="droppable" style="border-style:solid; border-width:1px; display: inline-block; vertical-align: top; margin-left: 10px;">
		<h4 class="ui-widget-header" style="height: 15px;  padding-right: 5px;  margin-bottom: 5px;">
			<span class="ui-icon ui-icon-refresh" style="float: left;"></span><?php echo(__("unclassified", true)); ?>
		</h4>
		<ul id="unclassified" style="margin-right: 5px;"></ul>
		<span id="TrashUnclassified" class="button"><span class="ui-icon ui-icon-close" style="float: left;"></span><?php echo(__("remove all unclassified", true)); ?></span>
	</div>
	<div class="droppable" style="border-style:solid; border-width:1px; display: inline-block; vertical-align: top; margin-left: 10px;">
		<h4 class="ui-widget-header" style="height: 15px; padding-right: 5px; margin-bottom: 5px;">
			<span class="ui-icon ui-icon-close" style="float: left;"></span><?php echo(__("remove", true)); ?>
		</h4>
		<ul id="trash" style="margin-right: 5px;"></ul>
		<span id="RecycleTrash" class="button"><span class="ui-icon ui-icon-refresh" style="float: left;"></span><?php echo(__("unclassify all removed", true)); ?></span>
	</div>
	<div style="border-style:solid; border-width:1px; display: inline-block; vertical-align: top; margin-left: 10px; width: 200px;">
		<h4 class="ui-widget-header" style="height: 15px; padding-right: 5px;">
			<?php echo(__("legend", true)); ?>
		</h4>
		<ul style="margin-left: 10px;">
			<li class="StorageMaster" style="list-style-type: none;"><?php echo(__("storage", true)); ?></li>
			<li class="AliquotMaster" style="list-style-type: none;"><?php echo(__("aliquot", true)); ?></li>
			<li class="TmaSlide" style="list-style-type: none;"><?php echo(__("tma slide", true)); ?></li>
		</ul>
	</div>

	<div style="margin-top: 10px;">
		<form method="post">
			<input type="hidden" id="data" name="data" value="patate chaude" />
					<span class="button large" style="line-height: inherit;">
						<a href="#" id="submit_button_link" onclick="$('#submitButton').click();" class="form submit" tabindex="1020"><?php echo(__('submit', true));  ?></a>
					</span>

		<div style="display: inline-block;">
		<div style="display: none; background-color: transparent;"
			id="saveWarning">
			<span class="ui-icon ui-icon-alert" style="float: left;"></span> 
			<span style="color: #ff0000;"><?php echo(__("warning", true).": ".__("the data has been modified", true).". "); echo(" ".__("do not forget to save")."."); //yes, 2 echo, but there is a bug with only one"?></span>
		</div>
		</div>
		</form>
	</div>
	<div id="debug"></div>
</td></tr></tbody></table>

<div class="actions">
	
</div>

<?php echo $html->css('jQuery/themes/ui-lightness/jquery-ui-1.8.custom')."\n"; ?>
<style type="text/css">
.dragme{
	list-style-type:none;
	clear: both;
}
.handle{
	cursor: move;
	vertical-align: top;
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
/**
 * Increments/decrements the var according to the reverseOrder option and returns true/false based on reverseOrder and the limit
 * @param unknown_type $var The variable to loop on, must be null on the first iteration
 * @param unknown_type $reverseOrder True to reverse the order
 * @param unknown_type $limit The limit of the axis
 * @return true if you must continue to loop, false otherwise
 * @alter Increments/decrements the value of var
 */
function axisLoopCondition(&$var, $reverseOrder, $limit){
	if($var == null){
		if($reverseOrder){
			$var = $limit;
		}else{
			$var = 1;
		}
	}else{
		if($reverseOrder){
			-- $var;
		}else{
			++ $var;
		}
	}
	return $var > 0 && $var <= $limit;
}

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
echo $javascript->link('storage_layout')."\n";
?>