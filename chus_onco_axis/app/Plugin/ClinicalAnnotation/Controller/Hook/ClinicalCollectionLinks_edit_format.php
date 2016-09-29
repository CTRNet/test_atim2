<?php 

	$this->Structures->set('treatmentmasters,chus_ccl_tx', 'atim_structure_tx');
	
	$this->TreatmentExtendMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentExtendMaster", true);
	$icd_o_3_topo_model = AppModel::getInstance('CodingIcd', 'CodingIcdo3Topo', true);		
	foreach($tx_data as &$tmp_new_tx) {
		$tmps_sites = array();
		foreach($this->TreatmentExtendMaster->find('all', array('conditions' => array('TreatmentExtendMaster.treatment_master_id' => $tmp_new_tx['TreatmentMaster']['id']))) as $tmp_new_tx_extend) {
			$tmp_icd_description = $this->CodingIcdo3Topo->getDescription($tmp_new_tx_extend['TreatmentExtendDetail']['surgical_site']);
			if($tmp_icd_description) $tmps_sites[$tmp_icd_description] = $tmp_icd_description;
		}
		ksort($tmps_sites);
		$tmp_new_tx['Generated']['chus_generated_ccl_tx_sites'] = implode(', ',$tmps_sites);
	}
	$this->set('tx_data', $tx_data);
	