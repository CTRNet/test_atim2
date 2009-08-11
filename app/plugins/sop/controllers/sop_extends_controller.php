<?php

class SopExtendsController extends SopAppController {

	var $uses = array(
		'Sop.SopExtend',
		'Sop.SopMaster',
		'Sop.SopControl',
		'Material.Material');
	var $paginate = array('SopMaster'=>array('limit'=>10,'order'=>'SopMaster.title DESC'));
	
	function listall($sop_master_id){
		$this->set('atim_menu_variables', array('SopMaster.id'=>$sop_master_id));
		
		$sop_master_data = $this->SopMaster->find('first', array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
		
		$this->SopExtend = new SopExtend(false, $sop_master_data['SopControl']['extend_tablename']);
		$use_form_alias = $sop_master_data['SopMaster']['extend_form_alias'];
		$this->set('atim_structure', $this->Structures->get('form', $use_form_alias));
		
		$this->data = $this->paginate($this->SopExtend, array('SopExtend.sop_master_id'=>$sop_master_id));
		
		$material_list = $this->Material->find('all', array('fields'=>array('Material.id', 'Material.item_name'), 'order'  => array('Material.item_name')));
		foreach( $material_list as $record){
			$material_id_findall[ $record['Material']['id'] ] = $record['Material']['item_name'];
		}
		$this->set('material_id_findall', $material_id_findall);
	}
	
	function detail($sop_master_id=null, $sop_extend_id=null) {
		
		$this->set('atim_menu_variables', array('SopMaster.id'=>$sop_master_id, 'SopExtend.id'=>$sop_extend_id));
		
		// Get treatment master row for extended data
		$sop_master_data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
		
		// Set form alias/tablename to use
		$this->SopExtend = new SopExtend( false, $sop_master_data['SopControl']['extend_tablename'] );
		$use_form_alias = $sop_master_data['SopMaster']['extend_form_alias'];
	    $this->set( 'atim_structure', $this->Structures->get( 'form', $use_form_alias ) );

	    $this->data = $this->SopExtend->find('first',array('conditions'=>array('SopExtend.id'=>$sop_extend_id)));
	    
		// Get all Materials to override Material_id with generic Material name
		$material_list = $this->Material->find('all', array('fields' => array('Material.id', 'Material.item_name'), 'order' => array('Material.item_name')));
		foreach ( $material_list as $record ) {
			$material_id_findall[ $record['Material']['id'] ] = $record['Material']['item_name'];
		}
		$this->set('material_id_findall', $material_id_findall);
		
	}

	function add($sop_master_id=null) {
		$this->set('atim_menu_variables', array('SopMaster.id'=>$sop_master_id));
		
		// Get treatment master row for extended data
		$sop_master_data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));

		// Set form alias/tablename to use
		$this->SopExtend = new SopExtend( false, $sop_master_data['SopControl']['extend_tablename'] );
		$use_form_alias = $sop_master_data['SopMaster']['extend_form_alias'];
	    $this->set( 'atim_structure', $this->Structures->get( 'form', $use_form_alias ) );

		// Get all Materials to override Material_id with generic Material name
		$material_list = $this->Material->find('all', array('fields' => array('Material.id', 'Material.item_name'), 'order' => array('Material.item_name')));
		foreach ( $material_list as $record ) {
			$material_id_findall[ $record['Material']['id'] ] = $record['Material']['item_name'];
		}
		$this->set('material_id_findall', $material_id_findall);
		
		if ( !empty($this->data) ) {
			$this->data['SopExtend']['sop_master_id'] = $sop_master_data['SopMaster']['id'];
			if ( $this->SopExtend->save( $this->data ) ) {
				$this->flash( 'Your data has been saved.', '/sop/sop_extends/listall/'.$sop_master_id );
			}
		} 
	}

	function edit($sop_master_id=null, $sop_extend_id=null) {
		
		$this->set('atim_menu_variables', array(
			'SopMaster.id'=>$sop_master_id,
			'SopExtend.id'=>$sop_extend_id
		));
		
		// Get treatment master row for extended data
		$sop_master_data = $this->SopMaster->find('first',array('conditions'=>array('SopMaster.id'=>$sop_master_id)));
				
		// Set form alias/tablename to use
		$this->SopExtend = new SopExtend( false, $sop_master_data['SopControl']['extend_tablename'] );
		$use_form_alias = $sop_master_data['SopMaster']['extend_form_alias'];
	    $this->set('atim_structure', $this->Structures->get('form', $use_form_alias));

	    // Get all Materials to override Material_id with generic Material name
		$material_list = $this->Material->find('all', array('fields' => array('Material.id', 'Material.item_name'), 'order' => array('Material.item_name')));
		foreach ( $material_list as $record ) {
			$material_id_findall[ $record['Material']['id'] ] = $record['Material']['item_name'];
		}
		$this->set('material_id_findall', $material_id_findall);
	    
	    $this_data = $this->SopExtend->find('first',array('conditions'=>array('SopExtend.id'=>$sop_extend_id)));

	    if (!empty($this->data)) {
			$this->SopExtend->id = $sop_extend_id;
			if ($this->SopExtend->save($this->data)) {
				$this->flash( 'Your data has been updated.','/sop/sop_extends/detail/'.$sop_master_id.'/'.$sop_extend_id);
			}
		} else {
			$this->data = $this_data;
		}
	}

	function delete($sop_master_id=null, $sop_extend_id=null) {

		$this->SopExtend->del( $sop_extend_id );
		$this->flash( 'Your data has been deleted.', '/sop/sop_extends/listall/'.$sop_master_id );

	}

}

?>
