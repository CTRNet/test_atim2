<?php

if(!empty($this->request->data) && isset($this->request->data['FunctionManagement']['col_copy_binding_opt']) && $this->request->data['FunctionManagement']['col_copy_binding_opt'] == '2') {
	$this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
}