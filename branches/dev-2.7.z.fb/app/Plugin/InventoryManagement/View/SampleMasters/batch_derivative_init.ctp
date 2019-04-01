<?php
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'add',
    'settings' => array(
        'header' => __('derivative creation process') . ' - ' . __('derivative type selection'),
        'stretch' => false
    ),
    'links' => array(
        'top' => ($skipLabBookSelectionStep ? '/InventoryManagement/SampleMasters/batchDerivative/' . $aliquotMasterId : '/InventoryManagement/SampleMasters/batchDerivativeInit2/' . $aliquotMasterId),
        'bottom' => array(
            'cancel' => $urlToCancel
        )
    ),
    'extras' => '<input type="hidden" name="data[SampleMaster][ids]" value="' . $ids . '"/>
					<input type="hidden" name="data[AliquotMaster][ids]" value="' . (isset($aliquotIds) ? $aliquotIds : "") . '"/>
					<input type="hidden" name="data[ParentToDerivativeSampleControl][parent_sample_control_id]" value="' . $parentSampleControlId . '"/>
					<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);