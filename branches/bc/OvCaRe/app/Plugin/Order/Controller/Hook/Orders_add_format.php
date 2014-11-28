<?php
	
	if(empty($this->request->data)) {
		$tmp_date = $this->Order->tryCatchQuery("SELECT DATE_FORMAT(NOW(),'%y') AS date FROM users LIMIt 0 ,1;");
		$tmp_date = (isset($tmp_date[0][0]['date']))? $tmp_date[0][0]['date'] : '??';
		$last_order_number = $this->Order->tryCatchQuery("SELECT order_number FROM orders WHERE order_number REGEXP('^".$tmp_date."-OVC-[0-9]{2}$') ORDER BY order_number DESC LIMIt 0,1;");
		$next_order_number = '01';
		if($last_order_number) {
			if(isset($last_order_number[0]['orders']['order_number'])) {
				$last_order_number = $last_order_number[0]['orders']['order_number'];
				if(preg_match('/^[0-9]{2}-OVC-([0-9]{2})$/', $last_order_number, $matches)) {
					$next_order_number = $matches[1] + 1;
					if(strlen($next_order_number) == 1) $next_order_number = '0'.$next_order_number;
				}
			}			
		}
		$this->set('default_order_number', $tmp_date.'-OVC-'.$next_order_number);
	}

?>
