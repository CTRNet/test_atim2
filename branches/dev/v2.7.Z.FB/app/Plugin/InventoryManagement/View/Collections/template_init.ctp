<?php
ob_start();

$structureBuildOptions = array(
    'type' => 'edit',
    'links' => array(
        'top' => '/InventoryManagement/Collections/templateInit/' . $collectionId . '/' . $templateId
    ),
    'settings' => empty($templateInitStructure['Sfs']) ? array() : array(
        'header' => __('default values')
    ),
    'extras' => $this->Form->input('template_init_id', array(
        'type' => 'hidden',
        'value' => $templateInitId,
        'id' => false
    ))
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($templateInitStructure, $structureBuildOptions);

$display = ob_get_contents();
ob_end_clean();
$display = ob_get_contents() . $display;
$this->layout = 'json';
$this->json = array(
    'goToNext' => isset($goToNext),
    'page' => $display
);