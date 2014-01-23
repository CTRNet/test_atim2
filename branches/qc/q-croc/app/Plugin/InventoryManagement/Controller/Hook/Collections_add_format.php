<?php
	
	if(!$need_to_save && !empty($copy_source) && !empty($this->request->data)) $this->request->data['FunctionManagement']['col_copy_binding_opt'] = 2;
