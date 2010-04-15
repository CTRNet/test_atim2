<?php

class VersionsController extends AdministrateAppController {
	
	var $uses = array('Version');
	var $paginate = array('Version'=>array('limit' => pagination_amount,'order'=>'Version.version_number'));

	function detail () {
		// MANAGE DATA
		$version_data = $this->Version->find('first');
		if(empty($version_data)) { $this->redirect( '/pages/err_admin_no_data', null, true ); }
		$this->data = $version_data;		
	}
}
?>