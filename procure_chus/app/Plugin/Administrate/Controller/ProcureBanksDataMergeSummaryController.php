<?php

class ProcureBanksDataMergeSummaryController extends AdministrateAppController {
	var $uses = array(
	    'Administrate.ProcureBanksDataMergeMessage',
	    'Administrate.ProcureBanksDataMergeTrie'
	);
	
	var $paginate = array('ProcureBanksDataMergeTrie'=>array('order'=>'ProcureBanksDataMergeTrie.id DESC'));
	
	function listAll() {
		if(Configure::read('procure_atim_version') != 'CENTRAL')  $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	}
	
	function listAllMessages() {
	    if(Configure::read('procure_atim_version') != 'CENTRAL')  $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$this->Structures->set('procure_banks_data_merge_messages');
		$this->request->data = $this->paginate($this->ProcureBanksDataMergeMessage, array());
	}
	
	function listAllTries() {
	    if(Configure::read('procure_atim_version') != 'CENTRAL')  $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
	    $this->Structures->set('procure_banks_data_merge_tries');
	    $this->request->data = $this->paginate($this->ProcureBanksDataMergeTrie, array());
	}
}
