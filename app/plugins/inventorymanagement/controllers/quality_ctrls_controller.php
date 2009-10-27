<?php

class QualityCtrlsController extends InventoryManagementAppController {
	
	var $uses = array(
			'AliquotMaster',
			'AliquotUse',
			'Collection',
			'QcTestedAliquot',
			'QualityCtrl',
			'SampleMaster'
	);
	var $paginate = array('QualityCtrl'=>array('limit'=>10));

	function listall( $collection_id=null, $sample_master_id=null) {
		$this->data = $this->paginate($this->QualityCtrl,array('QualityCtrl.sample_master_id'=>$sample_master_id));
		$storage_data = $this->SampleMaster->find('first',array('conditions'=>array('id'=>$sample_master_id)));
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $storage_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $sample_master_id,
			'SampleMaster.initial_specimen_sample_id' => $storage_data['SampleMaster']['initial_specimen_sample_id']) );
	}

	function add($collection_id=null, $sample_master_id){
		$storage_data = $this->SampleMaster->find('first',array('conditions'=>array('id'=>$sample_master_id)));
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $storage_data['SampleMaster']['collection_id'], 
				'SampleMaster.id' => $sample_master_id,
				'SampleMaster.initial_specimen_sample_id' => $storage_data['SampleMaster']['initial_specimen_sample_id']) 
		);
		
		//manual override	
		//$this->set( 'atim_menu', $this->Menus->get('/inventorymanagement/quality_ctrls/listall/') );
		if ( !empty($this->data) ) {
			//pr($this->data);
			$this->data['QualityCtrl']['sample_master_id'] = $sample_master_id;
			if ( $this->QualityCtrl->save( $this->data )) {
				$this->flash( 'Your data has been saved.', 
					'/inventorymanagement/quality_ctrls/detail/'.$this->QualityCtrl->id.'/' );
			}
		}
	}
	
	function detail($quality_ctrl_id=null) {
		$this->data = $this->QualityCtrl->find('first',array('conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id)));
		$storage_data = $this->SampleMaster->find('first',array('conditions'=>array('id'=>$this->data['QualityCtrl']['sample_master_id'])));
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $storage_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $this->data['QualityCtrl']['sample_master_id'],
			'SampleMaster.initial_specimen_sample_id' =>  $storage_data['SampleMaster']['initial_specimen_sample_id'],
			'QualityCtrl.id' => $quality_ctrl_id) );
	}
	
	function edit($quality_ctrl_id=null) {
		$this_data = $this->QualityCtrl->find('first',array('conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id)));
		$storage_data = $this->SampleMaster->find('first',array('conditions'=>array('id'=>$this_data['QualityCtrl']['sample_master_id'])));
		$this->set( 'atim_menu_variables', 
			array('Collection.id' => $storage_data['SampleMaster']['collection_id'], 
			'SampleMaster.id' => $this_data['QualityCtrl']['sample_master_id'],
			'SampleMaster.initial_specimen_sample_id' =>  $storage_data['SampleMaster']['initial_specimen_sample_id'],
			'QualityCtrl.id' => $quality_ctrl_id) );
	
		if ( !empty($this->data) ) {
			$this->QualityCtrl->id = $quality_ctrl_id;
			$this->data['QualityCtrl']['id'] = $quality_ctrl_id;
			if ( $this->QualityCtrl->save( $this->data )) {
				$this->flash( 'Your data has been saved.', 
					'/inventorymanagement/quality_ctrls/detail/'.$quality_ctrl_id.'/' );
			}
		}else{
			//$this->data = $this_data;
			$this->data = $this->QualityCtrl->find('first',array('conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id)));
		}
	
	}
		
	function delete($quality_ctrl_id=null) {
		$this->data = $this->QualityCtrl->find('first',array('conditions'=>array('QualityCtrl.id'=>$quality_ctrl_id)));
		$storage_data = $this->SampleMaster->find('first',array('conditions'=>array('id'=>$this->data['QualityCtrl']['sample_master_id'])));
		if( $this->QualityCtrl->atim_delete( $quality_ctrl_id ) ) {
			$this->flash( 'Your data has been deleted.', 
					'/inventorymanagement/quality_ctrls/listall/'
					.$storage_data['SampleMaster']['collection_id'].'/'
					.$this->data['QualityCtrl']['sample_master_id'].'/');
		}else{
			detail($quality_ctrl_id);
		}
	}
}
?>
