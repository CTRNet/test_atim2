<?php
	
	$structure_links = array(
		'bottom'=>array(
			'edit children storage positions' => '/underdevelopment/',
			'edit aliquots positions' => '/storagelayout/storage_masters/editAliquotPositionInBatch/' . $atim_menu_variables['StorageMaster.id']
		)
	);
		
	$structure_override = array('StorageMaster.code' => 'In Dev');

	$structures->build($atim_structure, array('type' => 'detail', 'links' => $structure_links, 'override' => $structure_override));	
	
//TODO...

////=================================================================================================
////	DISPLAY SECTION	
////=================================================================================================
//		
//	// -----------------------------
//	// 1- Display positionned entities
//	// -----------------------------
//	
//	$html_string = '';	
//		
//	$html_string = '
//		<table class="storagelayout" cellspacing="0">
//		<tbody>
//	';
//
//	if(empty($arr_content['y'])){
//		// 1 coordinate (X)
//		// Display one dimension array
//	
//		//headers
//		$html_string .= '
//			<tr>
//				<td class="label_1d_1">'.$translations->t($arr_content['x'], $lang, false).'</td>
//				<td class="label_std">'.$translations->t('content', $lang, false).'</td>
//			</tr>
//		';
//					
//		//contents
//		foreach($arr_content['x_labels'] as $key => $x_id){
//			
//			$html_string .= '
//				<tr>
//					<td class="label_1d_1">'.$x_id.'</td>
//					<td class="content">
//			';
//			
//			if(isset($arr_content['data'][$x_id])){
//				//data to display
//
//				foreach($arr_content['data'][$x_id][''] as $key => $entity){
//					$html_string .= createLink($html, $entity['type'], $entity['type_code'], $entity['id'], $entity['code'], $entity['additional_data'], $translations, $lang);
//				}
//				
//			} else {
//				
//				// Empty cell
//				$html_string .= '&nbsp;';
//				
//			}
//				
//			$html_string .= '
//				</td>
//			';
//								
//		} // end new x coord
//			
//	} else {
//		
//		// 2 coordinates (X,Y)
//		// Display two dimensions array	
//
//		//headers line1		
//		$html_string .= '
//			<tr>
//				<td class="label_2d_1"></td>
//				<td class="label_std" colspan='.(sizeof($arr_content['x_labels'])+1).'>'.$translations->t($arr_content['x'], $lang, false).'</td>
//			</tr>
//		';
//		
//		//headers line2
//		$html_string .= '
//			<tr>
//				<td class="label_2d_1" rowspan='.(sizeof($arr_content['y_labels'])+1).'>'.$translations->t($arr_content['y'], $lang, false).'</td>
//				<td class="label_2d_2">&nbsp;</td>
//		';
//		
//		foreach($arr_content['x_labels'] as $key => $x_id){
//			$html_string .= '
//				<td class="label_std">'.$x_id.'</td>
//			';
//		}
//		
//		$html_string .= '
//			</tr>
//		';
//		
//		//contents
//		foreach($arr_content['y_labels'] as $key => $y_id){
//			
//			//New line
//			$html_string .= '
//				<tr>
//					<td class="label_2d_2">'.$y_id.'</td>
//			';
//			
//			foreach($arr_content['x_labels'] as $key => $x_id){
//
//				if(isset($arr_content['data'][$x_id][$y_id])){
//					//data to display
//					
//					$html_string .= '
//						<td class="content">
//					';
//					
//					foreach($arr_content['data'][$x_id][$y_id] as $key => $entity){
//						$html_string .= createLink($html, $entity['type'], $entity['type_code'], $entity['id'], $entity['code'], $entity['additional_data'], $translations, $lang);
//					}
//					
//					$html_string .= '
//						</td>
//					';
//					
//				} else {
//					
//					// Empty cell
//					$html_string .= '
//						<td class="content">
//							&nbsp;
//						</td>
//					';
//					
//				}				
//			} // end new col
//			
//			$html_string .= '
//				</tr>
//			';	
//			
//		} // end new line
//	}
//	
//	$html_string .= '
//		</tbody>
//		</table>
//	';	
//	
//	echo '
//		<br>
//		<h4>'.$translations->t('positioned entities', $lang, false).'</h4>
//		<br>
//	';
//	
//	echo $html_string;
//	
//	// -----------------------------
//	// 2- Display entites with no positon
//	// -----------------------------
//	
//	$html_string = '';
//	
//	foreach($arr_content['data_no_position'] as $key => $entity){
//		$html_string .= createLink($html, $entity['type'], $entity['type_code'], $entity['id'], $entity['code'], $entity['additional_data'], $translations, $lang);
//	}
//	
//	echo '
//		<br>
//		<h4>'.$translations->t('entities with no position', $lang, false).'</h4>
//		<br>
//	';
//	
//	echo $html_string;	
//		
//	// -----------------------------
//	// 3- Display legends
//	// -----------------------------
//	
//	$html_string = '<br><h4>'.$translations->t('legend', $lang, false).'</h4>';
//	$html_string .= '<font color="#900">'.$translations->t('storage', $lang, false).'</font> / ';
//	$html_string .= '<font color="#090">'.$translations->t('aliquot', $lang, false).'</font> / ';
//	$html_string .= '<font color="#009">'.$translations->t('tma slide', $lang, false).'</font><br>';
//	
//	echo($html_string);
//	
////=================================================================================================
////	FUNCTIONS SECTION	
////=================================================================================================
//
//	// -----------------------------
//	// Function to create link
//	// -----------------------------
//	
//	function createLink($html_obj, $entity_type, $type_code, $id, $code, $arr_additional_data, $translations, $lang){
//		
//		$html_code = '';
//
//		if(strcmp($entity_type, 'aliquot') == 0){
//			// Aliquot
//			$html_code .= 
//				$html_obj->link(
//					$code, 
//					'/inventorymanagement/aliquot_masters/detailAliquotFromId/'.$id.'/',
//					array('style'=>'color: #090;')
//				).' ['.$translations->t($type_code, $lang, false).']<br>';
//		
//		} else if(strcmp($entity_type, 'storage') == 0) {
//			// Storage
//			$html_code .= 
//				$html_obj->link(
//					$code, 
//					'/storagelayout/storage_masters/detail/'.$id.'/',
//					array('style'=>'color: #900;')
//				).' (['.$arr_additional_data['selection_label'].'] '.
//				$translations->t($type_code, $lang, false).')<br>';			
//		
//		} else {
//			// Tma Slide
//			$html_code .= 
//				$html_obj->link(
//					$code, 
//					'/storagelayout/tma_slides/detail/'.$arr_additional_data['tma_block_id'].'/'.$id.'/',
//					array('style'=>'color: #009;')
//				).' ('.
//				$translations->t($type_code, $lang, false).')<br>';			
//		} 
//		
//
//		return $html_code;
//	}
//	
//	

?>