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
ob_start();
?>
 <div style="display: table-cell; vertical-align: top;">
 	<ul style='margin-right: 10px';>
 		<li><span class="button RecycleStorage" style='width: 80%;'><span class="ui-icon ui-icon-refresh"></span><?php echo(__("unclassify all storage's items")); ?></span></li>
 		<li><span class="button TrashStorage" style='width: 80%;'><span class="ui-icon ui-icon-close"></span><?php echo(__("remove all storage's items")); ?></span></li>
 	</ul>
 </div>
 <div style="display: table-cell; padding-top: -10px; vertical-align: top;">
	<div>
		<h4 class="ui-widget-header">
			<span class='help storage'>
				<div><?php echo __('help_storage_layout_storage') ?></div>
			</span>
			<span class="ui-icon ui-icon-calculator" style="float: left;"></span>
			<?php echo __($data['parent']['StorageControl']['storage_type']) , ' : ' , $data['parent']['StorageMaster']['short_label']; ?>
		</h4>
		<table class='storageLayout' style="width: 100%;">
<?php
	if($data['parent']['StorageControl']['coord_x_type'] == 'list'){
		if(isset($data['parent']['StorageControl']['horizontal_display']) && $data['parent']['StorageControl']['horizontal_display']){
			echo("<tr>");
			foreach($data['parent']['list'] as $list_item){
				echo("<td class='droppable mycell'>"
				.'<b>'.$list_item['StorageCoordinate']['coordinate_value'].'</b>'
				.'<ul id="s_'.$atim_menu_variables['StorageMaster.id'].'_c_'.$list_item['StorageCoordinate']['id'].'_1"/>'
				.'</td>');
			}
			echo("</tr>\n");
		}else{
			foreach($data['parent']['list'] as $list_item){
				echo("<tr><td class='droppable mycell'>"
				.'<b>'.$list_item['StorageCoordinate']['coordinate_value'].'</b>'
				.'<ul id="s_'.$atim_menu_variables['StorageMaster.id'].'_c_'.$list_item['StorageCoordinate']['id'].'_1"/>'
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
						$display_value = ($i - 1) * $x_size + $j;
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
				echo("<td class='droppable'>"
				.'<b>'.$display_value."</b><ul id='s_".$atim_menu_variables['StorageMaster.id']."_c_".$use_value."' /></td>");
			}
			echo("</tr>\n");
		}
	}
	
	//NOTE: No hook supported!
	
?>
		</table>
	</div>
</div>
<div style="display: table-cell; vertical-align: top;">
	<ul class='trash_n_unclass'>
		<li class='trash_n_unclass'>
			<div style="width: 100%; border:solid 1px; display: inline-block; vertical-align: top;">
				<h4 class="ui-widget-header" style="white-space: nowrap;">
					<span class="ui-icon ui-icon-refresh" style="float: left;"></span><?php echo(__("unclassified")); ?>
					<span class='help storage'>
						<div><?php echo __('help_storage_layout_unclassified') ?></div>
					</span>
				</h4>
				<div class="droppable" style="padding-top: 5px; border: solid 1px transparent;">
					<ul id="s_<?php echo $atim_menu_variables['StorageMaster.id']; ?>_c_u_u" class="unclassified" style="margin-right: 5px;"></ul>
					<span class="button TrashUnclassified"><span class="ui-icon ui-icon-close" style="float: left;"></span><?php echo(__("remove all unclassified")); ?></span>
				</div>	
			</div>
		</li>
		<li class='trash_n_unclass'>
			<div style="width: 100%; border:solid 1px; display: inline-block; vertical-align: top;">
				<h4 class="ui-widget-header" style="white-space: nowrap;">
					<span class="ui-icon ui-icon-close" style="float: left;"></span><?php echo(__("remove")); ?>
					<span class='help storage'>
						<div><?php echo __('help_storage_layout_remove') ?></div>
					</span>
				</h4>
				<div class="droppable" style="padding-top: 5px; border: solid 1px transparent;">
					<ul id="s_t_c_t_t" class="trash" style="margin-right: 5px;"></ul>
					<span class="button RecycleTrash"><span class="ui-icon ui-icon-refresh" style="float: left;"></span><?php echo(__("unclassify all removed")); ?></span>
				</div>
			</div>
		</li>
	</ul>
</div>
<?php 
$content = ob_get_clean();

$children_display = array();
foreach($data['children'] as $children_array){
	$children_display[] = $children_array['DisplayData'];
}

echo json_encode(array('valid' => 1, 'content' => $content, 'positions' => $children_display, 'check_conflicts' => $data['parent']['StorageControl']['check_conflicts']));

