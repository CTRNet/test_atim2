<?php
if(empty($this->request->data['Order']['order_number'])){
	$result = $this->Order->find('first', array(
			'fields'		=> array('Order.order_number'),
			'conditions'	=> array('Order.order_number REGEXP ' => date('Y').'-[0-9]+$'),
			'order'			=> array('Order.order_number DESC')
	));
	
	$qc_nd_code_suffix = null;
	if($result){
		//increment it
		$qc_nd_code_suffix = substr($result['Order']['order_number'], 5) + 1;
	}else{
		//first of the year
		$qc_nd_code_suffix = 1;
	}
	$this->request->data['Order']['order_number'] = sprintf('%d-%03d', date('Y'), $qc_nd_code_suffix);
}