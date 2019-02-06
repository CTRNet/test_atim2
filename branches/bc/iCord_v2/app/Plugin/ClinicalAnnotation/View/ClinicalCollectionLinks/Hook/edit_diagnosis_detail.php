<?php
/**
 * **********************************************************************
 * iCord
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2019-02-05
 */

// Hide the Treatment and Event selection sections
$structureSettings['form_bottom'] = true;
$structureSettings['actions'] = true;
$finalOptions['settings'] = $structureSettings;