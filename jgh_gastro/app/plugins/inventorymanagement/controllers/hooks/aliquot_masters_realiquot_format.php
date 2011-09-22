<?php
	
	// --------------------------------------------------------------------------------
	// Set default aliquot barcode(s)
	// -------------------------------------------------------------------------------- 	
	$parent_aliquots = $this->AliquotMaster->find('all', array(
		'conditions' => array('AliquotMaster.id' => explode(",", $parent_aliquots_ids)),
		'recursive' => '-1'
	));
	if(empty($parent_aliquots)) { 
		$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
	}

	$default_aliquot_barcodes = array();
	foreach($parent_aliquots as $new_aliquot){
		$default_aliquot_barcodes[$new_aliquot['AliquotMaster']['id']] = $new_aliquot['AliquotMaster']['barcode'].'?';
	}
	$this->set('default_aliquot_barcodes', $default_aliquot_barcodes);
	
?>
