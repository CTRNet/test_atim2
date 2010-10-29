<?php

class AliquotMaster extends InventoryManagementAppModel {

	var $belongsTo = array(       
		'AliquotControl' => array(           
			'className'    => 'Inventorymanagement.AliquotControl',            
			'foreignKey'    => 'aliquot_control_id'), 
		'Collection' => array(           
			'className'    => 'Inventorymanagement.Collection',            
			'foreignKey'    => 'collection_id'),          
		'SampleMaster' => array(           
			'className'    => 'Inventorymanagement.SampleMaster',            
			'foreignKey'    => 'sample_master_id'),        
		'StorageMaster' => array(           
			'className'    => 'Storagelayout.StorageMaster',            
			'foreignKey'    => 'storage_master_id'));
                                 
	var $hasMany = array(
		'AliquotUse' => array(
			'className'   => 'Inventorymanagement.AliquotUse',
			'foreignKey'  => 'aliquot_master_id'),
		'RealiquotingParent' => array(
			'className' => 'Inventorymanagement.Realiquoting',
			'foreignKey' => 'child_aliquot_master_id'),
		'RealiquotingChildren' => array(
			'className' => 'Inventorymanagement.Realiquoting',
			'foreignKey' => 'parent_aliquot_master_id'));
	
	var $hasOne = array(
		'SpecimenDetail' => array(
			'className'   => 'Inventorymanagement.SpecimenDetail',
			 	'foreignKey'  => 'sample_master_id',
			 	'dependent' => true)
	);
	
	function summary($variables=array()) {
		$return = false;
		
		if (isset($variables['Collection.id']) && isset($variables['SampleMaster.id']) && isset($variables['AliquotMaster.id'])) {
			
			$result = $this->find('first', array('conditions'=>array('AliquotMaster.collection_id'=>$variables['Collection.id'], 'AliquotMaster.sample_master_id'=>$variables['SampleMaster.id'], 'AliquotMaster.id'=>$variables['AliquotMaster.id'])));
					
			$return = array(
				'Summary'	 => array(
					'menu'	        	=> array(null, __($result['AliquotMaster']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['barcode']),
					'title'		  		=> array(null, __($result['AliquotMaster']['aliquot_type'], true) . ' : '. $result['AliquotMaster']['barcode']),

					'description'		=> array(
						__('barcode', true)=> $result['AliquotMaster']['barcode'],
						__('product code', true)=> $result['AliquotMaster']['product_code'],
						__('type', true)	    => __($result['AliquotMaster']['aliquot_type'], true).($result['AliquotMaster']['aliquot_type'] == "block" ? " (".__($result['AliquotDetail']['block_type'], true).")": ""),
						__('aliquot in stock', true)		=> __($result['AliquotMaster']['in_stock'], true)
					)
				)
			);
		}
		
		return $return;
	}
	
	function getStorageHistory($aliquot_master_id){
		$storage_data = array();

		$qry = "SELECT sm.*, am.* FROM aliquot_masters_revs AS am
				LEFT JOIN  aliquot_masters_revs AS amn ON amn.version_id=(SELECT version_id FROM aliquot_masters_revs WHERE id=am.id AND version_id > am.version_id ORDER BY version_id ASC LIMIT 1)
				LEFT JOIN storage_masters_revs AS sm ON am.storage_master_id=sm.id
				LEFT JOIN storage_masters_revs AS smn ON smn.version_id=(SELECT version_id FROM storage_masters_revs WHERE id=sm.id AND version_id > sm.version_id ORDER BY version_id ASC LIMIT 1)
				WHERE am.id='".$aliquot_master_id."' AND ((am.modified > sm.modified AND (am.modified < smn.modified OR smn.modified IS NULL)) OR (sm.modified > am.modified AND (sm.modified < amn.modified OR amn.modified IS NULL)) OR am.storage_master_id IS NULL)";
		$storage_data_tmp = $this->query($qry);
		
		$previous = array_shift($storage_data_tmp);
		while($current = array_shift($storage_data_tmp)){
			if($previous['sm']['id'] != $current['sm']['id']){
				//filter 1 - new storage
				$storage_data[]['custom'] = array(
					'date' => $current['am']['modified'], 
					'event' => __('new storage', true)." "
						.__('from', true).": [".(strlen($previous['sm']['selection_label']) > 0 ? $previous['sm']['selection_label']." ".__('temperature', true).": ".$previous['sm']['temperature'].__($previous['sm']['temp_unit'], true) : __('no storage', true))."] "
						.__('to', true).": [".(strlen($current['sm']['selection_label']) > 0 ? $current['sm']['selection_label']." ".__('temperature', true).": ".$current['sm']['temperature'].__($current['sm']['temp_unit'], true) : __('no storage', true))."]");
			}else if($previous['sm']['temperature'] != $current['sm']['temperature'] || $previous['sm']['selection_label'] != $current['sm']['selection_label']){
				//filter 2, storage changes (temperature, label)
				$event = "";
				if($previous['sm']['temperature'] != $current['sm']['temperature']){
					$event .= __('storage temperature changed', true).". "
						.__('from', true).": ".(strlen($previous['sm']['temperature']) > 0 ? $previous['sm']['temperature'] : "?").__($previous['sm']['temp_unit'], true)." "
						.__('to', true).": ".(strlen($current['sm']['temperature']) > 0 ? $current['sm']['temperature'] : "?").__($current['sm']['temp_unit'], true).". ";
				}
				if($previous['sm']['selection_label'] != $current['sm']['selection_label']){
					$event .= __("selection label updated", true).". ".__("from", true).": ".$previous['sm']['selection_label']." ".__("to", true).": ".$current['sm']['selection_label'].". ";
				}
				$storage_data[]['custom'] = array(
					'date' => $current['sm']['modified'], 
					'event' => $event);
			}else if($previous['am']['storage_coord_x'] != $current['am']['storage_coord_x'] || $previous['am']['storage_coord_y'] != $current['am']['storage_coord_y']){
				//filter 3, aliquot position change
				$coord_from = $previous['am']['storage_coord_x'].", ".$previous['am']['storage_coord_y'];
				$coord_to = $current['am']['storage_coord_x'].", ".$current['am']['storage_coord_y'];
				$storage_data[]['custom'] = array(
					'date' => $current['am']['modified'], 
					'event' => __('moved within storage', true)." ".__('from', true).": [".$coord_from."] ".__('to', true).": [".$coord_to."]. ");
			}
			
			$previous = $current;
		}
		
		return $storage_data;
	}
	
}

?>
