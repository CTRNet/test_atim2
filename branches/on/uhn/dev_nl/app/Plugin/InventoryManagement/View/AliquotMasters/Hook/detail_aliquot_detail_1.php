<?php
/** **********************************************************************
 * UHN Project.
 * ***********************************************************************
 *
 * InventoryManagement plugin custom code
 * 
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-05-04
 */
 
// Hide print barcode button
unset($finalOptions['links']['bottom']['print barcode']);
unset($structureLinks['bottom']['print barcode']);
