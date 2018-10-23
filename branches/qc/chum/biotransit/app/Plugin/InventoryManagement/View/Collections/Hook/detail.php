<?php
/** **********************************************************************
 * CHUM-BioTransit Project
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-10-22
 */

// Hide print barcode button
unset($finalOptions['links']['bottom']['print barcodes']);
unset($structureLinks['bottom']['print barcodes']);

// Hide delete button
unset($finalOptions['links']['bottom']['delete']);
unset($structureLinks['bottom']['delete']);