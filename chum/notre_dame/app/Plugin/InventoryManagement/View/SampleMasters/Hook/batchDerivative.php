<?php
unset($optionsChildren['override']['DerivativeDetail.creation_datetime']);

if (in_array($createdSampleStructureOverride['SampleControl.sample_type'], array(
    'dna',
    'rna'
))) {
    $optionsChildren['settings']['paste_disabled_fields'] = array(
        'SampleDetail.source_cell_passage_number',
        'SampleDetail.source_temperature',
        'SampleDetail.source_temp_unit',
        'SampleDetail.tmp_source_milieu',
        'SampleDetail.tmp_source_storage_method'
    );
}