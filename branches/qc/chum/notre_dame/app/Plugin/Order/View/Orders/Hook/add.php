<?php
foreach($final_atim_structure['Sfs'] as &$sfs){
	if($sfs['field'] == 'order_number'){
		$sfs['setting'] .= ',placeholder=-- auto --';
		break;
	}
	unset ($sfs);
}