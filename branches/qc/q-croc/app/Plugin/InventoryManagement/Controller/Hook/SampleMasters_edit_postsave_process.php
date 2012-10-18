<?php
	
	foreach($aliquots_to_update as $new_aliquot_to_update_2) {
		$this->AliquotMaster->data = array();
		$this->AliquotMaster->id = $new_aliquot_to_update_2['AliquotMaster']['id'];
		if(!$this->AliquotMaster->save($new_aliquot_to_update_2, false)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	