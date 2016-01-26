<?php

class ProcureBanksDataMergeSummaryController extends AdministrateAppController {
	var $uses = array('Administrate.ProcureBanksDataMergeMessage');
	
	var $paginate = array('ProcureBanksDataMergeMessage' => array('limit' => pagination_amount, 'order' => 'ProcureBanksDataMergeMessage.message_nbr ASC, ProcureBanksDataMergeMessage.details ASC'));
	
	function listAll($message_nbr = ''){
		
		if(Configure::read('procure_atim_version') != 'CENTRAL')  $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		if(!preg_match('/^[0-9]*$/', $message_nbr)) $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$this->set('message_nbr', $message_nbr);
		
		if(!$message_nbr) {
			
			// Main form
			
			$this->Structures->set('procure_banks_data_merge_summary');
			$first_record = $this->ProcureBanksDataMergeMessage->find('first');
			$this->request->data = array('Generated' => array('procure_banks_data_merge_date' => $first_record['ProcureBanksDataMergeMessage']['created']));
			
			$message_nbrs_tmp = $this->ProcureBanksDataMergeMessage->find('all', array('fields' => array('DISTINCT ProcureBanksDataMergeMessage.message_nbr, ProcureBanksDataMergeMessage.title, ProcureBanksDataMergeMessage.description')));
			$message_nbrs = array();
			foreach($message_nbrs_tmp as $val) $message_nbrs[$val['ProcureBanksDataMergeMessage']['message_nbr']] = array($val['ProcureBanksDataMergeMessage']['message_nbr'], $val['ProcureBanksDataMergeMessage']['title'], $val['ProcureBanksDataMergeMessage']['description']);
			$this->set('message_nbrs', $message_nbrs);

		} else {
			
			// Sub-Form (messages list)
			
			$this->Structures->set('procure_banks_data_merge_messages', 'procure_banks_data_merge_messages');
			$this->request->data = $this->paginate($this->ProcureBanksDataMergeMessage, array('ProcureBanksDataMergeMessage.message_nbr' => $message_nbr));
		}
	}
}
