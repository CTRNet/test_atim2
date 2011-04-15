<?php

class StructureFormatsController extends AdministrateAppController {
	
	var $uses = array('StructureFormat');
	var $paginate = array('StructureFormat'=>array('limit' => pagination_amount,'order'=>'StructureFormat.id ASC')); 
	
	function listall( $structure_id ) {
		$this->set( 'atim_structure', $this->Structures->get(NULL,'fields') );
		$this->set( 'atim_menu_variables', array('Structure.id'=>$structure_id) );
		
		$this->hook();
		
		$this->data = $this->paginate($this->StructureFormat, array('StructureFormat.structure_id'=>$structure_id));
	}
	
	function detail( $structure_id, $structure_format_id ) {
		$this->set( 'atim_structure', $this->Structures->get(NULL,'fields') );
		$this->set( 'atim_menu_variables', array('Structure.id'=>$structure_id, 'StructureFormat.id'=>$structure_format_id) );
		
		$this->hook();
		
		$this->data = $this->StructureFormat->find('first',array('conditions'=>array('StructureFormat.id'=>$structure_format_id)));
	}
	
	function edit( $structure_id, $structure_format_id ) {
		$this->set( 'atim_structure', $this->Structures->get(NULL,'fields') );
		$this->set( 'atim_menu_variables', array('Structure.id'=>$structure_id, 'StructureFormat.id'=>$structure_format_id) );
		
		$this->hook();
		
		if ( !empty($this->data) ) {
			if ( $this->StructureFormat->save($this->data) ) $this->atimFlash( 'your data has been updated','/administrate/structure_formats/detail/'.$structure_id.'/'.$structure_format_id );
		} else {
			$this->data = $this->StructureFormat->find('first',array('conditions'=>array('StructureFormat.id'=>$structure_format_id)));
		}
	}	
}

?>