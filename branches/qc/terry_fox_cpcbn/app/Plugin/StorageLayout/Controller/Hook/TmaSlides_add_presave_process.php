<?php
$tmpBarcode = 0;
unset($tmaSlidesToCreate['StorageMaster']);
foreach ($tmaSlidesToCreate as &$tmpDataSet) {
    $tmpDataSet['TmaSlide']['barcode'] = 'tmp_' . $tmpDataSet['TmaSlide']['tma_block_storage_master_id'] . '_' . $tmpBarcode ++;
}
$this->TmaSlide->addWritableField(array(
    'barcode'
));