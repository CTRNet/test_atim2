<?php
$structureLinks = array(
    'top' => '/InventoryManagement/QualityCtrls/edit/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['QualityCtrl.id'] . '/',
    'bottom' => array(
        'cancel' => '/InventoryManagement/QualityCtrls/detail/' . $atimMenuVariables['Collection.id'] . '/' . $atimMenuVariables['SampleMaster.id'] . '/' . $atimMenuVariables['QualityCtrl.id'] . '/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'edit',
    'settings' => array(
        'form_bottom' => false,
        'actions' => false
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

// aliquot part
$aliquotMasterId = $this->request->data['QualityCtrl']['aliquot_master_id'];
$naChecked = true;
foreach ($aliquotDataVol as &$aliquotDataUnit) {
    if ($aliquotDataUnit['AliquotMaster']['id'] == $aliquotMasterId) {
        $aliquotDataUnit['QualityCtrl']['aliquot_master_id'] = $aliquotMasterId;
        $naChecked = false;
        break;
    }
}
if ($naChecked) {
    foreach ($aliquotDataNoVol as &$aliquotDataUnit) {
        if ($aliquotDataUnit['AliquotMaster']['id'] == $aliquotMasterId) {
            $aliquotDataUnit['QualityCtrl']['aliquot_master_id'] = $aliquotMasterId;
            $naChecked = false;
            break;
        }
    }
}

$structureLinks['radiolist'] = array(
    'QualityCtrl.aliquot_master_id' => '%%AliquotMaster.id%%'
);
$finalAtimStructure = $aliquotStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'index',
    'data' => array_merge($aliquotDataVol, $aliquotDataNoVol),
    'settings' => array(
        'form_top' => false,
        'pagination' => false,
        'header' => __('used aliquot'),
        'form_inputs' => false,
        'actions' => false,
        'form_bottom' => false
    )
);

$hookLink = $this->Structures->hook('aliquot');
if ($hookLink) {
    require ($hookLink);
}
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<table class="structure">
	<tbody>
		<tr>
			<td style='text-align: left; padding-left: 10px;'>
			
 				<?php echo $this->Form->radio('QualityCtrl.aliquot_master_id', array('na' => 'N/A'), array('legend'=>false, 'value'=>false, 'checked' => $naChecked)); ?>
 				
			</td>
		</tr>
	</tbody>
</table>
<?php

$finalAtimStructure = array(
    'Structure' => array(
        'alias' => ''
    ),
    'Sfs' => array()
);
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'detail',
    'data' => array(),
    'settings' => array(
        'form_top' => false,
        'pagination' => false,
        'form_inputs' => false
    )
);

$hookLink = $this->Structures->hook('no_aliquot');
if ($hookLink) {
    require ($hookLink);
}
$this->Structures->build($finalAtimStructure, $finalOptions);

$aliquotVolIds = array(
    0
);
foreach ($aliquotDataVol as $aliquotUnit) {
    $aliquotVolIds[] = $aliquotUnit['AliquotMaster']['id'];
}
?>
<script>
	var volumeIds = new Array(<?php echo '"'.implode('", "', $aliquotVolIds).'"'; ?>);
</script>