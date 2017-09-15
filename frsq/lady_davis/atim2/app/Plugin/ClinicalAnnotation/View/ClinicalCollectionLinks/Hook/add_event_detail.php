<?php

// ADD MISC IDENTIFIER SELECTION ---------------------------------------------
$structureLinks['radiolist'] = array(
    'Collection.misc_identifier_id' => '%%MiscIdentifier.id%%'
);

$structureSettings['header'] = __('misc identifiers');
$structureSettings['form_bottom'] = true;
$structureSettings['actions'] = true;
$structureSettings['form_top'] = false;

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

$displayNextSubForm = false;