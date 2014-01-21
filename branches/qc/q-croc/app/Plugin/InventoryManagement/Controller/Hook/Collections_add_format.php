<?php
	
	if(!$need_to_save) {
		$this->set('default_qcroc_protocol', 'Q-CROC-01');
		if(!empty($copy_source) && !empty($this->request->data)) $this->request->data['FunctionManagement']['col_copy_binding_opt'] = 2;
	}
