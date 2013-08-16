<?php
class MiscIdentifiersControllerCustom extends MiscIdentifiersController{
	
	function createLabIdInBatch() {
		if(!isset($this->request->data['Participant']['id'])){
			$this->flash((__('you have been redirected automatically').' (#'.__LINE__.')'), "javascript:history.back();", 5);
			return;
		}
		$participants_ids = array_filter($this->request->data['Participant']['id']);
		$controls = $this->MiscIdentifierControl->find('first', array('conditions' => array('MiscIdentifierControl.misc_identifier_name' => 'lab id')));
		$participants = $this->Participant->find('all', array('conditions' => array('Participant.id' => $participants_ids), 'recursive' => '-1'));
		if(empty($participants) || empty($controls)) $this->redirect('/Pages/err_plugin_no_data?method='.__METHOD__.',line='.__LINE__, null, true);
		$control_id = $controls['MiscIdentifierControl']['id'];
		$next_id = $this->MiscIdentifier->getNextLabId();
		$batch_ids = array();
		foreach($participants as $new_pariticpant) {
			$new_participant_id = $new_pariticpant['Participant']['id'];
			$data = array();
			$data['MiscIdentifier']['identifier_value'] = 'DG'.$next_id;
			$data['MiscIdentifier']['misc_identifier_control_id'] = $control_id;
			$data['MiscIdentifier']['participant_id'] = $new_participant_id;
			$this->MiscIdentifier->data = array();
			$this->MiscIdentifier->id = null;	
			$this->MiscIdentifier->check_writable_fields = false;
			if(!$this->MiscIdentifier->save($data)) $this->redirect('/Pages/err_plugin_record_err?method='.__METHOD__.',line='.__LINE__, null, true); 
			$batch_ids[] = $this->MiscIdentifier->getLastInsertId();
			$next_id++;
		}
		
		$datamart_structure = AppModel::getInstance("Datamart", "DatamartStructure", true);
		$batch_set_data = array('BatchSet' => array(
				'datamart_structure_id'	=> $datamart_structure->getIdByModelName('MiscIdentifier'),
				'flag_tmp' => true
		));
		$batch_set_model = AppModel::getInstance('Datamart', 'BatchSet', true);
		$batch_set_model->saveWithIds($batch_set_data, $batch_ids);
		$this->atimFlash('your data has been saved', '/Datamart/BatchSets/listall/'.$batch_set_model->getLastInsertId());
	}

}