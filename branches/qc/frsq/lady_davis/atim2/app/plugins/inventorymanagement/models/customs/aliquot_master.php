<?php
class AliquotMasterCustom extends AliquotMaster{
	
	var $name = 'AliquotMaster';
	var $useTable = 'aliquot_masters';
	
	function checkDuplicatedAliquotBarcode($aliquot_data) {
		//error on duplicate for the same control id
		//warn on duplicate on cross control id
		
		// check data structure
		$tmp_arr_to_check = array_values($aliquot_data);
		if((!is_array($aliquot_data)) || (is_array($tmp_arr_to_check) && isset($tmp_arr_to_check[0]['AliquotMaster']))) {
			AppController::getInstance()->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		
		$barcode = $aliquot_data['AliquotMaster']['barcode'];
		$control_id = $aliquot_data['AliquotMaster']['aliquot_control_id'];
		
		// Check duplicated barcode into submited record
		if(empty($barcode)) {
			// Not studied
		} else if(isset($this->barcodes[$control_id][$barcode])) {
			$this->validationErrors['barcode'] = str_replace('%s', $barcode, __('you can not record barcode [%s] twice', true));
		} else if(isset($this->barcodes['all'][$barcode])) {
			AppController::addWarningMsg(sprintf(__('barcode [%s] was created more than once', true), $barcode));
		} else {
			$this->barcodes['all'][$barcode] = '';
			$this->barcodes[$control_id][$barcode] = '';
		}
		
		// Check duplicated barcode into db
		$aliquots_having_duplicated_barcode = $this->find('all', array('conditions' => array('AliquotMaster.barcode' => $barcode, 'AliquotMaster.aliquot_control_id' => $control_id), 'recursive' => -1));
		if(!empty($aliquots_having_duplicated_barcode)) {
			//errors on the same ctrl_id
			foreach($aliquots_having_duplicated_barcode as $duplicate) {
				if((!array_key_exists('id', $aliquot_data['AliquotMaster'])) || ($duplicate['AliquotMaster']['id'] != $aliquot_data['AliquotMaster']['id'])) {
					$this->validationErrors['barcode'] = str_replace('%s', $barcode, __('the barcode [%s] has already been recorded', true));
				}
			}
		}else{
			//warn on different ctrl id
			$aliquots_having_duplicated_barcode = $this->find('all', array('conditions' => array('AliquotMaster.barcode' => $barcode), 'recursive' => -1));
			foreach($aliquots_having_duplicated_barcode as $duplicate) {
				if((!array_key_exists('id', $aliquot_data['AliquotMaster'])) || ($duplicate['AliquotMaster']['id'] != $aliquot_data['AliquotMaster']['id'])) {
					AppController::addWarningMsg(sprintf(__('barcode [%s] was created more than once', true), $barcode));
				}
			}
		}
	}
	
}