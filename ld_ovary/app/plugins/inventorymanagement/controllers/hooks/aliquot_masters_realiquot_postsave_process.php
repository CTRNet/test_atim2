<?php

	//Set aliquot master barcode
	$aliquots_to_update = $this->AliquotMaster->find('all', array('conditions' => array('AliquotMaster.barcode' => ''), 'recursive' => '-1'));
	foreach($aliquots_to_update as $new_al) {
		$query_to_update = "UPDATE aliquot_masters SET aliquot_masters.barcode = aliquot_masters.id WHERE aliquot_masters.id = ".$new_al['AliquotMaster']['id'].";";
		if(!$this->AliquotMaster->query($query_to_update) 
		|| !$this->AliquotMaster->query(str_replace("aliquot_masters", "aliquot_masters_revs", $query_to_update))) {
			$this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true); 
		}
	}
	