<?php

	//Set aliquot master barcode
	$aliquots_to_update = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.barcode' => ''), 'recursive' => '-1'));
	foreach($aliquots_to_update as $new_al) {
		$this->AliquotMaster->data = array();
		$this->AliquotMaster->id = $new_al['AliquotMaster']['id'];
		if(!$this->AliquotMaster->save(array('AliquotMaster' => array('barcode' => $new_al['AliquotMaster']['id'])), false)) { 
			$this->redirect('/pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
	}
	