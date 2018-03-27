<?php
/** **********************************************************************
 * TFRI-M4S Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-03-16
 */

// Prevent the paste operation on aliquot label
$optionsChildren['settings']['paste_disabled_fields'] = array(
    'AliquotMaster.aliquot_label'
);