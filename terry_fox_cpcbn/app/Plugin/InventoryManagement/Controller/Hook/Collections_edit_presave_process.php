<?php
	
	if(isset($this->request->data['Collection']['collection_property']) && $collection_data['Collection']['collection_property'] != $this->request->data['Collection']['collection_property']) {
		$this->redirect('/Pages/err_plugin_system_error?method=Collection.edit(),line='.__LINE__, null, true);
	}

?>
