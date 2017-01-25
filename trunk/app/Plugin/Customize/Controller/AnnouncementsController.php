<?php

class AnnouncementsController extends CustomizeAppController {
	
	var $uses = array('Announcement');
	var $paginate = array('Announcement'=>array('order'=>'Announcement.date DESC')); 
	
	function index() {
		$conditions = array(
			'OR' => array(
				array('Announcement.bank_id'=> $_SESSION['Auth']['User']['Group']['bank_id']),
				array('Announcement.group_id' => $_SESSION['Auth']['User']['group_id'], 'Announcement.user_id' => $_SESSION['Auth']['User']['id'])
			)
		);
		
		$this->request->data = $this->paginate($this->Announcement, $conditions);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	}
	
	function detail( $announcement_id=NULL ) {
		$this->request->data = $this->Announcement->getOrRedirect($announcement_id);
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) {
			require($hook_link);
		}
	}
}

?>