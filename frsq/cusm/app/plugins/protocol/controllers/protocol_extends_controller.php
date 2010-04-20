<?php

class ProtocolExtendsController extends ProtocolAppController {

	var $uses = array(
		'Protocol.ProtocolExtend',
		'Protocol.ProtocolMaster',
		'Protocol.ProtocolControl',
		'Drug.Drug');
	var $paginate = array('ProtocolExtend'=>array('limit' => pagination_amount,'order'=>'ProtocolExtend.id DESC'));

	function listall($protocol_master_id){
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));

		$protocol_master_data = $this->ProtocolMaster->find('first', array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));

		$this->ProtocolExtend = new ProtocolExtend(false, $protocol_master_data['ProtocolControl']['extend_tablename']);
		$use_form_alias = $protocol_master_data['ProtocolControl']['extend_form_alias'];
		$this->Structures->set($use_form_alias);

		$this->data = $this->paginate($this->ProtocolExtend, array('ProtocolExtend.protocol_master_id'=>$protocol_master_id));

		$drug_list = $this->Drug->find('list', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		$this->set('drug_list', $drug_list);

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function detail($protocol_master_id=null, $protocol_extend_id=null) {

		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id, 'ProtocolExtend.id'=>$protocol_extend_id));

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));

		// Set form alias/tablename to use
		$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolControl']['extend_tablename'] );
		$use_form_alias = $protocol_master_data['ProtocolControl']['extend_form_alias'];
		$this->Structures->set($use_form_alias );

		$this->data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id)));
	  
		// Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('list', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		$this->set('drug_list', $drug_list);

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }
	}

	function add($protocol_master_id=null) {
		$this->set('atim_menu_variables', array('ProtocolMaster.id'=>$protocol_master_id));

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));

		// Set form alias/tablename to use
		$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolControl']['extend_tablename'] );
		$use_form_alias = $protocol_master_data['ProtocolControl']['extend_form_alias'];
		$this->Structures->set($use_form_alias );

		// Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('list', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		$this->set('drug_list', $drug_list);

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if ( !empty($this->data) ) {
			$this->data['ProtocolExtend']['protocol_master_id'] = $protocol_master_data['ProtocolMaster']['id'];
				
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }
				
			if ($submitted_data_validates && $this->ProtocolExtend->save( $this->data ) ) {
				$this->flash( 'your data has been saved', '/protocol/protocol_extends/listall/'.$protocol_master_id );
			}
		}
	}

	function edit($protocol_master_id=null, $protocol_extend_id=null) {

		$this->set('atim_menu_variables', array(
			'ProtocolMaster.id'=>$protocol_master_id,
			'ProtocolExtend.id'=>$protocol_extend_id
		));

		// Get treatment master row for extended data
		$protocol_master_data = $this->ProtocolMaster->find('first',array('conditions'=>array('ProtocolMaster.id'=>$protocol_master_id)));

		// Set form alias/tablename to use
		$this->ProtocolExtend = new ProtocolExtend( false, $protocol_master_data['ProtocolControl']['extend_tablename'] );
		$use_form_alias = $protocol_master_data['ProtocolControl']['extend_form_alias'];
		$this->Structures->set($use_form_alias);

		// Get all drugs to override drug_id with generic drug name
		$drug_list = $this->Drug->find('list', array('fields' => array('Drug.id', 'Drug.generic_name'), 'order' => array('Drug.generic_name')));
		$this->set('drug_list', $drug_list);
	  
		$this_data = $this->ProtocolExtend->find('first',array('conditions'=>array('ProtocolExtend.id'=>$protocol_extend_id)));

		$hook_link = $this->hook('format');
		if( $hook_link ) { require($hook_link); }

		if (!empty($this->data)) {
			$this->ProtocolExtend->id = $protocol_extend_id;
				
			$submitted_data_validates = true;
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) { require($hook_link); }

			if ($submitted_data_validates && $this->ProtocolExtend->save($this->data)) {
				$this->flash( 'your data has been updated','/protocol/protocol_extends/detail/'.$protocol_master_id.'/'.$protocol_extend_id);
			}
		} else {
			$this->data = $this_data;
		}
	}

	function delete($protocol_master_id=null, $protocol_extend_id=null) {

		$hook_link = $this->hook('delete');
		if( $hook_link ) { require($hook_link); }

		$this->ProtocolExtend->del( $protocol_extend_id );
		$this->flash( 'your data has been deleted', '/protocol/protocol_extends/listall/'.$protocol_master_id );

	}
}

?>