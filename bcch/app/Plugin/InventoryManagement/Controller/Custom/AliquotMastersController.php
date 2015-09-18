<?php
	
class AliquotMastersControllerCustom extends AliquotMastersController {
	
	/*
	@author Stephen Fung
	@date 2015-06-02
	BB-62 Modifying the CSV file output for printing the barcode labels	
	*/
	
	function printBarcodes(){
		$this->layout = false;
		Configure::write('debug', 0);
		$conditions = array();
			
		switch($this->passedArgs['model']){
			case 'Collection':
				$conditions['AliquotMaster.collection_id'] = isset($this->request->data['ViewCollection']['collection_id']) ? $this->request->data['ViewCollection']['collection_id'] : $this->passedArgs['id'];  
				if($conditions['AliquotMaster.collection_id'] == 'all' && isset($this->request->data['node'])) {
					$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
					$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
					$conditions['AliquotMaster.collection_id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
				}
				break;
			case 'SampleMaster':
				$conditions['AliquotMaster.sample_master_id'] = isset($this->request->data['ViewSample']['sample_master_id']) ? $this->request->data['ViewSample']['sample_master_id'] : $this->passedArgs['id'];
				if($conditions['AliquotMaster.sample_master_id'] == 'all' && isset($this->request->data['node'])) {
					$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
					$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
					$conditions['AliquotMaster.sample_master_id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
				}
				break;
			case 'AliquotMaster':
			default:
				$conditions['AliquotMaster.id'] = isset($this->request->data['ViewAliquot']['aliquot_master_id']) ? $this->request->data['ViewAliquot']['aliquot_master_id'] : $this->passedArgs['id'];
				if($conditions['AliquotMaster.id'] == 'all' && isset($this->request->data['node'])) {
					$this->BrowsingResult = AppModel::getInstance('Datamart', 'BrowsingResult', true);
					$browsing_result = $this->BrowsingResult->find('first', array('conditions' => array('BrowsingResult.id' => $this->request->data['node']['id'])));
					$conditions['AliquotMaster.id'] = explode(",", $browsing_result['BrowsingResult']['id_csv']);
				}
				break;
		}
		
		$this->Structures->set('aliquot_barcode', 'result_structure');
		$this->set('csv_header', true);
		$offset = 0;
		AppController::atimSetCookie(false);
		$at_least_once = false;
$aliquots_count = $this->AliquotMaster->find('count', array('conditions' => $conditions, 'limit' => 1000, 'offset' => $offset));
		$display_limit = Configure::read('AliquotBarcodePrint_processed_items_limit');
		if($aliquots_count > $display_limit) {
			$this->flash(__("batch init - number of submitted records too big")." (>$display_limit)", "javascript:history.back();", 5);
			return;
		}
		// It seems like under all conditions, the while loop only loop once
		while($this->request->data = $this->AliquotMaster->find('all', array('conditions' => $conditions, 'limit' => 1000, 'offset' => $offset))){

			// Convert the datetime format to d-M-y for every record in the CSV
			for ($i = 0; $i < count($this->request->data); $i++) {
								
				$oldDateTime = new DateTime($this->request->data[$i]['AliquotMaster']['storage_datetime']);
				
				$this->request->data[$i]['AliquotMaster']['storage_datetime'] = $oldDateTime->format('d-M-y');
				
			}		
			$this->render('../../../Datamart/View/Csv/csv');
			$this->set('csv_header', false);
			$offset += 300;
			$at_least_once = true;
		}
		if($at_least_once){
			$this->render(false);
		}else{
			$this->flash(__('there are no barcodes to print'), 'javascript:history.back();');
		}
	}
}	
	