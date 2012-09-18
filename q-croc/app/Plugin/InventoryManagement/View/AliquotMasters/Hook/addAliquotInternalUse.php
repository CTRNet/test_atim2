<?php 

$parent_settings['links']['top'] .= '/'.$qcroc_is_transfer;
$children_settings['links']['top'] .= '/'.$qcroc_is_transfer;
if($qcroc_is_transfer) $parent_settings['settings']['header'] = __('aliquot transfer');
