<?php

// 1- DIAGNOSTICS
$detailLinks = array();
foreach ($this->data as $newEvent) {
    $detailLinks[__($newEvent['EventControl']['event_type']) . ' ' . $newEvent['EventMaster']['formated_event_date']] = '/ClinicalAnnotation/EventMasters/detail/' . $newEvent['EventMaster']['participant_id'] . '/' . $newEvent['EventMaster']['id'];
}
$structureLinks = array(
    'index' => array(
        'detail' => '/ClinicalAnnotation/EventMasters/imageryReport/' . $atimMenuVariables['Participant.id']
    ),
    'bottom' => array(
        'detail' => $detailLinks
    )
);

$structureSettings = array(
    'form_bottom' => false,
    'form_inputs' => false,
    'actions' => false,
    'pagination' => false,
    'header' => __('liver segments', null)
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'type' => 'detail',
    'settings' => $structureSettings
);
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<style>
thead {
	background-color: #374D61;
	color: #FFFFFF;
}

.segment thead tr:nth-child(1) th {
	border-right-style: solid;
	border-width: 2px;
}

.segment thead tr:nth-child(2) th:nth-child(even) {
	border-right-style: solid;
	border-width: 2px;
}

.otherLocations thead tr:nth-child(1) th {
	border-right-style: solid;
	border-width: 2px;
}

.pancreas thead th {
	border-right-style: solid;
	border-width: 2px;
}

.mainRules tbody {
	text-align: center;
	vertical-align: bottom;
}

.mainRules tbody th {
	/* fits with the core css*/
	padding: 10px 0px;
}

.mainRules tbody tr:nth-child(odd) {
	background-color: #ddd;
}

.mainRules tbody td {
	border-color: #eee;
	border-style: solid;
	border-width: 1px;
}

.mainRules {
	width: 100%;
}

.no_data_available {
	text-align: center;
}
</style>
<table class="structure">
	<!-- frame table -->
	<tr>
			<?php
// is there segment data?
$found = false;
foreach ($this->data as $data) {
    if (strpos($data['EventControl']['form_alias'], 'segment') > 0) {
        $found = true;
        break;
    }
}
if ($found) {
    ?>
			<td>
			<div style="margin: 10px; border: 1px solid;">
				<table class="mainRules segment">
					<!-- content table -->
					<thead>
						<tr>
							<th rowspan="2"><?php echo(__('imagery', true))?></th>
							<th colspan="2"><?php echo(__('segment', true))?> I</th>
							<th colspan="2"><?php echo(__('segment', true))?> II</th>
							<th colspan="2"><?php echo(__('segment', true))?> III</th>
							<th colspan="2"><?php echo(__('segment', true))?> IV</th>
							<th colspan="2"><?php echo(__('segment', true))?> IVa</th>
							<th colspan="2"><?php echo(__('segment', true))?> IVb</th>
							<th colspan="2"><?php echo(__('segment', true))?> V</th>
							<th colspan="2"><?php echo(__('segment', true))?> VI</th>
							<th colspan="2"><?php echo(__('segment', true))?> VII</th>
							<th colspan="2"><?php echo(__('segment', true))?> VIII</th>
							<th colspan="3"><?php echo(__('other segment', true))?></th>
							<th colspan="2"><?php echo(__('other', true))?></th>
						</tr>
						<tr>
								<?php for($i = 0; $i < 10; ++ $i){ ?>
									<th><?php echo(__('number', true)); ?></th>
							<th><?php echo(__('size', true)); ?></th>
								<?php } ?>
								<th><?php echo(__('multi', true)); ?></th>
							<th style="border-right-style: none;"><?php echo(__('size', true)); ?></th>
							<th style="border-right-style: solid; border-width: 2px;"><?php echo(__('location', true)); ?></th>
							<th style="border-right-style: none;"><?php echo(__('density (iu)', true)); ?></th>
							<th style="border-right-style: solid; border-width: 2px;"><?php echo(__('type', true)); ?></th>
						</tr>
					</thead>
					<tbody>
							<?php
    foreach ($this->data as $data) {
        if (strpos($data['EventControl']['form_alias'], 'segment') > 0) {
            ?>
								<tr>
							<th><?php echo(__($data['EventControl']['event_type'],true)); ?> - <?php echo($data['EventMaster']['formated_event_date']); ?></th>
									<?php
            for ($i = 1; $i < 5; ++ $i) {
                ?><td><?php echo($data['EventDetail']['segment_'.$i.'_number']); ?></td>
							<td><?php echo($data['EventDetail']['segment_'.$i.'_size']); ?></td>
									<?php } ?>
									<td><?php echo($data['EventDetail']['segment_4a_number']); ?></td>
							<td><?php echo($data['EventDetail']['segment_4a_size']); ?></td>
							<td><?php echo($data['EventDetail']['segment_4b_number']); ?></td>
							<td><?php echo($data['EventDetail']['segment_4b_size']); ?></td>
									<?php
            for ($i = 5; $i < 9; ++ $i) {
                ?><td><?php echo($data['EventDetail']['segment_'.$i.'_number']); ?></td>
							<td><?php echo($data['EventDetail']['segment_'.$i.'_size']); ?></td>
									<?php } ?>
									<td><?php echo(str_replace(array('y','n'),array(__('yes',true),__('no',true)),$data['EventDetail']['other_segment_is_multi'])); ?></td>
							<td><?php echo($data['EventDetail']['other_segment_size']); ?></td>
							<td><?php echo(__($data['EventDetail']['other_segment_location'], true)); ?></td>
							<td><?php echo($data['EventDetail']['density']); ?></td>
							<td><?php echo(__($data['EventDetail']['type'])); ?></td>
						</tr>
								<?php
        }
    }
    ?>
						</tbody>
				</table>
			</div>
		</td>
			<?php
} else {
    ?><td class="no_data_available" colspan="7"><?php echo(__( 'core_no_data_available', false)); ?></td><?php
}
?>
		</tr>
</table>

<?php

$finalOptions['settings']['header'] = __('other localisations', true);
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<table class="structure">
	<!-- frame table -->
	<tr>
			<?php
// is there other data?
$found = false;
foreach ($this->data as $data) {
    if (strpos($data['EventControl']['form_alias'], 'other') > 0) {
        $found = true;
        break;
    }
}
if ($found) {
    ?>
			<td>
			<div style="margin: 10px; border: 1px solid;">
				<table class="mainRules otherLocations">
					<thead>
						<tr>
							<th rowspan="2"><?php echo(__('imagery', true))?></th>
							<th colspan="3"><?php echo(__('lungs', true)); ?></th>
							<th colspan="2"><?php echo(__('lymph node', true)); ?></th>
							<th colspan="2"><?php echo(__('colon', true)); ?></th>
							<th colspan="2"><?php echo(__('rectum', true)); ?></th>
							<th colspan="2"><?php echo(__('bones', true)); ?></th>
							<th colspan="2"><?php echo(__('bile ducts', true)); ?></th>
						</tr>
						<tr>
							<th><?php echo(__('number', true)); ?></th>
							<th><?php echo(__('size', true)); ?></th>
							<th style="border-right-style: solid; border-width: 2px;"><?php echo(__('localisation', true)); ?></th>
							<th><?php echo(__('number', true)); ?></th>
							<th style="border-right-style: solid; border-width: 2px;"><?php echo(__('size', true)); ?></th>
							<th><?php echo(__('number', true)); ?></th>
							<th style="border-right-style: solid; border-width: 2px;"><?php echo(__('size', true)); ?></th>
							<th><?php echo(__('number', true)); ?></th>
							<th style="border-right-style: solid; border-width: 2px;"><?php echo(__('size', true)); ?></th>
							<th><?php echo(__('number', true)); ?></th>
							<th style="border-right-style: solid; border-width: 2px;"><?php echo(__('size', true)); ?></th>
							<th><?php echo(__('number', true)); ?></th>
							<th style="border-right-style: solid; border-width: 2px;"><?php echo(__('size', true)); ?></th>
						</tr>
					</thead>
					<tbody>
					<?php
    foreach ($this->data as $data) {
        if (strpos($data['EventControl']['form_alias'], 'other') > 0) {
            ?>
							<tr>
							<th><?php echo(__($data['EventControl']['event_type'],true)) ?> - <?php echo($data['EventMaster']['formated_event_date']); ?></th>
							<td><?php echo($data['EventDetail']['lungs_number']) ?></td>
							<td><?php echo($data['EventDetail']['lungs_size']) ?></td>
							<td><?php echo(__($data['EventDetail']['lungs_laterality'])) ?></td>
							<td><?php echo($data['EventDetail']['lymph_node_number']) ?></td>
							<td><?php echo($data['EventDetail']['lymph_node_size']) ?></td>
							<td><?php echo($data['EventDetail']['colon_number']) ?></td>
							<td><?php echo($data['EventDetail']['colon_size']) ?></td>
							<td><?php echo($data['EventDetail']['rectum_number']) ?></td>
							<td><?php echo($data['EventDetail']['rectum_size']) ?></td>
							<td><?php echo($data['EventDetail']['bones_number']) ?></td>
							<td><?php echo($data['EventDetail']['bones_size']) ?></td>
							<td><?php echo($data['EventDetail']['bile_ducts_number']) ?></td>
							<td><?php echo($data['EventDetail']['bile_ducts_size']) ?></td>
						</tr>
							<?php
        }
    }
    ?>
						</tbody>
				</table>
			</div>
		</td>
			<?php
} else {
    ?><td class="no_data_available" colspan="1"><?php echo(__( 'core_no_data_available', false)); ?></td><?php
}
?>
		</tr>
</table>
<?php

$finalOptions['settings']['header'] = __('pancreas', true);
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<table class="structure">
	<!-- frame table -->
	<tr>
			<?php
// is there pancreas data?
$found = false;
foreach ($this->data as $data) {
    if (strpos($data['EventControl']['form_alias'], 'pancreas') > 0) {
        $found = true;
        break;
    }
}
if ($found) {
    ?>
			<td>
			<div style="margin: 10px; border: 1px solid;">
				<table class="mainRules pancreas">
					<thead>
						<tr>
							<th rowspan="2"><?php echo(__('imagery', true))?></th>
							<th><?php echo(__('hepatic artery', true)); ?></th>
							<th><?php echo(__('coeliac trunk', true)); ?></th>
							<th><?php echo(__('splenic artery', true)); ?></th>
							<th><?php echo(__('superior mesenteric artery', true)); ?></th>
							<th><?php echo(__('portal vein', true)); ?></th>
							<th><?php echo(__('superior mesenteric vein', true)); ?></th>
							<th><?php echo(__('splenic vein', true)); ?></th>
							<th><?php echo(__('metastatic lymph nodes', true)); ?></th>
							<th><?php echo(__('number', true)); ?></th>
							<th><?php echo(__('size (cm)', true)); ?></th>
						</tr>
					</thead>
					<tbody>
						<?php
    foreach ($this->data as $data) {
        if (strpos($data['EventControl']['form_alias'], 'pancreas') > 0) {
            ?>
								<tr>
							<th><?php echo(__($data['EventControl']['event_type'],true)) ?> - <?php echo($data['EventMaster']['formated_event_date']); ?></th>
							<td><?php echo(__($data['EventDetail']['hepatic_artery'])); ?></td>
							<td><?php echo(__($data['EventDetail']['coeliac_trunk'])); ?></td>
							<td><?php echo(__($data['EventDetail']['splenic_artery'])); ?></td>
							<td><?php echo(__($data['EventDetail']['superior_mesenteric_artery'])); ?></td>
							<td><?php echo(__($data['EventDetail']['portal_vein'])); ?></td>
							<td><?php echo(__($data['EventDetail']['superior_mesenteric_vein'])); ?></td>
							<td><?php echo(__($data['EventDetail']['splenic_vein'])); ?></td>
							<td><?php echo(__($data['EventDetail']['metastatic_lymph_nodes'])); ?></td>
							<td><?php echo($data['EventDetail']['pancreas_number']); ?></td>
							<td><?php echo($data['EventDetail']['pancreas_size']); ?></td>
						</tr>
								<?php
        }
    }
    ?>
						</tbody>
				</table>
			</div>
		</td>
			<?php
} else {
    ?><td class="no_data_available" colspan="1"><?php echo(__( 'core_no_data_available', false)); ?></td><?php
}
?>
		</tr>
</table>
<?php
$finalOptions['settings']['header'] = __('summaries', true);
$this->Structures->build($finalAtimStructure, $finalOptions);
?>
<table class="structure">
	<!-- frame table -->
	<tr>
			<?php
// is there data?
if (isset($data) && sizeof($data) > 0) {
    ?>
			<td>
			<div style="margin: 10px; border: 1px solid;">
				<table class="mainRules summaries">
					<thead>
						<tr>
							<th><?php echo(__('imagery', true))?></th>
							<th><?php echo(__('summary', true))?></th>
						</tr>
					</thead>
					<tbody>
						<?php
    foreach ($this->data as $data) {
        ?>
							<tr>
							<th><?php echo(__($data['EventControl']['event_type'],true)) ?> - <?php echo($data['EventMaster']['formated_event_date']); ?></th>
							<td><?php echo($data['EventMaster']['event_summary']); ?></td>
						</tr>
							<?php
    }
    ?>
						</tbody>
				</table>
			</div>
		</td>
			<?php
} else {
    ?><td class="no_data_available" colspan="1"><?php echo(__( 'core_no_data_available', false)); ?></td><?php
}
?>
		</tr>
</table>
<?php
unset($finalOptions['settings']['header']);
$finalOptions['settings']['form_bottom'] = true;
$finalOptions['settings']['actions'] = true;
$this->Structures->build($finalAtimStructure, $finalOptions);

?>