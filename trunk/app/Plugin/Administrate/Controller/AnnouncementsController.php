<?php

class AnnouncementsController extends AdministrateAppController {
	
	var $uses = array('Administrate.Announcement');
	var $paginate = array('Announcement'=>array('limit' => pagination_amount,'order'=>'Announcement.date_start DESC')); 
	
	function beforeFilter() {
		parent::beforeFilter(); 
		$this->set('atim_menu', $this->Menus->get('/Administrate/announcements/index/%%Group.id%%/%%User.id%%/'));
		
	}
	
	function add( $group_id=0, $user_id=0 ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id, 'User.id'=>$user_id));
		
		$this->hook();
		
		if ( !empty($this->request->data) ) {
			$this->request->data['Announcement']['group_id'] = $group_id;
			$this->request->data['Announcement']['user_id'] = $user_id;
			if ( $this->Announcement->save($this->request->data) ) {
			
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) { 
					require($hook_link); 
				}
				$this->atimFlash( 'your data has been updated','/Administrate/announcements/detail/'.$group_id.'/'.$user_id.'/'.$this->Announcement->id );
			}
		}
	}
	
	function index($group_id=0, $user_id=0) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id, 'User.id'=>$user_id) );
		$this->request->data = $this->paginate($this->Announcement, array('Announcement.group_id'=>$group_id, 'Announcement.user_id'=>$user_id));
		$this->hook();
	}
	
	function detail( $group_id=0, $user_id=0, $announcement_id=null ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id, 'User.id'=>$user_id, 'Announcement.id'=>$announcement_id) );
		$this->hook();
		$this->request->data = $this->Announcement->find('first',array('conditions'=>array('Announcement.group_id'=>$group_id, 'Announcement.user_id'=>$user_id, 'Announcement.id'=>$announcement_id)));
	}
	
	function edit( $group_id=0, $user_id=0, $announcement_id=null ) {
		$this->set( 'atim_menu_variables', array('Group.id'=>$group_id, 'User.id'=>$user_id, 'Announcement.id'=>$announcement_id) );
		
		$this->hook();
		
		if ( !empty($this->request->data) ) {
			$this->Announcement->id = $announcement_id;
			if ( $this->Announcement->save($this->request->data)){
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/Administrate/announcements/detail/'.$group_id.'/'.$user_id.'/'.$announcement_id.'/');
			}
		} else {
			$this->request->data = $this->Announcement->find('first',array('conditions'=>array('Announcement.group_id'=>$group_id, 'Announcement.user_id'=>$user_id, 'Announcement.id'=>$announcement_id)));
		}
	}
	
	function delete( $group_id=0, $user_id=0, $announcement_id=null ){
		$this->hook();
		
		if( $this->Announcement->atim_delete( $announcement_id ) ) {
			$this->atimFlash( 'your data has been deleted', '/Administrate/announcements/index/'.$group_id.'/'.$user_id.'/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/Administrate/announcements/index/'.$group_id.'/'.$user_id.'/');
		}
	}

}

?>