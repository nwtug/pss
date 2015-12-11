<?php
/**
 * This class generates and formats bid details. 
 *
 * @author Al Zziwa <azziwa@newwavetech.co.ug>
 * @version 1.0.0
 * @copyright PSS
 * @created 11/15/2015
 */
class _bid extends CI_Model
{
	# advanced search list of bids
	function lists($status, $scope=array('pde'=>'', 'provider'=>'', 'phrase'=>'', 'offset'=>'0', 'limit'=>NUM_OF_ROWS_PER_PAGE))
	{
		$scope['pde'] = ($this->native_session->get('__user_type') == 'pde')? $this->native_session->get('__organization_id'): $scope['pde'];
		
		return $this->_query_reader->get_list('get_bid_list', array(
			'provider_condition'=>(!empty($scope['provider'])? " AND _organization_id='".$scope['provider']."' ": ''),
			
			'phrase_condition'=>(!empty($scope['phrase'])? " HAVING tender_notice LIKE '%".htmlentities($scope['phrase'], ENT_QUOTES)."%' ": ''),
			
			'pde_condition'=>(!empty($scope['pde'])? (!empty($scope['phrase'])? ' AND ': ' HAVING ')." pde_id = '".$scope['pde']."' ": ''),
			
			'status_condition'=>($status == 'awards'? " AND status = 'awarded' ": ($status == 'best_bidders'? " AND status IN ('won','short_list') ": " AND status NOT IN ('short_list','won','awarded') ")), 
			
			'limit_text'=>" LIMIT ".$scope['offset'].",".$scope['limit']." "
		));
	}
	
	
	
	
	
	# view list of bids by tender notice
	function view_list($noticeId, $scope=array('offset'=>'0', 'limit'=>NUM_OF_ROWS_PER_PAGE))
	{
		return $this->_query_reader->get_list('get_bid_list', array(
			'provider_condition'=>'',
			'phrase_condition'=>" AND _tender_notice_id='".$noticeId."' ",
			'pde_condition'=>'',
			'status_condition'=>" AND status NOT IN ('saved', 'rejected', 'archived') ", 
			'limit_text'=>" LIMIT ".$scope['offset'].",".$scope['limit']." "
		));
	}
	
	
	
	
	
	
	# view my list of bids
	function my_list($scope=array('pde'=>'', 'phrase'=>'', 'status'=>'', 'offset'=>'0', 'limit'=>NUM_OF_ROWS_PER_PAGE))
	{
		return $this->_query_reader->get_list('get_my_bid_list', array(
			'pde_condition'=>(!empty($scope['pde'])? " AND pde_id='".$scope['pde']."' ": ''),
			'status_condition'=>(!empty($scope['status'])? " AND status = '".$scope['status']."' ": ''), 
			'phrase_condition'=>(!empty($scope['phrase'])? " AND tender_notice LIKE '%".htmlentities($scope['phrase'], ENT_QUOTES)."%' ": '')." AND _organization_id='".$this->native_session->get('__organization_id')."' ", 
			'limit_text'=>" LIMIT ".$scope['offset'].",".$scope['limit']." "
		));
	}
	
	
	
	
	
	# add a bid
	function add($data)
	{
		$result = FALSE;
		
		# a) save the main record
		$bidId = $this->_query_reader->add_data((!empty($data['bidid'])? 'update': 'add').'_bid_record', array(
				'tender_id'=>$data['tender_id'], 
				'summary'=>htmlentities($data['summary'], ENT_QUOTES), 
				'bid_currency'=>$data['currency_code'], 
				'bid_amount'=>$data['amount'], 
				'status'=>$data['bid__bidstatus'], 
				'valid_start_date'=>date('Y-m-d',strtotime(make_us_date($data['valid_from']))), 
				'valid_end_date'=>date('Y-m-d',strtotime(make_us_date($data['valid_to']))), 
				'user_id'=>$this->native_session->get('__user_id'),
				'organization_id'=>(!empty($data['provider_id'])? $data['provider_id']: $this->native_session->get('__organization_id')),
				'bid_id'=>(!empty($data['bidid'])? $data['bidid']: '')
			));
		
		# save the status record
		if(!empty($bidId) || (!empty($data['bidid']) && $data['bid__bidstatus'] != 'saved')) {
			$result = $this->_query_reader->run('add_bid_status', array(
						'bid_id'=>(!empty($data['bidid'])? $data['bidid']: $bidId), 
						'status'=>$data['bid__bidstatus'], 
						'user_id'=>$this->native_session->get('__user_id') 
					  ));
		}
		
		# save the document records
		if($result || !(!empty($data['bidid']) && $data['bid__bidstatus'] != 'saved')) {
			# updating the bid record? remove the old documents first
			if(!empty($data['bidid']) && !empty($data['documents'])){
				$result = $this->_query_reader->run('remove_bid_documents', array('bid_id'=>$data['bidid']));
				if($result && !empty($data['olddocuments'])) {
					$documents = explode(',',$data['olddocuments']);
					foreach($documents AS $document) @unlink(UPLOAD_DIRECTORY.$document);
				}
			}
			
			# adding the new documents
			foreach($data['documents'] AS $document) {
				$result = $this->_query_reader->run('add_bid_document', array('bid_id'=>(!empty($data['bidid'])? $data['bidid']: $bidId), 'document_url'=>$document, 'user_id'=>$this->native_session->get('__user_id')));
			}
		}
		
		# log action
		$this->_logger->add_event(array(
			'user_id'=>$this->native_session->get('__user_id'), 
			'activity_code'=>(!empty($data['bidid'])? 'update': 'add').'_bid', 
			'result'=>($result? 'SUCCESS': 'FAIL'), 
			'log_details'=>"bidstatus=".$data['bid__bidstatus']."|device=".get_user_device()."|browser=".$this->agent->browser(),
			'uri'=>uri_string(),
			'ip_address'=>get_ip_address()
		));
		
		return array('boolean'=>$result, 'reason'=>'');
	}
	
	
	
	
	
	# view one bid's details
	function details($spec = array('tender_id'=>'', 'bid_id'=>''))
	{
		# if only the tender id is given
		if(!empty($spec['tender_id']) && empty($spec['bid_id'])) {
			return $this->_query_reader->get_row_as_array('get_my_bid_list', array(
				'pde_condition'=>" AND _tender_notice_id='".$spec['tender_id']."' AND _organization_id='".$this->native_session->get('__organization_id')."' ", 
				'submit_period'=>'', 
				'status_condition'=>'', 
				'phrase_condition'=>'',
				'limit_text'=>" LIMIT 1 "
			));
		} 
		
		# if the bid id is given
		else if(!empty($spec['bid_id'])) {
			return $this->_query_reader->get_row_as_array('get_my_bid_list', array('pde_condition'=>" AND id='".$spec['bid_id']."' ", 'submit_period'=>'', 'status_condition'=>'','phrase_condition'=>'', 'limit_text'=>" LIMIT 1 "));
		}
		
		# if the tender id is given - get the bid details for editing
		else if(!empty($spec['tender_id'])) {
			return $this->_query_reader->get_row_as_array('get_bid_details_by_tender', array('tender_id'=>$spec['tender_id'], 'organization_id'=>$this->native_session->get('__organization_id') ));
		}
		
		# no identifing info is provided
		else return array();
	}
	
	
	
	
	
	# view  bid's summary
	function summary($bidId)
	{
		$data = $this->_query_reader->get_row_as_array('get_basic_bid', array('bid_id'=>$bidId));
		return !empty($data['summary'])? html_entity_decode($data['summary'], ENT_QUOTES): '';
	}
	
	
	
	# update bid status
	function update_status($newStatus, $bidIds)
	{
		$msg = '';
		$bids = implode("','",$bidIds);
		#'under_review', 'short_list'
		$status = array('under_review'=>'under_review', 'short_list'=>'short_list', 'mark_as_won'=>'won', 'mark_as_awarded'=>'awarded', 'retract_win'=>'under_review', 'reject_bid'=>'rejected', 'retract_award'=>'under_review', 'submit_bid'=>'submitted', 'mark_as_archived'=>'archived', 'mark_as_completed'=>'complete');
		
		# update status trail
		$result = $this->_query_reader->run('update_status_trail', array('bid_ids'=>$bids));
		
		# add the new status to the bid status trail
		if($result) $result = $this->_query_reader->run('add_status_trail', array('new_status'=>$status[$newStatus], 'bid_ids'=>$bids, 'user_id'=>$this->native_session->get('__user_id') ));
		
		# update the actual bid record status
		if($result) $result = $this->_query_reader->run('update_bid_status', array('new_status'=>$status[$newStatus], 'bid_ids'=>$bids, 'user_id'=>$this->native_session->get('__user_id') ));
		
		# submit bid - if the new status is submitted
		if($result && $status[$newStatus] == 'submitted') $result = $this->_query_reader->run('submit_provider_bid', array('bid_ids'=>$bids, 'user_id'=>$this->native_session->get('__user_id') ));
		
		
		# notify provider about change of status, if not made by them
		if($this->native_session->get('__user_type') != 'provider') {
			$sent = array();
			foreach($bidIds AS $bidId) {
				$providerUserIds = $this->_query_reader->get_single_column_as_array('get_bid_provider_users', 'user_id', array('bid_id'=>$bidId));
				$bid = $this->details(array('bid_id'=>$bidId));
				if(!empty($providerUserIds) && !empty($bid)){
					$sentResult = $this->_messenger->send($providerUserIds, array(
						'code'=>'bid_status_changed',
						'newstatus'=>$status[$newStatus], 
						'pde'=>$bid['pde'], 
						'summary'=>$bid['summary'],
						'tendernotice'=>$bid['tender_notice'],
						'datesubmitted'=>date(SHORT_DATE_FORMAT, strtotime($bid['date_submitted']))
					));
					array_push($sent, $sentResult);
				}
			}
			if(!get_decision($sent)) $msg = 'Status change notification could not be sent.';
		}
		else $sent = array(TRUE);
		
		if(!$result) $msg = 'Data commit coult not be completed.';
		$finalResult = $result && get_decision($sent);
		
		# log action
		$this->_logger->add_event(array(
			'user_id'=>$this->native_session->get('__user_id'), 
			'activity_code'=>'bid_status_change', 
			'result'=>($finalResult? 'SUCCESS': 'FAIL'), 
			'log_details'=>"newstatus=".$status[$newStatus]."|device=".get_user_device()."|browser=".$this->agent->browser(),
			'uri'=>uri_string(),
			'ip_address'=>get_ip_address()
		));
		
		return array('boolean'=>$finalResult, 'reason'=>$msg);
	}
	
	
	
	
	
	# send a message to the selected bids
	function message($data)
	{
		$sent = $notSent = array();
		$users = $this->_query_reader->get_list('get_users_in_bid_organizations',array('bid_ids'=>implode("','",explode(',',$data['idlist'])) ));
		$message = array('code'=>'custom_internal_message', 'subject'=>$data['reason__contactreason'], 'details'=>$data['details']);
		
		foreach($users AS $row) {
			$result = $this->_messenger->send($row['user_id'], $message, array('email'),TRUE);
			if($result) array_push($sent, $row['email_address']);
			else array_push($notSent, $row['email_address']);
		}
		
		return array('boolean'=>!(empty($sent) && !empty($notSent)), 'not_sent'=>$notSent);		
	}
	
	
	
}
?>