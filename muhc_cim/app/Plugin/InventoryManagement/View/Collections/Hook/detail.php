<?php
/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */

// Hide print barcode button
unset($finalOptions['links']['bottom']['print barcodes']);
unset($structureLinks['bottom']['print barcodes']);