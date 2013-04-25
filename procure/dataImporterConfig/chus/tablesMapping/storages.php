<?php

function loadStorages() {
	
	Config::$storages = array();
	Config::$storage_data_from_label = array();
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path_storage_all);	
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) {
		if(in_array($tmp['name'], array(utf8_decode('Résumé'), utf8_decode('Schéma')))) continue;
		$work_sheet = $tmp['name'];
		
		
		$box_label = '';
		$box_storage_master_id = null;
		$line_counter = 0;
		$box_row = 0;
		foreach($tmp_xls_reader->sheets[$key]['cells'] as $line => $new_line) {
			$line_counter++;
			if($line_counter == 1) {
				if($new_line['1'] != utf8_decode('Boîte')) { pr($new_line);die('ERR_parse_all_boxes_['.$work_sheet.']_line_1'); }
				$box_label = $new_line['2'];
				if(!$box_label) { pr($new_line);die('ERR_parse_all_boxes_['.$work_sheet.']_line_1(1)'); }
				if(!preg_match('/^(C[0-9]+\-){0,1}(R[0-9]+\-B[0-9]+)(\ {0,1})(.*)$/', $box_label, $matches)) { pr($new_line);die('ERR_parse_all_boxes_['.$work_sheet.']_line_1(2)'); }
				$box_label = $matches[1].$matches[2];
				if(isset($matches[4]) && $matches[4]) { 
//TODO Ajouter un message de warning ou ajouter le commentaire dans la note
					
				}
				//test format
			} else if($line_counter == 2) {
				if($new_line['1'] != utf8_decode('Contenu')) { pr($new_line);die('ERR_parse_all_boxes_['.$work_sheet.']_line_1'); }
				if(!$new_line['2']) { pr($new_line);die('ERR_parse_all_boxes_['.$work_sheet.']_line_1(1)'); }
				$box_label .= ' '.$new_line['2'];
			} else if($line_counter == 3) {
				if(implode('-',$new_line) != utf8_decode("Emplacement-Congélateur-Étagère-Râtelier-Colonne-Rangée")) { pr($new_line);die('ERR_parse_all_boxes_['.$work_sheet.']_line_3'); }
			} else if($line_counter == 4) {				
				$freezer_label = "freezer[".$new_line['2']."](-)";
				$shelf_label = "shelf[".$new_line['3']."](-)";
				$rack_label = "rack16[".$new_line['4']."](-)";
				$box_label = "box100 10x10[$box_label](".$new_line['5']."-".$new_line['6'].")";
				$box_storage_master_id = getNewtStorageId();
				Config::$storages[$freezer_label][$shelf_label][$rack_label][$box_label]['id'] = $box_storage_master_id;
			} else if($line_counter == 5) {
				for($key = 2; $key < 12; $key++) if($new_line[$key] != ($key-1)) { pr($new_line);die('ERR_parse_all_boxes_['.$work_sheet.']_line_5'); }
//TODO box 3X10		
//TODO des commentaire dnas R20-B5		
			} else {
				$box_row++;
				if($box_row < 11) {
					if($new_line['1'] != $box_row) { pr($new_line);die('ERR_parse_all_boxes_['.$work_sheet.']_line_>5'); }
					unset($new_line['1']);
					foreach($new_line as $key => $value) {
						$box_column = ($key - 1);
						if($box_column > 10) continue;
						$value = str_replace(array("\n", '  '), array(' ', ' '), $value);
						Config::$storage_data_from_label[$value] = array('excel_value' => $value, 'x' => $box_column, 'y' => $box_row);
					}
				} else {
					
//TODO Ajouter un message de warning ou ajouter le commentaire dans la note
					
					
					
				}
			}
		}
	}
	
	//recordChildrenStorage(Config::$storages);
	exit;
}

//=========================================================================================================
// Storage Record
//=========================================================================================================

function recordChildrenStorage($children_storages, $parent_selection_label = '', $parent_id = null) {
	if(empty($children_storages)) die('ERR 88838383');
	
	foreach($children_storages as $storage_label => $storage_content) {
		$storage_master_id = null;
		if(isset($storage_content['id'])) {
			$storage_master_id = $storage_content['id'];
			unset($storage_content['id']);
			if(!empty($storage_content)) die('ERR 9988998');
		} else {
			$storage_master_id = getNewtStorageId();
		}
		
		if(!preg_match('/^([a-zA-Z0-9\ ]+)\[(.+)\]\((.*)-(.*)\)$/', $storage_label, $matches)) die('ERR 8839939393 '.$storage_label);
		if(!isset(Config::$storage_controls[$matches[1]])) die('ERR 8111119393 '.$storage_label);
		
		$storage_control = Config::$storage_controls[$matches[1]];
		$short_label = $matches[2];
		$selection_label = $parent_selection_label.(empty($parent_selection_label)? '' : '-').$short_label;
		
		$master_fields = array(
				"id" => $storage_master_id,
				"code" => $storage_master_id,
				"short_label" => $short_label,
				"selection_label" => $selection_label,
				"storage_control_id" => $storage_control['storage_control_id'],
				"parent_id" => $parent_id,
				"parent_storage_coord_x" => $matches[3],
				"parent_storage_coord_y" => $matches[4],
				"lft" => getNextLeftRight()
		);
		$storage_master_id = customInsertRecord($master_fields, 'storage_masters');
		customInsertRecord(array("storage_master_id" => $storage_master_id), $storage_control['detail_tablename'], true);
		
		if($storage_content) recordChildrenStorage($storage_content, $selection_label, $storage_master_id);
		
		$rght =  getNextLeftRight();
		$query = "UPDATE storage_masters SET rght = $rght WHERE id = $storage_master_id";
		mysqli_query(Config::$db_connection, $query) or die("Error on StorageMaster.rght value update. [$query] ");
		if(Config::$insert_revs){
			$query = str_replace('storage_masters','storage_masters_revs',$query);
			mysqli_query(Config::$db_connection, $query) or die("Error on StorageMaster.rght value update. [$query] ");
		}
	}
	return;
}

function getNewtStorageId() {
	Config::$previous_storage_master_id++;
	return Config::$previous_storage_master_id;
}

function getNextLeftRight() {
	Config::$previous_left_right++;
	return Config::$previous_left_right;
}

