<?php
	$filter_links = array( 'no filter'=>'/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'] );
	foreach ( $event_controls as $event_control ) {
		$filter_links[ $event_control['EventControl']['disease_site'].' - '.$event_control['EventControl']['event_type'] ] = '/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
	}
	
	$add_links = array();
	foreach ( $event_controls as $event_control ) {
		$add_links[ $event_control['EventControl']['disease_site'].' - '.$event_control['EventControl']['event_type'] ] = '/clinicalannotation/event_masters/add/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
	}
	
	$structure_links = array(
		'index' => array( 
			'detail' => '/clinicalannotation/event_masters/detail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%'
		),
		'bottom' => array(
			'filter' => $filter_links,
			'add' => $add_links
		)
	); 
	
	$structures->build( $atim_structure, array('links'=>$structure_links));
	
	/*
	// EXPANDED add action, based on CONTROL->MASTER->DETAIL datatable setup
	$expanded_add = array();
			
	// loop through related CONTROL table rows 
	foreach ( $event_controls as $option ) {
		if ( $option['EventControl']['form_alias'] && $option['EventControl']['detail_tablename'] ) {
			$expanded_add [ $option['EventControl']['id'] ] = ($option['EventControl']['disease_site'].' - '.$option['EventControl']['event_type']);
		}
	}
	
	if ( !empty( $expanded_add ) ) {
		echo('
				<fieldset>
					<select name="event_control_id">
		');
			foreach ( $expanded_add as $key=>$value ) {
				echo('
					<option value="'.$key.'">'.$value.'</option>
				');
			}
		echo('
				</select>
				<input type="submit" class="submit add" value="'.add.'" />
				</fieldset>
			</form>
		');
	} // end IF
	*/
?>