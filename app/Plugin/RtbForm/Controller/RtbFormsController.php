<?php

class RtbformsController extends RtbformAppController {
	
	var $uses = array('Rtbform.Rtbform');
	var $paginate = array('Rtbform'=>array('limit' => pagination_amount,'order'=>'Rtbform.frmTitle'));
  
	function index() {
		$this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
	}
  
	function search($search_id) {
		$this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		$this->set( 'atim_menu', $this->Menus->get('/rtbform/rtbforms/index') );
		$this->searchHandler($search_id, $this->Rtbform, 'rtbforms', '/rtbform/rtbforms/search');
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link); 
		}
	}
	
	function profile( $rtbform_id=null ) {$this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		if ( !$rtbform_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
  
		$this->set( 'atim_menu_variables', array('Rtbform.id'=>$rtbform_id) );
		
		$this->hook();
		
		$this->request->data = $this->Rtbform->find('first',array('conditions'=>array('Rtbform.id'=>$rtbform_id)));
	}
  

	function add() {$this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		$this->hook();
	
		if ( !empty($this->request->data) ) {
			if ( $this->Rtbform->save($this->request->data) ) $this->atimFlash( 'your data has been updated','/rtbform/rtbforms/profile/'.$this->Rtbform->id );
		}
	}
  

	function edit( $rtbform_id=null ) {$this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		if ( !$rtbform_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Rtbform.id'=>$rtbform_id) );
		
		$this->hook();
		
		if ( !empty($this->request->data) ) {
			$this->Rtbform->id = $rtbform_id;
			if ( $this->Rtbform->save($this->request->data) ) {
				$this->atimFlash( 'your data has been updated','/rtbform/rtbforms/profile/'.$rtbform_id );
			}
		} else {
			$this->request->data = $this->Rtbform->find('first',array('conditions'=>array('Rtbform.id'=>$rtbform_id)));
		}
	}
  
	function delete( $rtbform_id=null ) {$this->redirect( '/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, NULL, TRUE );
		if ( !$rtbform_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$this->hook();
		
		if( $this->Rtbform->atimDelete( $rtbform_id ) ) {
			$this->atimFlash( 'your data has been deleted', '/rtbform/rtbforms/search/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/rtbform/rtbforms/search/');
		}
	}
  
}

?>