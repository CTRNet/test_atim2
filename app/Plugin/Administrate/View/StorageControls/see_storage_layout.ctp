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



<div style="display: table-cell; padding-top: -10px; vertical-align: top;">
	<div>
		<h4 class="ui-widget-header">
			<span class='help storage'>
				<div><?php echo __('help_storage_layout_storage') ?></div>
			</span>
			<span class="ui-icon ui-icon-calculator" style="float: left;"></span>
			<?php echo __('storage layout'). ' : '. $storage_control_data['StorageCtrl']['translated_storage_type'] ?>
		</h4>
		<table class='storageLayout' style="width: 100%;">
		

<?php
	$x_size = $storage_control_data['StorageCtrl']['coord_x_size'];
	$y_size = $storage_control_data['StorageCtrl']['coord_y_size'];
	if((strlen($x_size) == 0 || strlen($y_size) == 0) && ($storage_control_data['StorageCtrl']['display_x_size'] > 0 || $storage_control_data['StorageCtrl']['display_y_size'] > 0)){
		//continuous numbering with 2 dimensions
		$use_width = $y_size = max(1, $storage_control_data['StorageCtrl']['display_x_size']);
		$use_height = $x_size = max(1, $storage_control_data['StorageCtrl']['display_y_size']);
		$twoAxis = true;
		//Validate that the number of displayed cells is the same as the number of actual cells
		if(max(1, $storage_control_data['StorageCtrl']['coord_x_size']) * max(1, $storage_control_data['StorageCtrl']['coord_y_size']) != $x_size * $y_size){
			echo("The current box properties are invalid. The storage cells count and the cells count to display doesn't match. Contact ATiM support.<br/>");
			echo("Real storage cells: ".(($storage_control_data['StorageCtrl']['coord_x_size']) * max(1, $storage_control_data['StorageCtrl']['coord_y_size']))."<br/>");
			echo("Display cells: ".$x_size * $y_size."<br/>");
			print_r($storage_control_data['StorageCtrl']);
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
	$x_alpha = $storage_control_data['StorageCtrl']['coord_x_type'] == "alphabetical";
	$y_alpha = $storage_control_data['StorageCtrl']['coord_y_type'] == "alphabetical";
	$horizontal_increment = $storage_control_data['StorageCtrl']['horizontal_increment'];
	//table display loop and inner loop
	$j = null;
	while(axisLoopCondition($j, $storage_control_data['StorageCtrl']['reverse_y_numbering'], $use_height)){
		echo("<tr>");
		if(!$twoAxis){
			$y_val = $y_alpha ? chr($j + 64) : $j;
		}
		$i = null;
		while(axisLoopCondition($i, $storage_control_data['StorageCtrl']['reverse_x_numbering'], $use_width)){
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
			echo("<td style='display: table-cell;'><b>".$display_value."</b></td>");
		}
		echo("</tr>\n");
	}
	
	//NOTE: No hook supported!	
?>
</table>
</div>
</div>

<?php 
	$content = ob_get_clean();
	
	$structure_links = array(
		'bottom' => array(
			'edit' => '/Administrate/StorageControls/edit/'.$atim_menu_variables['StorageCtrl.id'].'/',
			'copy' => '/Administrate/StorageControls/add/0/'.$atim_menu_variables['StorageCtrl.id'].'/',
			'change active status' => array('link' => '/Administrate/StorageControls/changeActiveStatus/'.$atim_menu_variables['StorageCtrl.id'].'/', 'icon' => 'confirm'),
			'list'=> '/Administrate/StorageControls/listAll/'
		)
	);			
	
	$settings = array('actions' => true);
	
	$this->Structures->build($empty_structure, array(
		'type' => 'detail', 
		'settings' => $settings,
		'extras' => $content, 
		'links' => $structure_links
	));	
?>
