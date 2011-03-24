<?php
class StorageMasterCustom extends StorageMaster{
	var $name 		= "StorageMaster";
	var $useTable 	= "storage_masters";
	
	function incrementPosition($storage_control_data, $current_x, $current_y, $increment_factor){
		$storage_control_data = $storage_control_data['StorageControl'];
		if(!is_numeric($current_x) || $storage_control_data['coord_x_type'] != "integer"){
			return false;
		}
		if(strlen($current_y) == 0){
			$current_y = null;
		}
		if($current_y != null && (!is_numeric($current_y) || $storage_control_data['coord_y_type'] != "integer")){
			return false;
		}
		
		if(is_numeric($current_y)){
			$current_x += $increment_factor % $storage_control_data['coord_x_size'];
			if($current_x > $storage_control_data['coord_x_size']){
				$current_x %= $storage_control_data['coord_x_size'];
				++ $current_y;
			}
			$current_y += floor($increment_factor / $storage_control_data['coord_x_size']);
			if($current_y > $storage_control_data['coord_y_size']){
				return false;
			}
		}else{
			$current_x += $increment_factor;
			if($current_x > $storage_control_data['coord_x_size']){
				return false;
			}
		}
		return array("x" => $current_x, "y" => $current_y);
	}
}