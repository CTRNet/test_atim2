<?php 
	if(!$this->Collection->atimDelete($collection_id, true)) {
	    $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	
	
	
	