<?php

class MaterialsController extends MaterialAppController {
	var $uses = array('Material.Material');
	var $paginate = array('Material'=>array('limit' => pagination_amount,'order'=>'Material.item_name'));
	
	function index() {
		$_SESSION['ctrapp_core']['search'] = NULL; // clear SEARCH criteria
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function search(){
		if ( $this->data ) $_SESSION['ctrapp_core']['search']['criteria'] = $this->Structures->parse_search_conditions();
		
		$this->data = $this->paginate($this->Material, $_SESSION['ctrapp_core']['search']['criteria']);

		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/material/materials/index/') );	
				
		// if SEARCH form data, save number of RESULTS and URL
		$_SESSION['ctrapp_core']['search']['results'] = $this->params['paging']['Material']['count'];
		$_SESSION['ctrapp_core']['search']['url'] = '/material/materials/search';
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}

	function add() {
		$this->set( 'atim_menu', $this->Menus->get('/material/materials/index/') );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->data) ) {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }	
						
			if ( $submitted_data_validates && $this->Material->save($this->data) ) {
				$this->atimFlash( 'your data has been updated','/material/materials/detail/'.$this->Material->id );
			}
		}		
  	}
  
	function edit( $material_id=null ) {
		if ( !$material_id ) { $this->redirect( '/pages/err_mat_funct_param_missing', NULL, TRUE ); }

		$material_data = $this->Material->find('first',array('conditions'=>array('Material.id'=>$material_id)));
		if(empty($material_data)) { $this->redirect( '/pages/err_material_no_data', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Material.id'=>$material_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	
		if ( empty($this->data) ) {
			$this->data = $material_data;
		} else { 			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }			
			
			if($submitted_data_validates) {
				$this->Material->id = $material_id;
				if ( $this->Material->save($this->data) ) {
					$this->atimFlash( 'your data has been updated','/material/materials/detail/'.$material_id );
				}
			}
		}		
  	}
	
	function detail( $material_id=null ) {
		if ( !$material_id ) { $this->redirect( '/pages/err_mat_funct_param_missing', NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Material.id'=>$material_id) );
		
		$this->data = $this->Material->find('first',array('conditions'=>array('Material.id'=>$material_id)));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
  
	function delete( $material_id=null ) {
		if ( !$material_id ) { $this->redirect( '/pages/err_mat_funct_param_missing', NULL, TRUE ); }
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if( $this->Material->atim_delete( $material_id ) ) {
			$this->atimFlash( 'your data has been deleted', '/material/materials/index/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/material/materials/listall/');
		}
  	}

}

?>