<?php
class StorageMasterCustom extends StorageMaster {
	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	private $chum_patho_tanslated_values_for_layout_display = array();
	
	function beforeSave($options = array()){
		if(isset($this->data['StorageDetail']) && isset($this->data['StorageDetail']['chum_patho_creation_date'])) {
			$this->data['StorageDetail']['chum_patho_creation_to_sould_out_months'] = '';
			if($this->data['StorageDetail']['chum_patho_creation_date'] && $this->data['StorageDetail']['chum_patho_sould_out_date'] 
			&& !in_array($this->data['StorageDetail']['chum_patho_creation_date_accuracy'], array('y','m')) && !in_array($this->data['StorageDetail']['chum_patho_sould_out_date_accuracy'], array('y','m'))) {
				$start_date = new DateTime($this->data['StorageDetail']['chum_patho_creation_date']);
				$end_date = new DateTime($this->data['StorageDetail']['chum_patho_sould_out_date']);
				$interval = $start_date->diff($end_date);
				if(!$interval->invert) {
					$this->data['StorageDetail']['chum_patho_creation_to_sould_out_months'] = ($interval->y*12 + $interval->m);
				}
			}
			$this->addWritableField(array('chum_patho_creation_to_sould_out_months'), 'std_tma_blocks');
		}
		$ret_val = parent::beforeSave($options);
		return $ret_val; 
	}
	
	function getLabel(array $children_array, $type_key, $label_key){
		if(($type_key == 'AliquotMaster')) {
			if(empty($this->chum_patho_tanslated_values_for_layout_display)) {
				$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
				foreach(array('Tissue Categories', 'Tissue Sources') as $key) {
					$liste = $StructurePermissibleValuesCustom->getCustomDropdown(array($key));
					$liste = array_merge($liste['defined'], $liste['previously_defined']);
					$this->chum_patho_tanslated_values_for_layout_display[$key] = $liste;
				}
			}
			$ViewAliquotModel = AppModel::getInstance('InventoryManagement', 'ViewAliquot', true);
			$aliquot_data = $ViewAliquotModel->find('first', array('conditions' => array('ViewAliquot.aliquot_master_id' => $children_array['AliquotMaster']['id']), 'recursive' => '-1'));
			return $aliquot_data['ViewAliquot']['aliquot_label'].' '.
				(isset($this->chum_patho_tanslated_values_for_layout_display['Tissue Sources'][$aliquot_data['ViewAliquot']['tissue_source']])? $this->chum_patho_tanslated_values_for_layout_display['Tissue Sources'][$aliquot_data['ViewAliquot']['tissue_source']] : $aliquot_data['ViewAliquot']['tissue_source']).' '.
				(isset($this->chum_patho_tanslated_values_for_layout_display['Tissue Categories'][$aliquot_data['ViewAliquot']['chum_patho_category']])? $this->chum_patho_tanslated_values_for_layout_display['Tissue Categories'][$aliquot_data['ViewAliquot']['chum_patho_category']] : $aliquot_data['ViewAliquot']['chum_patho_category']).' '.
				' ['.$aliquot_data['ViewAliquot']['barcode'].']';
		}
		return $children_array[$type_key][$label_key];
	}
	
}

?>
