<?php

class ClinicalAnnotationAppModel extends AppModel {
	
	function validateIcd10WhoCode($id){
		App::uses('CodingIcd.CodingIcd10Who', 'Model');
		return CodingIcd10Who::validateId($id);
	}
	
	function validateIcd10CaCode($id){
		return CodingIcd10Ca::validateId($id);
	}
	
	function validateIcdo3TopoCode($id){
		return CodingIcdo3Topo::validateId($id);
	}
	
	function validateIcdo3MorphoCode($id){
		return CodingIcdo3Morpho::validateId($id);
	}
	
	function afterSave(){
		if($this->name != 'Participant'){
			//manages Participant.last_modification and Participant.last_modification_ds_id
			$participant_id = null;
			if(isset($this->data[$this->name]['participant_id'])){
				$participant_id = $this->data[$this->name]['participant_id'];
			}else{
				$prev_data = $this->data;
				$curr_data = $this->findById($this->id);
				$this->data = $prev_data;
				$participant_id = $curr_data[$this->name]['participant_id'];
			}
			$datamart_structure_model = AppModel::getInstance('Datamart', 'DatamartStructure', true);
			$datamart_structure = $datamart_structure_model->find('first', array('conditions' => array('DatamartStructure.model' => $this->name)));
			if(!$datamart_structure){
				AppController::getInstance()->redirect( '/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true );
			}
			$participant_model = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
			$participant_model->check_writable_fields = false;
			$participant_model->id = $participant_id;
			$participant_model->save(array('last_modification' => $this->data[$this->name]['modified'], 'last_modification_ds_id' => $datamart_structure['DatamartStructure']['id']));
			$participant_model->check_writable_fields = true;
		}
	}
}

?>