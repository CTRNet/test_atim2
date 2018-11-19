<?php

$tmpStructureSettings = $structureSettings;
$tmpFinalAtimStructure = $finalAtimStructure;
$tmpFinalOptions = $finalOptions;

// ADD MISC IDENTIFIER SELECTION ---------------------------------------------
$structureLinks['radiolist'] = array(
    'Collection.misc_identifier_id' => '%%MiscIdentifier.id%%'
);

$structureSettings['header'] = __('misc identifiers');

$finalAtimStructure = $atimStructureMiscidentifierDetail;
$finalOptions = array(
    'type' => 'index',
    'data' => $miscidentifierData,
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'extras' => array(
        'end' => '<input type="radio" name="data[Collection][misc_identifier_id]"  ' . ($foundMiscIdentifier ? '' : 'checked="checked"') . ' value=""/>' . __('n/a')
    )
);

$this->Structures->build($finalAtimStructure, $finalOptions);

// END ADD MISC IDENTIFIER SELECTION ---------------------------------------------

$structureSettings = $tmpStructureSettings;
$finalAtimStructure = $tmpFinalAtimStructure;
$finalOptions = $tmpFinalOptions;