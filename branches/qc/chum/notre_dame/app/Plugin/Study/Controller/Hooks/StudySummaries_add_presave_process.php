<?php
$result = $this->StudySummary->find('first', array(
	'fields'		=> array('StudySummary.qc_nd_code'), 
	'conditions'	=> array('StudySummary.qc_nd_code LIKE' => date('Y').'-%'),
	'order'			=> array('StudySummary.qc_nd_code DESC')
));
$qc_nd_code_suffix = null;
if($result){
	//increment it
	$qc_nd_code_suffix = substr($result['StudySummary']['qc_nd_code'], 5) + 1;
}else{
	//first of the year
	$qc_nd_code_suffix = 1;
}
$this->data['StudySummary']['qc_nd_code'] = sprintf('%d-%03d', date('Y'), $qc_nd_code_suffix);
