<?php

class TissueCodeDefintion extends InventorymanagementAppModel {
		
	var $useTable = 'chuq_tissue_code_defintions';

	function getTissueCodeList() {
		$result = array();
		
		foreach($this->find('all') as $new_record) {
			$result[$new_record['TissueCodeDefintion']['tissue_code']] = $new_record['TissueCodeDefintion']['tissue_code'];
		}
		asort($result);
		
		return $result;
	}
	
	function getTissueSourceList() {
		$result = array();
		
		foreach($this->find('all') as $new_record) {
			$result[$new_record['TissueCodeDefintion']['tissue_source']] = 'cccc'.__($new_record['TissueCodeDefintion']['tissue_source'],true);
		}
		asort($result);
		
		return $result;
	}
	
	function getTissueNatureList() {
		$result = array();
		
		foreach($this->find('all') as $new_record) {
			$result[$new_record['TissueCodeDefintion']['tissue_nature']] = 'acscascsa'.__($new_record['TissueCodeDefintion']['tissue_nature'],true);
		}
		asort($result);
		
		return $result;
	}

	function setTissueDefintionsFromCode (&$data) {
		if(!array_key_exists('chuq_tissue_code', $data['SampleDetail'])) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		if(empty($data['SampleDetail']['chuq_tissue_code'])) return;
		$def = $this->find('first', array('conditions' => array('TissueCodeDefintion.tissue_code' => $data['SampleDetail']['chuq_tissue_code'])));
		if(empty($def)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$data['SampleDetail']['tissue_source'] = $def['TissueCodeDefintion']['tissue_source'];
		$data['SampleDetail']['tissue_nature'] = $def['TissueCodeDefintion']['tissue_nature'];
		$data['SampleDetail']['tissue_laterality'] = $def['TissueCodeDefintion']['tissue_laterality'];
	}

}

?>
