<?php
if (isset($addLinkForProcureForms)) {
    foreach ($addLinkForProcureForms as $buttonTitle => $links) {
        $finalOptions['links']['bottom'][$buttonTitle] = $links;
        $structureLinks['bottom'][$buttonTitle] = $links;
    }
}

// To not display Related Diagnosis Event and Linked Collections
$isAjax = true;
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;
unset($finalOptions['links']['bottom']['add precision']);