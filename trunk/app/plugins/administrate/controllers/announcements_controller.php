<?php

class AnnouncementsController extends AdministrateAppController {
	
	var $uses = array('Administrate.Announcement');
	var $paginate = array('Announcement'=>array('limit' => pagination_amount,'order'=>'Announcement.date_start DESC')); 
	
	function beforeFilter() {
		parent::beforeFilter(); 
		$this->set('atim_menu', $this->Menus->get('/administrate/announcements/index/%%Group.id%%/%%User.id%%/'));
		
	}
	
	function add( $bank_id=0, $group_id=0, $user_id=0 ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id, 'Group.id'=>$group_id, 'User.id'=>$user_id));
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->data['Announcement']['bank_id'] = $bank_id;
			$this->data['Announcement']['group_id'] = $group_id;
			$this->data['Announcement']['user_id'] = $user_id;
			if ( $this->Announcement->save($this->data) ) {
				$this->atimFlash( 'your data has been updated','/administrate/announcements/detail/'.$bank_id.'/'.$group_id.'/'.$user_id.'/'.$this->Announcement->id );
			}
		}
	}
	
	function index($group_id=0, $user_id=0) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id, 'User.id'=>$user_id) );
		$this->hook();
		$this->data = $this->paginate($this->Announcement, array('Announcement.group_id'=>$group_id, 'Announcement.user_id'=>$user_id));
	}
	
	function detail( $bank_id=0, $group_id=0, $user_id=0, $announcement_id=null ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id, 'Group.id'=>$group_id, 'User.id'=>$user_id, 'Announcement.id'=>$announcement_id) );
		$this->hook();
		$this->data = $this->Announcement->find('first',array('conditions'=>array('Announcement.bank_id'=>$bank_id, 'Announcement.group_id'=>$group_id, 'Announcement.user_id'=>$user_id, 'Announcement.id'=>$announcement_id)));
	}
	
	function edit( $bank_id=0, $group_id=0, $user_id=0, $announcement_id=null ) {
		$this->set( 'atim_menu_variables', array('Bank.id'=>$bank_id, 'Group.id'=>$group_id, 'User.id'=>$user_id, 'Announcement.id'=>$announcement_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->Announcement->id = $announcement_id;
			if ( $this->Announcement->save($this->data) ) $this->atimFlash( 'your data has been updated','/administrate/announcements/detail/'.$bank_id.'/'.$group_id.'/'.$user_id.'/'.$announcement_id.'/');
		} else {
			$this->data = $this->Announcement->find('first',array('conditions'=>array('Announcement.bank_id'=>$bank_id, 'Announcement.group_id'=>$group_id, 'Announcement.user_id'=>$user_id, 'Announcement.id'=>$announcement_id)));
		}
	}
	
	function delete( $bank_id=0, $group_id=0, $user_id=0, $announcement_id=null ){
		$this->hook();
		
		if( $this->Announcement->del( $announcement_id ) ) {
			$this->atimFlash( 'your data has been deleted', '/administrate/announcements/index/'.$bank_id.'/'.$group_id.'/'.$user_id.'/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/administrate/announcements/index/'.$bank_id.'/'.$group_id.'/'.$user_id.'/');
		}
	}

}

?>