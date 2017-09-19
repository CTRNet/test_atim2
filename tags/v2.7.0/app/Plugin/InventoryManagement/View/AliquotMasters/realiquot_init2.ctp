<?php
$bottom = array();
if (isset($labBookCtrlId))
    $bottom['add lab book (pop-up)'] = '/labbook/LabBookMasters/add/' . $labBookCtrlId . '/1/';
$bottom['cancel'] = $urlToCancel;

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'add',
    'settings' => array(
        'header' => __('realiquoting process') . ' - ' . __('lab book selection')
    ),
    'links' => array(
        'top' => '/InventoryManagement/AliquotMasters/' . $realiquotingFunction . '/' . $aliquotId,
        'bottom' => $bottom
    ),
    'extras' => '<input type="hidden" name="data[sample_ctrl_id]" value="' . $sampleCtrlId . '"/>
					<input type="hidden" name="data[realiquot_from]" value="' . $realiquotFrom . '"/>
					<input type="hidden" name="data[0][realiquot_into]" value="' . $realiquotInto . '"/>
					<input type="hidden" name="data[0][ids]" value="' . $ids . '"/>
					<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

?>

<script>
var labBookPopup = true;
</script>