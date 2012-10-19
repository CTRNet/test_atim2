<?php

class SopMasterCustom extends SopMaster
{
	var $name = 'SopMaster';
    var $useTable = 'sop_masters';
	
	function getCollectionSopPermissibleValues() {
		return $this->getAllSopPermissibleValues(array('SopControl.sop_group' => array('blood collection','biopsy')));
	}
	
	function getBlockSopPermissibleValues() {
		return $this->getAllSopPermissibleValues(array('SopControl.sop_group' => 'tissue block'));
	}		
	
	function getTissueSlideSopPermissibleValues() {
		return $this->getAllSopPermissibleValues(array('SopControl.sop_group' => 'tissue slide'));
	}		
	
	function getBloodPRocessingSopPermissibleValues() {
		return $this->getAllSopPermissibleValues(array('SopControl.sop_group' => 'blood processing'));
	}	
	
	function getDnaRnaExtractionSopPermissibleValues() {
		return $this->getAllSopPermissibleValues(array('SopControl.sop_group' => 'dna rna extraction'));
	}
	
	function getAllSopPermissibleValues($conditions = array()) {
		$result = array();
		$sop_versions = $this->getSopVersions();		
		foreach($this->find('all', array('conditions' => $conditions, 'order' => 'SopMaster.activated_date DESC')) as $sop) {
			$version = array_key_exists($sop['SopMaster']['version'], $sop_versions)? $sop_versions[$sop['SopMaster']['version']] : $sop['SopMaster']['version'];
			$result[$sop['SopMaster']['id']] = $sop['SopMaster']['code'].' ['.$sop['SopMaster']['activated_date']." | V#".$version.']';
		}
		return $result;
	}	
	
	function getSopVersions() {
		$StructurePermissibleValuesCustom = AppModel::getInstance('', 'StructurePermissibleValuesCustom', true);
		$sop_versions = $StructurePermissibleValuesCustom->find('all',array('conditions' => array('StructurePermissibleValuesCustomControl.name' => 'sop versions', 'StructurePermissibleValuesCustomControl.flag_active' => '1')));
		$res = array();
		$lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
		foreach($sop_versions as $new_vers) $res[$new_vers['StructurePermissibleValuesCustom']['value']] = empty($new_vers['StructurePermissibleValuesCustom'][$lang])? $new_vers['StructurePermissibleValuesCustom']['value'] : $new_vers['StructurePermissibleValuesCustom'][$lang];
		return $res;
	}
	
	function allowDeletion($sop_master_id) {
		$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
		$joins = array(array(
				'alias' => 'TreatmentDetail',
				'table' => 'qcroc_txd_liver_biopsies',
				'conditions' => array('TreatmentMaster.id = TreatmentDetail.treatment_master_id'),
				'type' => 'INNER'
		));
		$conditions = array(
				'TreatmentMaster.deleted <> 1',
				'TreatmentDetail.sop_master_id' => $sop_master_id
		);
		$ctrl_value = $TreatmentMaster->find('count', array('conditions' => $conditions, 'recursive' => '-1', 'joins' => $joins));
		if($ctrl_value > 0) {
			return array('allow_deletion' => false, 'msg' => 'sop is assigned to a biopsy');
		}
		
		return parent::allowDeletion($sop_master_id);
	}
	
}

?>