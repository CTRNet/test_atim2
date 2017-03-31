<?php
	//***********************************************************************************************************************
	//TODO Ying Request To Validate
	//***********************************************************************************************************************
	//	Collection.ovcare_study_summary_id
	//	ovcare_used_aliq_in_stock_details contains Collection.ovcare_study_summary_id
	//***********************************************************************************************************************
	
//	$this->Structures->set('used_aliq_in_stock_details,ovcare_used_aliq_in_stock_details', "aliquots_structure");
//	$this->Structures->set('used_aliq_in_stock_details,ovcare_used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'aliquots_volume_structure');
	
	//Remove ViewAliquot.ovcare_study_summary_id field of the submitted data : won't be removed in validation loop
// 	if($this->request->data) {
// 		pr($this->request->data);exit;
// 		foreach($this->request->data as $ovcare_key => $ovcare_key_data) {
// 			if(preg_match('/^[0-9]+$/', $ovcare_key)) unset($this->request->data[$ovcare_key]['ViewAliquot']);
// 		}
// 	}
	//***********************************************************************************************************************
	//TODO END Ying Request To Validate
	//***********************************************************************************************************************