<?php
class StorageMasterCustom extends StorageMaster {
	var $useTable = 'storage_masters';
	var $name = 'StorageMaster';
	
	private $chum_patho_tanslated_values_for_layout_display = array();
	private $chum_patho_studies_for_layout_display = array();
	private $chum_patho_tma_blocks_for_layout_display = array();
	
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
		if(empty($this->chum_patho_tanslated_values_for_layout_display)) {
			$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
			foreach(array('Tissue Categories', 'Tissue Sources', 'TMA/MTB Slide Utilisations') as $key) {
				$liste = $StructurePermissibleValuesCustom->getCustomDropdown(array($key));
				$liste = array_merge($liste['defined'], $liste['previously_defined']);
				$this->chum_patho_tanslated_values_for_layout_display[$key] = $liste;
			}
		}
		if($type_key == 'AliquotMaster') {
			$ViewAliquotModel = AppModel::getInstance('InventoryManagement', 'ViewAliquot', true);
			$aliquot_data = $ViewAliquotModel->find('first', array('conditions' => array('ViewAliquot.aliquot_master_id' => $children_array['AliquotMaster']['id']), 'recursive' => '-1'));
			return $aliquot_data['ViewAliquot']['aliquot_label'].' '.
				(isset($this->chum_patho_tanslated_values_for_layout_display['Tissue Sources'][$aliquot_data['ViewAliquot']['tissue_source']])? $this->chum_patho_tanslated_values_for_layout_display['Tissue Sources'][$aliquot_data['ViewAliquot']['tissue_source']] : $aliquot_data['ViewAliquot']['tissue_source']).' '.
				(isset($this->chum_patho_tanslated_values_for_layout_display['Tissue Categories'][$aliquot_data['ViewAliquot']['chum_patho_category']])? $this->chum_patho_tanslated_values_for_layout_display['Tissue Categories'][$aliquot_data['ViewAliquot']['chum_patho_category']] : $aliquot_data['ViewAliquot']['chum_patho_category']).' '.
				' ['.$aliquot_data['ViewAliquot']['barcode'].']';
		} else if($type_key == 'TmaSlide') {
			if(!isset($this->chum_patho_studies_for_layout_display[$children_array['TmaSlide']['study_summary_id']])) {
				$StudySummaryModel = AppModel::getInstance('Study', 'StudySummary', true);
				$study_data = $StudySummaryModel->find('first', array('conditions' => array('StudySummary.id' => $children_array['TmaSlide']['study_summary_id'])));
				$this->chum_patho_studies_for_layout_display[$children_array['TmaSlide']['study_summary_id']] = $study_data? $study_data['StudySummary']['title'] : '?';
			}
			if(!isset($this->chum_patho_tma_blocks_for_layout_display[$children_array['TmaSlide']['tma_block_storage_master_id']])) {
				$tma_data = $this->find('first', array('conditions' => array('StorageMaster.id' => $children_array['TmaSlide']['tma_block_storage_master_id']), 'recursive' => '-1'));
				$this->chum_patho_tma_blocks_for_layout_display[$children_array['TmaSlide']['tma_block_storage_master_id']] = $tma_data? $tma_data['StorageMaster']['short_label'] : '?';
			}
			return $this->chum_patho_tma_blocks_for_layout_display[$children_array['TmaSlide']['tma_block_storage_master_id']].' '.
				(isset($this->chum_patho_tanslated_values_for_layout_display['TMA/MTB Slide Utilisations'][$children_array['TmaSlide']['chum_patho_utilisations']])? $this->chum_patho_tanslated_values_for_layout_display['TMA/MTB Slide Utilisations'][$children_array['TmaSlide']['chum_patho_utilisations']] : $children_array['TmaSlide']['chum_patho_utilisations']).' '.
				$this->chum_patho_studies_for_layout_display[$children_array['TmaSlide']['study_summary_id']].
				' ['.$children_array['TmaSlide']['id'].']';
		}
	}
	
}

?>
