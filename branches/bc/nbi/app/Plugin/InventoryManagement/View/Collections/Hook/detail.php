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

// Hide print barcode button
unset($finalOptions['links']['bottom']['print barcodes']);
unset($structureLinks['bottom']['print barcodes']);

// Hide delete button. 
// Collection is deleted automatically by participant to collection link deletion.
unset($finalOptions['links']['bottom']['delete']);
unset($structureLinks['bottom']['delete']);