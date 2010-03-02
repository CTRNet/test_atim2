<?php 

	// 1- DIAGNOSTICS
	
	$structure_links = array(
		'index' => array(
			'detail' => '/clinicalannotation/event_masters/imageryReport/'.$atim_menu_variables['Participant.id']
		),
		'bottom'=>array(
			'list'=>'/clinicalannotation/event_masters/listall/clinical/'.$atim_menu_variables['Participant.id']
		)
	);
	$structure_settings = array(
			'form_bottom'=>false, 
			'form_inputs'=>false,
			'actions'=>false,
			'pagination'=>false,
			'header' => __('segment', null)
		);
		
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'type' => 'detail', 'settings' => $structure_settings); 
	$structures->build($final_atim_structure, $final_options);

	?>
	<style>
	.segment thead tr:nth-child(1) th{
		border-right-style: solid;
		border-width: 2px;
	}
	.segment thead tr:nth-child(2) th:nth-child(odd){
		border-right-style: solid;
		border-width: 2px;
	}
	
	.otherLocations thead tr:nth-child(1) th{
		border-right-style: solid;
		border-width: 2px;
	}
	.otherLocations .rightBorder{
		border-right-style: solid;
		border-width: 2px;
	}
	
	.pancreas thead th{
		border-right-style: solid;
		border-width: 2px;
	}
	
	.mainRules thead tr:nth-child(2) th{
		border-bottom-style: solid;
		border-width: 2px;
	}
	.mainRules tbody{
		text-align: center;
		vertical-align: bottom;
	}
	.mainRules tbody th{
		/* fits with the core css*/
		padding: 10px 0px;
	}
	.mainRules tbody tr:nth-child(odd){
		background-color: #ddd;
	}
	.mainRules tbody td{
		border-color: #eee;
		border-style: solid;
		border-width: 1px;
	}
	</style>
	<table class="structure segment mainRules">
		<thead>
			<tr>
				<td></td>
				<th colspan="2"><?php echo(__('segment', true))?> I</th>
				<th colspan="2"><?php echo(__('segment', true))?> II</th>
				<th colspan="2"><?php echo(__('segment', true))?> III</th>
				<th colspan="2"><?php echo(__('segment', true))?> IVa</th>
				<th colspan="2"><?php echo(__('segment', true))?> IVb</th>
				<th colspan="2"><?php echo(__('segment', true))?> V</th>
				<th colspan="2"><?php echo(__('segment', true))?> VI</th>
				<th colspan="2"><?php echo(__('segment', true))?> VII</th>
				<th colspan="2"><?php echo(__('segment', true))?> VIII</th>
			</tr>
			<tr>
				<td></td>
				<?php for($i = 0; $i < 9; ++ $i){ ?>
					<th><?php echo(__('number', true)); ?></th>
					<th><?php echo(__('size', true)); ?></th>
				<?php } ?>
			</tr>
		</thead>
		<tbody>
			<?php 
			foreach($this->data as $data){
				?>
				<tr>
					<th><?php echo(substr($data['EventControl']['event_type'], 16)); ?> - <?php echo($structures->formatDate($data['EventMaster']['event_date'])); ?></th>
					<?php 
					for($i = 1; $i < 4; ++ $i){
						?><td><?php echo($data['EventDetail']['segment_1_number']); ?></td>
						<td><?php echo($data['EventDetail']['segment_'.$i.'_size']); ?></td>
					<?php } ?>
					<td><?php echo($data['EventDetail']['segment_4a_number']); ?></td>
					<td><?php echo($data['EventDetail']['segment_4a_size']); ?></td>
					<td><?php echo($data['EventDetail']['segment_4b_number']); ?></td>
					<td><?php echo($data['EventDetail']['segment_4b_size']); ?></td>
					<?php 
					for($i = 5; $i < 9; ++ $i){
						?><td><?php echo($data['EventDetail']['segment_'.$i.'_number']); ?></td>
						<td><?php echo($data['EventDetail']['segment_'.$i.'_size']); ?></td>
					<?php } ?>
				</tr>
				<?php	
			}			
			?>
		</tbody>
	</table>
	
	<?php
	
	$final_options['settings']['header'] = __('other locations', true); 
	$structures->build( $final_atim_structure, $final_options );
	
	?>
	<table class="structure otherLocations mainRules">
		<thead>
			<tr>
				<td></td>
				<th colspan="3"><?php echo(__('lungs', true)); ?></th>
				<th colspan="3"><?php echo(__('lymph node', true)); ?></th>
				<th colspan="3"><?php echo(__('colon', true)); ?></th>
				<th colspan="3"><?php echo(__('rectum', true)); ?></th>
				<th colspan="3"><?php echo(__('bones', true)); ?></th>
			</tr>
			<tr>
				<td></td>
				<th><?php echo(__('number', true)); ?></th>
				<th><?php echo(__('size', true)); ?></th>
				<th class="rightBorder"><?php echo(__('localisation', true)); ?></th>
				<th><?php echo(__('number', true)); ?></th>
				<th><?php echo(__('size', true)); ?></th>
				<th class="rightBorder"><!-- empty for styling purposes --></th>
				<th><?php echo(__('number', true)); ?></th>
				<th><?php echo(__('size', true)); ?></th>
				<th class="rightBorder"><!-- empty for styling purposes --></th>
				<th><?php echo(__('number', true)); ?></th>
				<th><?php echo(__('size', true)); ?></th>
				<th class="rightBorder"><!-- empty for styling purposes --></th>
				<th><?php echo(__('number', true)); ?></th>
				<th class="rightBorder"><?php echo(__('size', true)); ?></th>
			</tr>
		</thead>
		<tbody>
	<?php 
	foreach($this->data as $data){
		if(strpos($data['EventControl']['form_alias'], 'other') > 0){
			?>
			<tr>
				<th><?php echo(substr($data['EventControl']['event_type'], 16)) ?> - <?php echo($structures->formatDate($data['EventMaster']['event_date'])); ?></th>
				<td><?php echo($data['EventDetail']['lungs_number']) ?></td>
				<td><?php echo($data['EventDetail']['lungs_size']) ?></td>
				<td><?php echo($data['EventDetail']['lungs_laterality']) ?></td>
				<td><?php echo($data['EventDetail']['lymph_node_number']) ?></td>
				<td><?php echo($data['EventDetail']['lymph_node_size']) ?></td>
				<td></td>
				<td><?php echo($data['EventDetail']['colon_number']) ?></td>
				<td><?php echo($data['EventDetail']['colon_size']) ?></td>
				<td></td>
				<td><?php echo($data['EventDetail']['rectum_number']) ?></td>
				<td><?php echo($data['EventDetail']['rectum_size']) ?></td>
				<td></td>
				<td><?php echo($data['EventDetail']['bones_number']) ?></td>
				<td><?php echo($data['EventDetail']['bones_size']) ?></td>
				
			</tr>
			<?php 
		}
	}
	?>
		</tbody>
	</table>
	<?php
	
	$final_options['settings']['header'] = __('pancreas', true); 
	$structures->build( $final_atim_structure, $final_options );

	?>
	<table class="structure mainRules pancreas">
		<thead>
			<tr>
				<td></td>
				<th><?php echo(__('hepatic artery', true)); ?></th>
				<th><?php echo(__('coeliac trunk', true)); ?></th>
				<th><?php echo(__('splenic artery', true)); ?></th>
				<th><?php echo(__('superior esenteric artery', true)); ?></th>
				<th><?php echo(__('portal vein', true)); ?></th>
				<th><?php echo(__('superior mesenteric vein', true)); ?></th>
				<th><?php echo(__('splenic vein', true)); ?></th>
			</tr>
		</thead>
		<tbody>
		<?php 
			foreach($this->data as $data){
				?>
				<tr>
					<th><?php echo(substr($data['EventControl']['event_type'], 16)) ?> - <?php echo($structures->formatDate($data['EventMaster']['event_date'])); ?></th>
					<td><?php echo($data['EventDetail']['hepatic_artery']); ?></td>
					<td><?php echo($data['EventDetail']['coeliac_trunk']); ?></td>
					<td><?php echo($data['EventDetail']['splenic_artery']); ?></td>
					<td><?php echo($data['EventDetail']['superior_esenteric_artery']); ?></td>
					<td><?php echo($data['EventDetail']['portal_vein']); ?></td>
					<td><?php echo($data['EventDetail']['superior_mesenteric_vein']); ?></td>
					<td><?php echo($data['EventDetail']['splenic_vein']); ?></td>
				</tr>
				<?php 
			}
		?>
		</tbody>
	</table>
	<?php

	unset($final_options['settings']['header']);
	$final_options['settings']['form_bottom'] = true;
	$final_options['settings']['actions'] = true;
	$structures->build( $final_atim_structure, $final_options );

?>