<?php
/** **********************************************************************
 * CUSM-Kidney Transplant
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 @since 2018-05-28
 */

// Hide delete button.
// Collection is deleted automatically by participant to collection link deletion.
unset($finalOptions['links']['bottom']['print barcodes']);
unset($structureLinks['bottom']['print barcodes']);
