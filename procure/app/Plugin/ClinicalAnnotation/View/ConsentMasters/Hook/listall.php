<?php
if (isset($addLinkForProcureForms)) {
    foreach ($addLinkForProcureForms as $buttonTitle => $links) {
        $finalOptions['links']['bottom'][$buttonTitle] = $links;
    }
    unset($finalOptions['links']['bottom']['add']);
}