<?php
if (isset($addLinkForProcureForms)) {
    foreach ($addLinkForProcureForms as $buttonTitle => $links) {
        $finalOptions['links']['bottom'][$buttonTitle] = $links;
        $structureLinks['bottom'][$buttonTitle] = $links;
    }
}