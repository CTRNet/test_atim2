<?php
/** **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-04-06
 */

// Prevent the paste operation on aliquot_label field
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.aliquot_label'
);