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
unset($finalOptions['links']['bottom']['print barcode']);
unset($structureLinks['bottom']['print barcode']);
