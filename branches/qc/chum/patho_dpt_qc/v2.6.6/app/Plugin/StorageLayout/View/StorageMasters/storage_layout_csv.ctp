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
	
	//Build the csv layout
	
	$csv_layout_data = array();
	$errors = array();
	if($data['parent']['StorageControl']['coord_x_type'] == 'list'){	
		//Note: $data['parent']['StorageControl']['horizontal_display'] does not exist anymore
		foreach($data['parent']['list'] as $list_item) $csv_layout_data[][0] = array('x_y' => $list_item['StorageCoordinate']['id'].'_1', 'display_value' => $list_item['StorageCoordinate']['coordinate_value'], 'display_value_x' => null, 'display_value_y' => null);
		$x_size = 1;
		$y_size = sizeof($data['parent']['list']);
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
				$errors[] = array("The current box properties are invalid. The storage cells count and the cells count to display doesn't match. Contact ATiM support.");
				$errors[] = array("Real storage cells: ".(($data['parent']['StorageControl']['coord_x_size']) * max(1, $data['parent']['StorageControl']['coord_y_size'])));
				$errors[] = array("Display cells: ".$x_size * $y_size);
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
		if(!$errors){ 
			$x_alpha = $data['parent']['StorageControl']['coord_x_type'] == "alphabetical";
			$y_alpha = $data['parent']['StorageControl']['coord_y_type'] == "alphabetical";
			$horizontal_increment = $data['parent']['StorageControl']['horizontal_increment'];
			//table display loop and inner loop
			$j = null;
			while(axisLoopCondition($j, $data['parent']['StorageControl']['reverse_y_numbering'], $use_height)){
				$csv_layout_line_data = array();
				if(!$twoAxis){
					$y_val = $y_alpha ? chr($j + 64) : $j;
				}
				$i = null;
				while(axisLoopCondition($i, $data['parent']['StorageControl']['reverse_x_numbering'], $use_width)){
					$display_value = null;
					$display_value_x = null;
					$display_value_y = null;
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
							$display_value_x = $x_val;
							$display_value_y = $y_val;
						}
					}
					$csv_layout_line_data[] = array('x_y' => $use_value, 'display_value' => $display_value, 'display_value_x' => $display_value_x, 'display_value_y' => $display_value_y);
				}
				$csv_layout_data[] = $csv_layout_line_data;
			}
		}
	}
	
	if(!$errors){
	
		//Build array gathering cell content labels from x_y values
	
		$x_y_values_to_cell_content_labels = array();
		foreach($data['children'] as $new_content) $x_y_values_to_cell_content_labels[$new_content['DisplayData']['x']."_".$new_content['DisplayData']['y']][] = $new_content['DisplayData']['label'];
		
		// Build csv data
	
		$csv_data = array();
		if($data['parent']['StorageControl']['coord_y_type']) {
			//Two dimensions layout with both x and y coordinates tracked
			$first_line_record = true;
			foreach($csv_layout_data as $csv_layout_line_data) {
				$x_headers = array('');
				$y_header = '';
				$csv_line_content_data = array();
				foreach($csv_layout_line_data as $csv_layout_cell_data) {
					$x_headers[] = $csv_layout_cell_data['display_value_x'];
					$y_header = $csv_layout_cell_data['display_value_y'];
					$csv_line_content_data[] = isset($x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']])? implode(' / ', $x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']]) : '';
					unset($x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']]);
				}
				if($first_line_record) $csv_data[] = $x_headers;
				$first_line_record = false;
				array_unshift($csv_line_content_data, $y_header);
				$csv_data[] = $csv_line_content_data;
			}
		} else {
			if(sizeof($csv_layout_data) == 1){
				//One dimension layout display as a line with only x coordinates tracked
				foreach($csv_layout_data[0] as $csv_layout_cell_data) {
					//Position
					$csv_data[0][] = $csv_layout_cell_data['display_value'];
					//Content
					$csv_data[1][] = isset($x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']])? implode(' / ', $x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']]) : '';
					unset($x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']]);
				}
			} else if(sizeof($csv_layout_data[0]) == 1){
				//One dimension layout display as a column with only x coordinates tracked
				foreach($csv_layout_data as $csv_layout_line_data) {
					$csv_layout_cell_data = $csv_layout_line_data[0];
					$csv_data[] = array($csv_layout_cell_data['display_value'], (isset($x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']])? implode(' / ', $x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']]) : ''));
					unset($x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']]);
				}
			} else {
				//Two dimensions layout with only x coordinates tracked
				foreach($csv_layout_data as $csv_layout_line_data) {
					$csv_postions_data = array();
					$csv_line_content_data = array();
					foreach($csv_layout_line_data as $csv_layout_cell_data) {
						$csv_postions_data[] = $csv_layout_cell_data['display_value'];
						$csv_line_content_data[] = isset($x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']])? implode(' / ', $x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']]) : '';
						unset($x_y_values_to_cell_content_labels[$csv_layout_cell_data['x_y']]);
					}
					$csv_data[] = $csv_postions_data;
					$csv_data[] = $csv_line_content_data;
				}
			}
		}
		
		// Add unpositionned content to csv data
	
		if($x_y_values_to_cell_content_labels) {
			$unclassified_labels = array();
			foreach($x_y_values_to_cell_content_labels as $new_labels) $unclassified_labels = array_merge($unclassified_labels, $new_labels);
			$csv_data[] = array('');	//Add empty row
			$first = true;
			foreach($unclassified_labels as $unclassified_label) {
				$csv_data[] = array($first? __("unclassified"): '', $unclassified_label);
				$first = false;
			}
		}
	} else {
		//Error Display
		$csv_data = $errors;
	}

	// Launch CSV creation
	
	if(isset(AppController::getInstance()->csv_config)) $this->Csv->csv_separator = AppController::getInstance()->csv_config['define_csv_separator'];
	$this->Csv->addRow(array(__('storage'), $data['parent']['StorageControl']['translated_storage_type'].' : '.$data['parent']['StorageMaster']['short_label']));
	$this->Csv->addRow(array(''));
	foreach($csv_data as $new_data_line) $this->Csv->addRow($new_data_line);
	echo $this->Csv->render(true, isset(AppController::getInstance()->csv_config) ? AppController::getInstance()->csv_config['define_csv_encoding'] : csv_encoding);
	exit;
	
?>