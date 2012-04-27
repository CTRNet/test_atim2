<?php
$links = array(
	'top' => '/administrate/qc_nd_sardo/edit/'.$data['QcNdSardoTxConfSurgeries']['id'],
	'bottom' => array('cancel' => '/administrate/qc_nd_sardo/index')
);
$structures->build($qc_nd_sardo_surg_conf_site, array(
	'data'	=> $data,
	'type' => 'edit', 
	'links' => $links,
	'settings' => array('header' => $data['QcNdSardoTxConfSurgeries']['name']),
	'extras' => '<div id="subStruct"></div>'
));

$arr = array(
	'Ovaire' => $qc_nd_sardo_conf_surg_ov,
	'Prostate' => $qc_nd_sardo_conf_surg_prost,
	'Sein' => $qc_nd_sardo_conf_surg_breast
);

foreach($arr as $key => $val){
	echo '<div id="site'.$key.'" class="hidden">';
	$structures->build($val, array(
		'data' => $data['QcNdSardoTxConfSurgeries']['site'] == $key ? $data : array(),
		'type' => 'edit',
		'links' => array('top' => 'administrate/qc_nd_sardo/edit/'.$data['QcNdSardoTxConfSurgeries']['id']),
		'settings' => array('actions' => false, 'form_top' => false, 'form_bottom' => false)
	));
	echo '</div>';
}

?>
<script>
var qcNdSardo = function(){
	//init this page
	var select = $("form select");
	select.data('ovary', $("#siteOvaire").html());
	$("#siteOvaire").remove();
	select.data('prostate', $("#siteProstate").html());
	$("#siteProstate").remove();
	select.data('breast', $("#siteSein").html());
	$("#siteSein").remove();
	
	select.change(function(){
		switch($(this).val()){
			case 'Ovaire':
				$("#subStruct").html($(this).data('ovary'));
				break;
			case 'Prostate':
				$("#subStruct").html($(this).data('prostate'));
				break;
			case 'Sein':
				$("#subStruct").html($(this).data('breast'));
				break;
			default:
				$("#subStruct").html("");
		}
	});
	select.change();
};
</script>