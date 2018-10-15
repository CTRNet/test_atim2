<?php
/** **********************************************************************
 * CUSM-Kidney Transplant
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
// Hide delete button.
// Collection is deleted automatically by participant to collection link deletion.
unset($finalOptions['links']['bottom']['print barcodes']);
unset($structureLinks['bottom']['print barcodes']);
