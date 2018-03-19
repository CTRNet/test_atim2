<?php
$tmp_barcode = 0;
unset($tma_slides_to_create['StorageMaster']);
foreach ($tma_slides_to_create as &$tmp_data_set) {
    $tmp_data_set['TmaSlide']['barcode'] = 'tmp_' . $tmp_data_set['TmaSlide']['tma_block_storage_master_id'] . '_' . $tmp_barcode ++;
}
$this->TmaSlide->addWritableField(array(
    'barcode'
));

?>