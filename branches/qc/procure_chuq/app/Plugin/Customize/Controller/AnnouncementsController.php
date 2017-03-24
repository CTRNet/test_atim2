<?php

class AnnouncementsController extends CustomizeAppController {
	
	var $uses = array('Announcement');
	var $paginate = array('Announcement'=>array('order'=>'Announcement.date DESC')); 
	
	function index($list_type = '') {
		
		$this->set('list_type', $list_type);
		
		if(!in_array($list_type, array('all', 'current'))) {
			
			// Nothing to do
			
			// CUSTOM CODE: FORMAT DISPLAY DATA
			$hook_link = $this->hook('format');
			if( $hook_link ) {
				require($hook_link);
			}
			
		} else {
			
			$conditions = array(
				'OR' => array(
					array('Announcement.bank_id'=> $_SESSION['Auth']['User']['Group']['bank_id']),
					array('Announcement.group_id' => $_SESSION['Auth']['User']['group_id'], 'Announcement.user_id' => $_SESSION['Auth']['User']['id'])
				)
			);
			
			if($list_type == 'current') {
				$conditions = array(
					$conditions,
					array('OR' =>
						array(
							array("Announcement.date = '".date("Y-m-d")."'"),
							array("Announcement.date_start <= '".date("Y-m-d")."'", "Announcement.date_end >= '".date("Y-m-d")."'")
						)
					)
				);
				
			}
			
			// CUSTOM CODE: FORMAT DISPLAY DATA
			$hook_link = $this->hook('format_conditions');
			if( $hook_link ) {
				require($hook_link);
			}
			
			$this->request->data = $this->paginate($this->Announcement, $conditions);
			
			// CUSTOM CODE: FORMAT DISPLAY DATA
			$hook_link = $this->hook('format_all_and_current');
			if( $hook_link ) {
				require($hook_link);
			}
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