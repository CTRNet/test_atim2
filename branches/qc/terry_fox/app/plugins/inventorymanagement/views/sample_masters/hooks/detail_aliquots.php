<?php
$add_aliquot = &$final_options['links']['bottom']['add aliquot'];
$add_aliquot[__('block', true)." (OCT)"] = $add_aliquot[__("block", true)];
$add_aliquot[__('block', true)." (".__("paraffin", true).")"] = preg_replace('/\/17[\/]*$/', "/4", $add_aliquot[__("block", true)]);
unset($add_aliquot[__("block", true)]);
