<?php

class RtbformsController extends RtbformAppController {
	
	var $uses = array('Rtbform.Rtbform');
	var $paginate = array('Rtbform'=>array('limit' => pagination_amount,'order'=>'Rtbform.frmTitle'));
  
	function index() {
		$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
	}
  
	function search($search_id) {
		$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		$this->set( 'atim_menu', $this->Menus->get('/rtbform/rtbforms/index') );
		$this->searchHandler($search_id, $this->Rtbform, 'rtbforms', '/rtbform/rtbforms/search');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function profile( $rtbform_id=null ) {$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		if ( !$rtbform_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
  
		$this->set( 'atim_menu_variables', array('Rtbform.id'=>$rtbform_id) );
		
		$this->hook();
		
		$this->data = $this->Rtbform->find('first',array('conditions'=>array('Rtbform.id'=>$rtbform_id)));
	}
  

	function add() {$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		$this->hook();
	
		if ( !empty($this->data) ) {
			if ( $this->Rtbform->save($this->data) ) $this->atimFlash( 'your data has been updated','/rtbform/rtbforms/profile/'.$this->Rtbform->id );
		}
	}
  

	function edit( $rtbform_id=null ) {$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		if ( !$rtbform_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Rtbform.id'=>$rtbform_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			$this->Rtbform->id = $rtbform_id;
			if ( $this->Rtbform->save($this->data) ) {
				$this->atimFlash( 'your data has been updated','/rtbform/rtbforms/profile/'.$rtbform_id );
			}
		} else {
			$this->data = $this->Rtbform->find('first',array('conditions'=>array('Rtbform.id'=>$rtbform_id)));
		}
	}
  
	function delete( $rtbform_id=null ) {$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		if ( !$rtbform_id ) { $this->redirect( '/pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$this->hook();
		
		if( $this->Rtbform->atim_delete( $rtbform_id ) ) {
			$this->atimFlash( 'your data has been deleted', '/rtbform/rtbforms/search/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/rtbform/rtbforms/search/');
		}
	}
  
}

?>