<?php
class AliquotEventsController extends InventoryManagementAppController {
	
	var $uses = array(
		'InventoryManagement.AliquotMaster',
		'InventoryManagement.AliquotEvent',
		'IventoryManagement.SampleMaster'	
	);
	
	var $validate_params = null;
	
	function beforeFilter(){
		parent::beforeFilter();
		$aliquot = $this->AliquotMaster->getOrRedirect($this->passedArgs[2]);
		if($aliquot['AliquotMaster']['collection_id'] != $this->passedArgs[0] || $aliquot['AliquotMaster']['sample_master_id'] != $this->passedArgs[1]){
			$this->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__);
		}
		
		$this->Structures->set('aliquot_event');
		
		$sample = $this->SampleMaster->getOrRedirect($this->passedArgs[1]);
		
		$this->set('atim_menu', $this->Menus->get('/InventoryManagement/AliquotMasters/detail'));
		$this->set('atim_menu_variables', array(
			'Collection.id' => $this->passedArgs[0], 
			'SampleMaster.id' => $this->passedArgs[1], 
			'AliquotMaster.id' => $this->passedArgs[2],
			'AliquotEvent.id' => isset($this->passedArgs[3]) ? $this->passedArgs[3] : 0, 
			'SampleMaster.initial_specimen_sample_id' => $sample['SampleMaster']['initial_specimen_sample_id']	
			)
		);
	}
	
	function index($collection_id, $sample_master_id, $aliquot_master_id){
		$this->request->data = $this->AliquotEvent->find('all', array('conditions' => array('AliquotEvent.aliquot_master_id' => $aliquot_master_id)));
	}

	function add($collection_id, $sample_master_id, $aliquot_master_id){
		if($this->request->data){
			$submitted_data_validates = true;
			
			$this->request->data['AliquotEvent']['aliquot_master_id'] = $aliquot_master_id;
			$this->AliquotEvent->addWritableField('aliquot_master_id');
			
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link);
			}
			if($submitted_data_validates){
				if($this->AliquotEvent->save($this->request->data)){
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash('your data has been saved', '/InventoryManagement/AliquotMasters/detail/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id);
				}
			}
		}
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function edit($collection_id, $sample_master_id, $aliquot_master_id, $aliquot_event_id){
		$this->AliquotEvent->getOrRedirect($aliquot_event_id);//cannot go into beforeFilter nor calling without all args will work
		if($this->request->data){
			$submitted_data_validates = true;
				
			$this->request->data['AliquotEvent']['aliquot_master_id'] = $aliquot_master_id;
			$this->AliquotEvent->addWritableField('aliquot_master_id');
			$this->AliquotEvent->data = array();
				
			$hook_link = $this->hook('presave_process');
			if( $hook_link ) {
				require($hook_link);
			}
			if($submitted_data_validates){
				$this->AliquotEvent->id = $aliquot_event_id;
				if($this->AliquotEvent->save($this->request->data)){
					$hook_link = $this->hook('postsave_process');
					if( $hook_link ) {
						require($hook_link);
					}
					$this->atimFlash('your data has been saved', '/InventoryManagement/AliquotMasters/detail/'.$collection_id.'/'.$sample_master_id.'/'.$aliquot_master_id);
				}
			}
				
		}else{
			$this->request->data = $this->AliquotEvent->data;
		}
		
		$hook_link = $this->hook('format');
		if($hook_link){
			require($hook_link);
		}
	}
	
	function delete($collection_id, $sample_master_id, $aliquot_master_id, $aliquot_event_id){
		$this->AliquotEvent->getOrRedirect($aliquot_event_id);
		$arr_allow_deletion = $this->AliquotEvent->allowDeletion($aliquot_event_id);
			
		$hook_link = $this->hook('delete');
		if($hook_link){ 
			require($hook_link); 
		}		
		
		if($arr_allow_deletion['allow_deletion']) {
			if($this->AliquotEvent->atimDelete($aliquot_event_id)) {
				
				$hook_link = $this->hook('postsave_process');
				if($hook_link){ 
					require($hook_link); 
				}
				
				$this->atimFlash('your data has been deleted', '/InventoryManagement/AliquotMasters/detail/' . $collection_id . '/' . $sample_master_id.'/'.$aliquot_master_id);
			} else {
				$this->flash('error deleting data - contact administrator', '/InventoryManagement/AliquotEvent/detail/' . $collection_id . '/' . $sample_master_id.'/'.$aliquot_master_id.'/'.$aliquot_event_id);
			}
		} else {
			$this->flash($arr_allow_deletion['msg'], '/InventoryManagement/AliquotEvent/detail/' . $collection_id . '/' . $sample_master_id.'/'.$aliquot_master_id.'/'.$aliquot_event_id);
		}
	}
}