<?php
$links['index'] = '/administrate/qc_nd_sardo/edit/%%QcNdSardoTxConfSurgeries.id%%/';
$arr = array(
	array('name' => 'Non classé', 'structure' => $qc_nd_sardo_surg_conf_name),
	array('name' => 'Ovaire', 'structure' => $qc_nd_sardo_conf_surg_ov),
	array('name' => 'Prostate', 'structure' => $qc_nd_sardo_conf_surg_prost),
	array('name' => 'Sein', 'structure' => $qc_nd_sardo_conf_surg_breast),
	array('name' => 'Autre', 'structure' => $qc_nd_sardo_surg_conf_name),
);
while($part = array_shift($arr)){
	$structures->build($part['structure'], array('data' => $data[$part['name']], 'type' => 'index', 'links' => $links, 'settings' => array('pagination' => false, 'header' => $part['name'], 'actions' => empty($arr))));
}
