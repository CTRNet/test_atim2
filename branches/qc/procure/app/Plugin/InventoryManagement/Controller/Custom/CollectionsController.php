<?php
class CollectionsControllerCustom extends CollectionsController{
	
	function template($collection_id, $template_id){
		if(Configure::read('procure_atim_version') != 'BANK') $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		parent::template($collection_id, $template_id);
	}
}