<?php
	
	if(empty($parent_aliquot_ctrl['AliquotControl']['volume_unit'])){
		$this->Structures->set('used_aliq_in_stock_details,ovcare_used_aliq_in_stock_details', 'in_stock_detail');
	} else {
		$this->Structures->set('used_aliq_in_stock_details,ovcare_used_aliq_in_stock_details,used_aliq_in_stock_detail_volume', 'in_stock_detail');
	}

?>
