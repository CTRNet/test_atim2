<?php
class MergeController extends AdministrateAppController {
	
	function index(){
		$this->Structures->set('merge_index');
		AppController::addWarningMsg('merge operations are not reversible');
	}
	
	function mergeCollections(){
		$this->set('atim_menu', $this->Menus->get('/Administrate/Merge/index/'));
		
		if($this->request->data && $this->request->data['from'] && $this->request->data['to']){
			if($this->request->data['from'] == $this->request->data['to']){
				$this->set('validation_error', __('you cannot merge an item within itself'));
			}else{
				//merge!!
				$regexp = '#([\d]+)(/)?$#';
				$from = array();
				$to = array();
				assert(preg_match($regexp, $this->request->data['from'], $from));
				assert(preg_match($regexp, $this->request->data['to'], $to));
				$from = $from[1];
				$to = $to[1];
				
				$to_update = array(
					AppModel::getInstance('InventoryManagement', 'AliquotMaster'),
					AppModel::getInstance('InventoryManagement', 'SampleMaster'),
					AppModel::getInstance('InventoryManagement', 'SpecimenReviewMaster')
				);

				//update 1 by 1 to trigger right behavior + view updates properly
				foreach($to_update as $model){
					$ids = $model->find('list', array('conditions' => array($model->name.'.collection_id' => $from)));
					$update = array($model->name => array('collection_id' => $to));
					$model->check_writable_fields = false;
					foreach($ids as $id){
						$model->id = $id;
						$model->save($update, false);
					}
				}
				
				$collection_model = AppModel::getInstance('InventoryManagement', 'Collection');
				$collection_model->atimDelete($from);
				$this->atimFlash('merge complete', '/Administrate/Merge/index/');
			}
		}
	}
	
	function mergeParticipants(){
		$this->set('atim_menu', $this->Menus->get('/Administrate/Merge/index/'));
		
		if($this->request->data && $this->request->data['from'] && $this->request->data['to']){
			if($this->request->data['from'] == $this->request->data['to']){
				$this->set('validation_error', __('you cannot merge an item within itself'));
			}else{
				//merge!!
				$regexp = '#([\d]+)(/)?$#';
				$from = array();
				$to = array();
				assert(preg_match($regexp, $this->request->data['from'], $from));
				assert(preg_match($regexp, $this->request->data['to'], $to));
				$from = $from[1];
				$to = $to[1];
				
				//identifiers
				$identifiers_model = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier');
				$identifiers = $identifiers_model->find('all', array('conditions' => array('MiscIdentifier.participant_id' => $from)));
				$identifiers_model->check_writable_field = false;
				$update = array('MiscIdentifier' => array('participant_id' => $to));
				foreach($identifiers as $identifier){
					$proceed = false;
					if($identifier['MiscIdentifierControl']['flag_once_per_participant']){
						if(!$identifiers_model->find('first', array('conditions' => array('MiscIdentifier.misc_identifier_control_id' => $identifier['MiscIdentifierControl']['id'], 'MiscIdentifier.participant_id' => $to)))){
							$proceed = true;
						}
					}else{
						$proceed = true;
					}
					
					if($proceed){
						$identifiers_model->id = $identifier['MiscIdentifier']['id'];
						$identifiers_model->save($update);
					}
				}
					 
		
				$to_update = array(
					AppModel::getInstance('InventoryManagement', 'Collection'),
					AppModel::getInstance('ClinicalAnnotation', 'ConsentMaster'),
					AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster'),
					AppModel::getInstance('ClinicalAnnotation', 'EventMaster'),
					AppModel::getInstance('ClinicalAnnotation', 'FamilyHistory'),
					AppModel::getInstance('ClinicalAnnotation', 'ParticipantContact'),
					AppModel::getInstance('ClinicalAnnotation', 'ParticipantMessage'),
					AppModel::getInstance('ClinicalAnnotation', 'ReproductiveHistory'),
					AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster')
				);
		
				//update 1 by 1 to trigger right behavior + view updates properly
				foreach($to_update as $model){
					$ids = $model->find('list', array('conditions' => array($model->name.'.participant_id' => $from)));
					$update = array($model->name => array('participant_id' => $to));
					$model->check_writable_fields = false;
					foreach($ids as $id){
						$model->id = $id;
						$model->save($update, false);
					}
				}
				
				$this->atimFlash('merge complete', '/Administrate/Merge/index/');
			}
		}
	}
}