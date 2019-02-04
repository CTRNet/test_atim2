<?php
/** **********************************************************************
 * iCord
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2019-01-31
 */

// Hide the Treatment and Event selection sections
$structure_settings['form_bottom'] = true;
$structure_settings['actions'] = true;
$final_options['settings'] = $structure_settings;