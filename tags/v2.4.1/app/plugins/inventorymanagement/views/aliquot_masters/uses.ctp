<?php
$hook_link = $structures->hook('storage_history');
if($hook_link){
	require($hook_link);
}
$structures->build($atim_structure, array(
	'type' => 'index',
	'links' => array(
		'index'	=> array('detail' => '%%ViewAliquotUse.detail_url%%')
	),'settings'	=> array(
		'pagination'	=> false,
		'actions'		=> false
	)
));