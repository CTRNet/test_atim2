<?php 

foreach($this->request->data as &$record){
	if(array_key_exists('AliquotMaster', $record)) {
		$record['AliquotMaster']['ovcare_clinical_aliquot'] = str_replace(array('yes','no'), array(__('clinical aliquot'),''),$record['AliquotMaster']['ovcare_clinical_aliquot']);
	}
}

?>