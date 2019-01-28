<?php
$valid = 1;
$message = "";
$page = "";
$url = "";
$id = - 1;
$rootUrl = $this->request->webroot;
if (empty($result)) {
    $valid = 0;
    $message = __('aliquot does not exist');
    $label = $barcodeSearch;
} elseif (count($result) == 1) {
    $result = $result[0];
    $x = $result['AliquotMaster']['storage_coord_x'];
    $y = $result['AliquotMaster']['storage_coord_y'];
    $storageLabel = $result['StorageMaster']['short_label'];
    $aliquotType = $result['AliquotControl']['aliquot_type'];
    $available = $result['AliquotMaster']['in_stock'];
    $id = $result['AliquotMaster']['id'];
    $collectionId = $result['AliquotMaster']['collection_id'];
    $sampleMasterId = $result['AliquotMaster']['sample_master_id'];
    $barcode = $result['AliquotMaster']['barcode'];
    $label = (! empty($result['AliquotMaster']['aliquot_label'])) ? $result['AliquotMaster']['aliquot_label'] : $barcode;
    $url = $rootUrl . "InventoryManagement/AliquotMasters/detail/$collectionId/$sampleMasterId/$id/2";
    if ($available == 'no') {
        $valid = 0;
        $message = __('aliquot is not in stock');
    } elseif ($aliquotType != 'core' && $isTma) {
        $valid = 0;
        $message = __('only sample core can be stored into tma block');
    } elseif (! empty($x) || ! empty($y) || ! empty($storageLabel)) {
        $valid = 3;
        $message = __('this aliquot is registered in another place. label: %s, x: %s, y: %s', $storageLabel, $x, $y);
    }
} elseif (count($result) > 1) {
    $valid = 0;
    $message = __('more than one aliquot have the same barcode');
}
$message = ($label != "" && $message != "") ? $label . ", " . $message : $label . $message;
if ($valid != 0) {
    if ($valid == 1) {
        $warningAliquot = "new-aliquot";
    } elseif ($valid == 2) {
        $warningAliquot = "warning-aliquot";
    } elseif ($valid == 3) {
        $warningAliquot = "warning-aliquot duplicated-aliquot";
    }
    $page = "<li class='dragme $warningAliquot AliquotMaster ui-draggable just-added' data-json='{ \"id\" : \"$id\", \"type\" : \"AliquotMaster\"}' style='position: relative;' title = \"$message\">
                <a href='javascript:void(0)' data-popup-link='$url' title='Detail' class='icon16 aliquot popupLink' style='text-decoration: none;'>&nbsp;</a>
                <span class='handle' data-barcode = '$barcodeSearch'>$barcodeSearch</span>
            </li>";
} else {
    $page = "<li class='dragme error-aliquot AliquotMaster ui-draggable just-added' data-json='{ \"id\" : \"-$id\", \"type\" : \"AliquotMaster\"}' style='position: relative;' title = \"$message\">
                <a href='javascript:void(0)' data-popup-link='$url' title='Detail' class='icon16 aliquot popupLink' style='text-decoration: none;'>&nbsp;</a>
                <span class='handle' data-barcode = '$barcodeSearch'>$barcodeSearch</span>
            </li>";
}
echo (json_encode(array(
    "valid" => $valid,
    "message" => $message,
    "page" => $page
)));