<?php
$structures->build( $data, array('type'=>'csv') );
//
//if($data['parent']['StorageControl']['coord_x_type'] == 'list'){
//	if($data['parent']['StorageControl']['horizontal_display']){
//		echo("<tr>");
//		foreach($data['parent']['list'] as $list_item){
//			echo("<td style='border-style:solid; border-width:1px; min-width: 30px;' class='droppable mycell'>"
//			.'<b>'.$list_item['StorageCoordinate']['coordinate_value'].'</b>'
//			.'<ul id="cell_'.$list_item['StorageCoordinate']['id'].'_1"/>'
//			.'</td>');
//		}
//		echo("</tr>\n");
//	}else{
//		foreach($data['parent']['list'] as $list_item){
//			echo("<tr><td style='border-style:solid; border-width:1px; min-width: 30px;' class='droppable mycell'>"
//			.'<b>'.$list_item['StorageCoordinate']['coordinate_value'].'</b>'
//			.'<ul id="cell_'.$list_item['StorageCoordinate']['id'].'_1"/>'
//			.'</td></tr>\n');
//		}
//	}
//}else{
//	$x_size = $data['parent']['StorageControl']['coord_x_size'];
//	$y_size = $data['parent']['StorageControl']['coord_y_size'];
//	if((strlen($x_size) == 0 || strlen($y_size) == 0) && $data['parent']['StorageControl']['square_box']){
//		$use_height = $use_width = $x_size = $y_size = (strlen($x_size) > 0 ? sqrt($x_size) : sqrt($y_zise));
//		$square_box = true;
//	}else{
//		$square_box = false;
//		if(strlen($x_size) == 0 || $x_size < 1){
//			$x_size = 1;
//		}
//		if(strlen($y_size) == 0  || $y_size < 1){
//			$y_size = 1;
//		}
//		if($y_size == 1 && !$data['parent']['StorageControl']['horizontal_display']){
//			//override orientation on 1d control
//			$orrientation_override = true;
//			$use_width = 1;
//			$use_height = $x_size;
//		}else{
//			//standard way, width = x, height = y
//			$orrientation_override = false;
//			$use_width = $x_size;
//			$use_height = $y_size;
//		}
//	}
//	$x_alpha = $data['parent']['StorageControl']['coord_x_type'] == "alphabetical";
//	$y_alpha = $data['parent']['StorageControl']['coord_y_type'] == "alphabetical";
//	for($j = 1; $j <= $use_height; $j ++){
//		
//		if(!$square_box){
//			$y_val = $y_alpha ? chr($j + 64) : $j;
//		}else{
//			$y_val = 1;
//		}
//		for($i = 1; $i <= $use_width; $i ++){
//			if($square_box){
//				$display_value = ($j - 1) * $y_size + $i;
//				$use_value = $display_value."_1"; 
//			}else{
//				if($orrientation_override){
//					$use_value = $y_val."_1";
//				}else{
//					$x_val = $x_alpha ? chr($i + 64) : $i;
//					$use_value = $x_val."_".$y_val;
//				}
//				if($use_height == 1){
//					$display_value = $x_val;
//				}else if($use_width == 1){
//					$display_value = $y_val;
//				}else{
//					$display_value = $x_val."-".$y_val;
//				}
//			}
//			if(isset($data['csv'][$x_val][$y_val])){
//				echo("[".$display_value."]");
//				foreach($data['csv'][$x_val][$y_val] as $value){
////					echo($value);
//				}
//				echo(",");
//			}
//		}
//		echo("<br/>\n");
//	}
//}
?>