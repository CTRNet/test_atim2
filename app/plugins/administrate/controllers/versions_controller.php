<?php

class VersionsController extends AdministrateAppController {
	
	var $uses = array('Version');
	var $paginate = array('Version'=>array('limit'=>10,'order'=>'Version.version_number'));

	function listall( ) {
		$this->data = $this->paginate($this->Version, array());
	}
	
	function detail( $version_id=null ) {
		
		
		if ( !$version_id ) { $this->redirect( '/pages/err_clin-ann_no_part_id', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Version.id'=>$version_id) );
		$this->data = $this->Version->find('first',array('conditions'=>array('Version.id'=>$version_id)));
	}
}
?>