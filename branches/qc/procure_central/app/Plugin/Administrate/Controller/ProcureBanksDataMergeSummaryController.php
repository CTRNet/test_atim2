<?php

class ProcureBanksDataMergeSummaryController extends AdministrateAppController {
	var $uses = array('Administrate.ProcureBanksDataMergeMessage');
	
	var $paginate = array('ProcureBanksDataMergeMessage' => array('limit' => 5, 'order' => 'ProcureBanksDataMergeMessage.message_nbr ASC, ProcureBanksDataMergeMessage.details ASC'));
	
	function listAll($message_nbr = ''){
		
		if(Configure::read('procure_atim_version') != 'CENTRAL')  $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		if(!preg_match('/^[0-9]*$/', $message_nbr)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$this->set('message_nbr', $message_nbr);
		
		if(!$message_nbr) {
			
			// Main form
			
			$this->request->data = array(
				'Generated' => array(
					'procure_banks_data_merge_date' => null,
					'procure_banks_data_merge_try_date' => null,
					'procure_banks_data_merge_try_result' =>null,
					'procure_banks_data_merge_try_file' => 'Generated.procure_banks_data_merge_try_file.'.Configure::read('procure_banks_data_merge_output_file')));
				
			$try_data = $this->ProcureBanksDataMergeMessage->find('all', array(
					'conditions' => array('ProcureBanksDataMergeMessage.message_nbr IS NULL', 'ProcureBanksDataMergeMessage.type' => array('merge_date', 'merge_try_date')),
					'fields' => array('DISTINCT ProcureBanksDataMergeMessage.type, ProcureBanksDataMergeMessage.details')));
			foreach($try_data as $new_data) {
				$this->request->data['Generated']['procure_banks_data_'.$new_data['ProcureBanksDataMergeMessage']['type']] = $new_data['ProcureBanksDataMergeMessage']['details'];
			}
			$this->request->data['Generated']['procure_banks_data_merge_try_result'] = ($this->request->data['Generated']['procure_banks_data_merge_date'] != $this->request->data['Generated']['procure_banks_data_merge_try_date'])? __('failed') : __('success');
			
			$this->Structures->set('procure_banks_data_merge_summary');
		
			// Subforms management
			
			$message_nbrs_tmp = $this->ProcureBanksDataMergeMessage->find('all', array(
				'conditions' => array('ProcureBanksDataMergeMessage.message_nbr IS NOT NULL'),
				'fields' => array('DISTINCT ProcureBanksDataMergeMessage.message_nbr, ProcureBanksDataMergeMessage.type, ProcureBanksDataMergeMessage.title, ProcureBanksDataMergeMessage.description')));
			$message_nbrs = array();
			foreach($message_nbrs_tmp as $val) $message_nbrs[$val['ProcureBanksDataMergeMessage']['message_nbr']] = array($val['ProcureBanksDataMergeMessage']['message_nbr'], $val['ProcureBanksDataMergeMessage']['type'].' : '.$val['ProcureBanksDataMergeMessage']['title'], $val['ProcureBanksDataMergeMessage']['description']);
			$this->set('message_nbrs', $message_nbrs);

		} else {
			
			// Sub-Form (messages list)
			
			$this->Structures->set('procure_banks_data_merge_messages', 'procure_banks_data_merge_messages');
			$this->request->data = $this->paginate($this->ProcureBanksDataMergeMessage, array('ProcureBanksDataMergeMessage.message_nbr' => $message_nbr));
		}
	}
}
