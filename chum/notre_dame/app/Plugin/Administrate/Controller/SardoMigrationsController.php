<?php

class SardoMigrationsController extends AdministrateAppController {
	var $uses = array('Administrate.SardoImportSummary');
	
	var $paginate = array(
		'SardoImportSummary'	=> array('limit' => pagination_amount, 'order' => 'SardoImportSummary.message_type ASC'));
	
	function listAll($message_type = 'all'){
		if(!in_array($message_type, array('all', 'profile_reproductive', 'main'))) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$this->set('message_type', $message_type);
		
		if($message_type == 'all') {
			
			// Main form
			
			$this->Structures->set('qc_nd_sardo_migrations_summary');
			
			$condtions = array('SardoImportSummary.message_type' => 'MESSAGE', 'SardoImportSummary.data_type' => 'Process');
			$process_messages = $this->SardoImportSummary->find('all', array('conditions' => $condtions));
			$this->request->data = array();
			foreach($process_messages as $new_message) {
				switch($new_message['SardoImportSummary']['message']) {
					case 'Date':
						$this->request->data['Generated']['qc_nd_last_sardo_update'] = $new_message['SardoImportSummary']['details'];
						break;
					case 'Process completed':
						$this->request->data['Generated']['qc_nd_sardo_update_completed'] = $new_message['SardoImportSummary']['details'];
						break;
					case 'Updated participants counter':
						$this->request->data['Generated']['qc_nd_sardo_updated_participants_nbr'] = $new_message['SardoImportSummary']['details'];
						break;
					case 'Error':
						$this->request->data['Generated']['qc_nd_sardo_update_error'] = $new_message['SardoImportSummary']['details'];
						break;
				}
			}
			
		} else {
			
			// Sub-Form (messages list)
			
			$this->Structures->set('qc_nd_sardo_migrations_messages', 'atim_structure_messages');
			
			$condtions = array();
			if($message_type == 'profile_reproductive') {
				$condtions['SardoImportSummary.message_type'] = 'MESSAGE';
				$condtions['SardoImportSummary.message'] = 'Profile & Reproductive History Creation/Update summary';
			} else {
				$condtions[] = array('NOT' => array("SardoImportSummary.data_type" => "Process"));
				$condtions[] = array('NOT' => array("SardoImportSummary.message" => "Profile & Reproductive History Creation/Update summary"));
			}
			$this->request->data = $this->paginate($this->SardoImportSummary, $condtions);
			if(!$this->Session->read('flag_show_confidential')){
				foreach($this->request->data as &$new_data){
					if($new_data['SardoImportSummary']['message'] =='Creation/Update summary') $new_data['SardoImportSummary']['details']= CONFIDENTIAL_MARKER;
				}
			}
		}
	}
}
