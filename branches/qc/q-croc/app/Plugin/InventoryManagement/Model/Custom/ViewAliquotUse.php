<?php

class ViewAliquotUseCustom extends ViewAliquotUse {
	var $base_model = "AliquotInternalUse";
	var $useTable = 'view_aliquot_uses';
	var $name = 'ViewAliquotUse'; 	
	
	const TRANSFER = 100;
	
	function __construct(){
		parent::__construct();
	
		parent::$models_details['SourceAliquot'][self::TRANSFER] = '"0"';
		parent::$models_details['Realiquoting'][self::TRANSFER] = '"0"';
		parent::$models_details['QualityCtrl'][self::TRANSFER] = '"0"';
		parent::$models_details['OrderItem'][self::TRANSFER] = '"0"';
		parent::$models_details['AliquotReviewMaster'][self::TRANSFER] = '"0"';
		parent::$models_details['AliquotInternalUse'][self::TRANSFER] = 'AliquotInternalUse.qcroc_is_transfer';
	}
	
	function findFastFromAliquotMasterId($aliquot_master_id){
	
		$data = array();
		foreach(parent::$models_details as $model_name => $model_conf){
			$model = AppModel::getInstance($model_conf[parent::PLUGIN], $model_name, true);
			$tmp_data = $model->find('all', array(
					'conditions' => array('AliquotMaster.id' => $aliquot_master_id),
					'joins' => $model_conf[parent::JOINS],
					'fields' => array(
							$model_conf[parent::SOURCE_ID].' AS id',
							'AliquotMaster.id AS aliquot_master_id',
							$model_conf[parent::USE_DEFINITION].' AS use_definition',
							$model_conf[parent::USE_CODE].' AS use_code',
							$model_conf[parent::USE_DETAIL].' AS use_details',
							$model_conf[parent::USE_VOLUME].' AS used_volume',
							$model_conf[parent::VOLUME_UNIT].' AS aliquot_volume_unit',
							$model_conf[parent::USE_DATETIME].' AS use_datetime',
							$model_conf[parent::USE_DATETIME_ACCU].' AS use_datetime_accuracy',
							$model_conf[parent::DURATION].' AS duration',
							$model_conf[parent::DURATION_UNIT].' AS duration_unit',
							$model_conf[parent::USE_BY].' AS used_by',
							$model_conf[parent::CREATED],
							$model_conf[parent::DETAIL_URL].' AS detail_url',
							$model_conf[parent::SAMPLE_MASTER_ID].' AS sample_master_id',
							$model_conf[parent::COLLECTION_ID].' AS collection_id',
							$model_conf[self::TRANSFER].' AS qcroc_is_transfer'
					)
			));
				
			foreach($tmp_data as $result_unit){
				$current = array();
				foreach($result_unit as $fields){
					$current += $fields;
				}
				$data[]['ViewAliquotUse'] = $current;
			}
		}
		return $data;
	}
	
	
	function getUseDefinitions() {
		$result = array(
			'aliquot shipment'	=> __('aliquot shipment'),
			'quality control'	=> __('quality control'),
			'internal use'	=> __('internal use'),
			'sample derivative creation'	=> __('sample derivative creation'),
			'realiquoted to'	=> __('realiquoted to'),
			'specimen review'	=> __('specimen review'));
		
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$use_and_event_types = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'aliquot use and event types')));
		foreach($use_and_event_types as $new_type) $result[$new_type['StructurePermissibleValuesCustom']['value']] = strlen($new_type['StructurePermissibleValuesCustom'][$lang])? $new_type['StructurePermissibleValuesCustom'][$lang] : $new_type['StructurePermissibleValuesCustom']['value'];
		
		$transfer_types = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'Aliquot Transfer: Types')));
		foreach($transfer_types as $new_type) $result[$new_type['StructurePermissibleValuesCustom']['value']] = __('aliquot transfer').' ('.(strlen($new_type['StructurePermissibleValuesCustom'][$lang])? $new_type['StructurePermissibleValuesCustom'][$lang] : $new_type['StructurePermissibleValuesCustom']['value']).')';
		
		asort($result);
		return $result;
	}
	
	function  getSitesAndHDQStaff() {
		$result = array();
		
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$all_values = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => array('Staff : Sites', 'Staff : HDQ'))));
		foreach($all_values as $new_value) $result[$new_value['StructurePermissibleValuesCustom']['value']] = strlen($new_value['StructurePermissibleValuesCustom'][$lang])? $new_value['StructurePermissibleValuesCustom'][$lang] : $new_value['StructurePermissibleValuesCustom']['value'];
		
		asort($result);
		return $result;
	}
	
	function  getLaboratoryStaff() {
		$result = array();
	
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
	
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$all_values = $StructurePermissibleValuesCustom->find('all', array('conditions' => array('StructurePermissibleValuesCustomControl.name' => array('Staff : JGH', 'Staff : HDQ'))));
		foreach($all_values as $new_value) $result[$new_value['StructurePermissibleValuesCustom']['value']] = strlen($new_value['StructurePermissibleValuesCustom'][$lang])? $new_value['StructurePermissibleValuesCustom'][$lang] : $new_value['StructurePermissibleValuesCustom']['value'];
	
		asort($result);
		return $result;
	}	
	
}

?>
