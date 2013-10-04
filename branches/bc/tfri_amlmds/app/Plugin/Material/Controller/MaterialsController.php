<?php

class MaterialsController extends MaterialAppController {
	var $uses = array('Material.Material');
	var $paginate = array('Material'=>array('limit' => pagination_amount,'order'=>'Material.item_name'));
	
	function index() {
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
	
	function search($search_id){
		// MANAGE FORM, MENU AND ACTION BUTTONS
		$this->set( 'atim_menu', $this->Menus->get('/material/materials/index/') );	

		$this->searchHandler($search_id, $this->Material, 'materials', '/material/materials/search');
				
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}

	function add() {
		$this->set( 'atim_menu', $this->Menus->get('/material/materials/index/') );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA		
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if ( !empty($this->request->data) ) {
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}	
						
			if ( $submitted_data_validates && $this->Material->save($this->request->data) ) {
				$hook_link = $this->hook('postsave_process');
				if( $hook_link ) {
					require($hook_link);
				}
				$this->atimFlash( 'your data has been updated','/material/materials/detail/'.$this->Material->id );
			}
		}		
  	}
  
	function edit( $material_id=null ) {

		$material_data = $this->Material->getOrRedirect($material_id);
		
		$this->set( 'atim_menu_variables', array('Material.id'=>$material_id) );
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	
		if ( empty($this->request->data) ) {
			$this->request->data = $material_data;
		} else { 			
			$submitted_data_validates = true;
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { 
				require($hook_link); 
			}			
			
			if($submitted_data_validates) {
				$this->Material->id = $material_id;
				if ( $this->Material->save($this->request->data) ) {
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash( 'your data has been updated','/material/materials/detail/'.$material_id );
				}
			}
		}		
  	}
	
	function detail( $material_id=null ) {
		if ( !$material_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		$this->set( 'atim_menu_variables', array('Material.id'=>$material_id) );
		
		$this->request->data = $this->Material->find('first',array('conditions'=>array('Material.id'=>$material_id)));
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }		
	}
  
	function delete( $material_id=null ) {
		if ( !$material_id ) { $this->redirect( '/Pages/err_plugin_funct_param_missing?method='.__METHOD__.',line='.__LINE__, NULL, TRUE ); }
		
		// CUSTOM CODE: FORMAT DISPLAY DATA
		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
		
		if( $this->Material->atimDelete( $material_id ) ) {
			$this->atimFlash( 'your data has been deleted', '/material/materials/index/');
		} else {
			$this->flash( 'error deleting data - contact administrator', '/material/materials/listall/');
		}
  	}

}

?>